//
//  BoardLayer.h
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import "BoardView.h"

@class MarkerLayer;

@interface BoardLayer : CALayer {
	CALayer*            _gridLayer;
    MarkerLayer*        _markerLayer;
	
	NSUInteger	_gridSize;
	CGFloat		_gridInnerBorder;
    CGFloat     _lineSep;
}

@property (nonatomic, retain) CALayer* gridLayer;
@property (nonatomic, retain) CALayer* markerLayer;

// returns a point in Go board coordinates (1,1) to (boardSize,boardSize) for a given UIView coordinate
- (CGPoint) boardPointForUIPoint:(CGPoint)point;

- (void) drawGridOfSize:(NSInteger)size;

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options;
- (void) removeMarkerAtLocation:(CGPoint)boardLocation;
- (void) removeAllMarkers;

@end
