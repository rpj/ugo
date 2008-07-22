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
                NSString *className = [NSString stringWithUTF8String:class_getName(curClass)];
                NSLog(@"Found theme class: %@", className);
                [themes addObject:className];
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
        
        _themeName = [[NSUserDefaults standardUserDefaults] valueForKey:@"ThemeName"];
        if (_themeName == nil) _themeName = @"FlatTheme";
        
        [self _loadThemeClasses];
    }
    return self;
}

- (void) dealloc
{
    [_themeName release];
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

- (NSString *) themeName { return _themeName; }
- (void) setThemeName:(NSString*)themeName
{
    _themeName = [themeName copy];
    [[NSUserDefaults standardUserDefaults] setValue:_themeName forKey:@"ThemeName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMarkerThemeChangedNotification object:nil];
}

@end
