//
//  uGoSettings.m
//  uGo
//
//  Created by Jacob Farkas on 7/20/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "uGoSettings.h"

NSString * const kBoardSizeChangedNotification = @"BoardSizeChanged";

static uGoSettings *_sSettings;

@implementation uGoSettings

+ (uGoSettings *)sharedSettings
{
    if (_sSettings == nil) {
        _sSettings = [[uGoSettings alloc] init];
    }
    return _sSettings;
}

- (id) init
{
    if ((self = [super init])) {
        _boardSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"BoardSize"];
        if (_boardSize == 0) _boardSize = 19;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}
         
- (NSUInteger) boardSize
{
    return _boardSize;
}

- (void) setBoardSize:(NSUInteger)boardSize
{
    _boardSize = boardSize;
    [[NSUserDefaults standardUserDefaults] setInteger:boardSize forKey:@"BoardSize"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBoardSizeChangedNotification object:nil];
}
         
@end
