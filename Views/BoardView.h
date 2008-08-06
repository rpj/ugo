//
//  BoardView.h
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoMarker.h"

#define kGoBoardViewStatusUpdateNotification	@"BoardViewStatusUpdate"

@class GridLayer, GoBoard, GoMarker, MarkerLayer;

@protocol BoardViewDelegate
- (void) locationWasTouched:(CGPoint)boardLocation tapCount:(NSUInteger)tapCount;
@end

@interface BoardView : UIView {
	GridLayer*          _gridLayer;
    MarkerLayer*        _markerLayer;
    
    id                  _delegate;
    
    CGFloat             _boardSize;
}

@property (nonatomic, retain) GridLayer* gridLayer;
@property (nonatomic, retain) MarkerLayer* markerLayer;
@property (nonatomic, assign) id<BoardViewDelegate> delegate;

@property (nonatomic, assign) CGFloat boardSize;
@property (nonatomic, readonly) NSUInteger gameBoardSize;

// (fark): I don't like this. We're keeping two copies of the GoMarkers around. I need to refactor this in the future.
- (void) placeMarker:(GoMarker *)marker;
- (void) removeMarker:(GoMarker *)marker;
- (void) removeAllMarkers;
@end
