//
//  MarkerController.h
//  uGo
//
//  Created by Jacob Farkas on 7/22/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoMarker.h"
#import "BoardView.h"

@interface MarkerController : NSObject <BoardViewDelegate> {
    BoardView*          _boardView;
    
    GoMarkerType        _curStone;
    CGPoint             _tempStoneLocation;
}

// MarkerController makes itself the delegate of the assigned BoardView.
@property(nonatomic, assign) BoardView *boardView;

@end
