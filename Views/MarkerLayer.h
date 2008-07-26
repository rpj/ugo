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

@class MarkerTheme;

@interface MarkerLayer : CALayer {
    // I'm not sure if using a set is going to be too slow or not. It sure is easier to program.
    NSMutableSet*       _allMarkers;
    MarkerTheme*        _theme;
    
    NSUInteger          _boardSize;
}

@property(nonatomic, retain) MarkerTheme *theme;

@end