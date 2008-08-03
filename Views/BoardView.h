//
//  BoardView.h
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoMarker.h"

@class GridLayer, GoBoard, GoReferee, MarkerLayer;
@protocol BoardViewDelegate;

@interface BoardView : UIView {
	GridLayer*          _gridLayer;
    MarkerLayer*        _markerLayer;
	
	GoBoard*			_board;
	GoReferee*			_referee;
    
    id                  _delegate;
    
    CGFloat             _boardSize;
}

@property (nonatomic, retain) GridLayer* gridLayer;
@property (nonatomic, retain) MarkerLayer* markerLayer;
@property (nonatomic, retain) GoReferee* referee;
@property (nonatomic, assign) id<BoardViewDelegate> delegate;

@property (nonatomic, assign) CGFloat boardSize;

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options;
- (void) removeAllMarkersAtLocation:(CGPoint)boardLocation;
- (void) removeAllMarkers;

@end

@protocol BoardViewDelegate
- (void) locationWasTouched:(CGPoint)boardLocation tapCount:(NSUInteger)tapCount;
@end
