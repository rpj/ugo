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

#import "BoardView.h"

@interface MarkerLayer : CALayer {
    NSMutableArray*     _allMarkers;
}

- (void) gridSizeChanged;

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options;
- (void) removeMarkerAtLocation:(CGPoint)boardLocation;
- (void) removeAllMarkers;

@end
