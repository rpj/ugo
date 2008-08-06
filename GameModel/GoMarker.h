//
//  GoMarker.h
//  uGo
//
//  Created by Jacob Farkas on 8/5/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoTypes.h"

@interface GoMarker : NSObject {
    GoMarkerType _type;
    CGPoint _location;
    UIColor *_color;
    NSString *_label;
    BOOL _isTemporary;
    BOOL _allowWiggle;
}

+ (GoMarker *) markerOfType:(GoMarkerType)type atLocation:(CGPoint)location;

@property (nonatomic, readonly) GoMarkerType type;
@property (nonatomic, readonly) CGPoint location;

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, assign) BOOL isTemporary;
@property (nonatomic, assign) BOOL allowWiggle;

@end
