//
//  MarkerLayer.h
//  uGo
//
//  Created by Jacob Farkas on 7/21/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GoMarker.h"
#import "GoUtil.h"

@class MarkerTheme;

@interface MarkerLayer : CALayerNonAnimating {
    NSMutableArray*     _allMarkers;
    MarkerTheme*        _theme;
    
    NSUInteger          _boardSize;
}

@property (nonatomic, retain) MarkerTheme *theme;
@property (nonatomic) NSUInteger boardSize; 

@end
