//
//  uGoSettings.h
//  uGo
//
//  Created by Jacob Farkas on 7/20/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kBoardSizeChangedNotification;
extern NSString * const kMarkerThemeChangedNotification;

@interface uGoSettings : NSObject {
    NSUInteger  _boardSize;
    NSString *  _themeName;
    NSArray*    _allThemes;
}

@property (nonatomic) NSUInteger boardSize;
@property (nonatomic,copy) NSString *themeName;
@property (nonatomic,readonly) NSArray *allThemes; // array of MarkerTheme class names

+ (uGoSettings *)sharedSettings;

@end
