//
//  uGoSettings.h
//  uGo
//
//  Created by Jacob Farkas on 7/20/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarkerTheme;

extern NSString * const kBoardSizeChangedNotification;
extern NSString * const kMarkerThemeChangedNotification;

@interface uGoSettings : NSObject {
    NSUInteger      _boardSize;
    MarkerTheme *   _markerTheme;
    NSArray*        _allThemes;
}

@property (nonatomic) NSUInteger boardSize;
@property (nonatomic,retain) MarkerTheme *markerTheme;
@property (nonatomic,readonly) NSArray *allThemes; // array of MarkerTheme subclass instances

+ (uGoSettings *)sharedSettings;

@end
