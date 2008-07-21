//
//  uGoSettings.h
//  uGo
//
//  Created by Jacob Farkas on 7/20/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kBoardSizeChangedNotification;

@interface uGoSettings : NSObject {
    NSUInteger _boardSize;
}

@property (nonatomic) NSUInteger boardSize;

+ (uGoSettings *)sharedSettings;

@end
