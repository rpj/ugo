//
//  uGoSettings.m
//  uGo
//
//  Created by Jacob Farkas on 7/20/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "uGoSettings.h"
#import "MarkerTheme.h"

#import <objc/runtime.h>

NSString * const kBoardSizeChangedNotification = @"BoardSizeChanged";
NSString * const kMarkerThemeChangedNotification = @"MarkerThemeChanged";

static uGoSettings *_sSettings;

@interface NSObject (ClassName)
- (NSString *)getClassName;
@end

@implementation NSObject (ClassName)
- (NSString *)getClassName
{
    return [NSString stringWithUTF8String:object_getClassName(self)];
}
@end

@implementation uGoSettings

@synthesize allThemes = _allThemes;

+ (uGoSettings *)sharedSettings
{
    if (_sSettings == nil) {
        _sSettings = [[uGoSettings alloc] init];
    }
    return _sSettings;
}

- (void) _loadThemeClasses
{
    NSMutableArray *themes = [[NSMutableArray alloc] init];
    Class markerThemeClass = [MarkerTheme class];
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        Class *allClasses = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(allClasses, numClasses);
        for (int ii = 0; ii < numClasses; ii++) {
            Class curClass = allClasses[ii];
            if (class_getSuperclass(curClass) == markerThemeClass) {
                NSLog(@"Found theme class: %s", class_getName(curClass));
                [themes addObject:[[[curClass alloc] init] autorelease]];
            }
        }
        free(allClasses);
    }
    [_allThemes release];
    _allThemes = themes;
}

- (id) init
{
    if ((self = [super init])) {
        _boardSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"BoardSize"];
        if (_boardSize == 0) _boardSize = 19;
        
        [self _loadThemeClasses];
        
        NSString *themeName = [[NSUserDefaults standardUserDefaults] valueForKey:@"ThemeName"];
        if (themeName == nil) themeName = @"GobanStonesTheme";
        
        for (MarkerTheme *theme in _allThemes) {
            if ([[theme getClassName] isEqualToString:themeName]) {
                _markerTheme = [theme retain];
                break;
            }
        }
    }
    return self;
}

- (void) dealloc
{
    [_markerTheme release];
    [_allThemes release];
    [super dealloc];
}
         
- (NSUInteger) boardSize { return _boardSize; }

- (void) setBoardSize:(NSUInteger)boardSize
{
    _boardSize = boardSize;
    [[NSUserDefaults standardUserDefaults] setInteger:boardSize forKey:@"BoardSize"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBoardSizeChangedNotification object:nil];
}

- (MarkerTheme *) markerTheme { return _markerTheme; }
- (void) setMarkerTheme:(MarkerTheme*)theme
{
    if (theme != _markerTheme) {
        [_markerTheme release];
        _markerTheme = [theme retain];
    }
    [[NSUserDefaults standardUserDefaults] setValue:[_markerTheme getClassName] forKey:@"ThemeName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMarkerThemeChangedNotification object:nil];
}

@end
