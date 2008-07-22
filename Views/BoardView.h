//
//  BoardView.h
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoMarker.h"

#define kBoardSize 1280

@class GridLayer, MarkerLayer;
@protocol BoardViewDelegate;

@interface BoardView : UIView {
	GridLayer*          _gridLayer;
    MarkerLayer*        _markerLayer;
    
    id                  _delegate;
}

@property (nonatomic, retain) GridLayer* gridLayer;
@property (nonatomic, retain) MarkerLayer* markerLayer;
@property (nonatomic, assign) id<BoardViewDelegate> delegate;

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options;
- (void) removeMarkerAtLocation:(CGPoint)boardLocation;
- (void) removeAllMarkers;

@end

@protocol BoardViewDelegate
- (void) locationWasTouched:(CGPoint)boardLocation tapCount:(NSUInteger)tapCount;
@end
