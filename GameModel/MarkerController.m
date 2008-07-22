//
//  MarkerController.m
//  uGo
//
//  Created by Jacob Farkas on 7/22/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "MarkerController.h"
#import "BoardView.h"

@implementation MarkerController

- (id) init
{
    if ((self = [super init])) {
        _tempStoneLocation = CGPointMake(-1, -1);
        _curStone = kGoMarkerBlackStone;
    }
    return self;
}

- (void) setBoardView:(BoardView *)boardView
{
    boardView.delegate = self;
    _boardView = boardView;
}

- (BoardView *) boardView { return _boardView; }

- (void) locationWasTouched:(CGPoint)boardLocation tapCount:(NSUInteger)tapCount
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    if (_tempStoneLocation.x > 0) {
        [_boardView removeMarkerAtLocation:_tempStoneLocation];
        _tempStoneLocation = CGPointMake(-1, -1);
    }
    
    if (tapCount == 1) {
        [options setValue:[NSNumber numberWithBool:YES] forKey:kGoMarkerOptionTemporaryMarker];
        _tempStoneLocation = boardLocation;
    }
    
    [_boardView placeMarker:_curStone atLocation:boardLocation options:options];
    
    if (tapCount == 2) {
        _curStone = (_curStone == kGoMarkerBlackStone) ? kGoMarkerWhiteStone : kGoMarkerBlackStone;
    }
}

@end
