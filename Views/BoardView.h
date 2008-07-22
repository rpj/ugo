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

@class BoardLayer, MarkerLayer;

@interface BoardView : UIView {
    BoardLayer*     _boardLayer;
    
    GoMarkerType    _curStone; // hack for testing
    CGPoint         _tempStoneLocation;
}

@property (nonatomic, retain) BoardLayer* _boardLayer;

- (void) drawGridOfSize: (NSInteger)size;

@end
