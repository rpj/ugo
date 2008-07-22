//
//  BoardView.h
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBoardSize 1280

typedef enum {
    kGoMarkerWhiteStone,
    kGoMarkerBlackStone,
    kGoMarkerShape,
    kGoMarkerLabel
} GoMarkerType;

// NSNumber (BOOL) for whether to display the marker as temporary 
extern NSString * const kGoMarkerOptionTemporaryMarker;
// UIColor of the marker
extern NSString * const kGoMarkerOptionColor;
// NSString to use as the label for the marker 
extern NSString * const kGoMarkerOptionLabel;

@class GridLayer, MarkerLayer;

@interface BoardView : UIView {
	GridLayer*          _gridLayer;
    MarkerLayer*        _markerLayer;
    
    // hacks so we can pretend to play go. these should not be allowed to live long
    GoMarkerType    _curStone;
    CGPoint         _tempStoneLocation;
}

@property (nonatomic, retain) GridLayer* gridLayer;
@property (nonatomic, retain) MarkerLayer* markerLayer;

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options;
- (void) removeMarkerAtLocation:(CGPoint)boardLocation;
- (void) removeAllMarkers;

@end
