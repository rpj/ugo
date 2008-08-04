//
//  GoBoard.h
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardView, GoBoardModel;

@interface GoBoard : NSObject {
    BoardView *_boardView;
	GoBoardModel* _boardModel;
}

// not good separation. this needs more thought.
@property (nonatomic, assign) BoardView *boardView;
@property (nonatomic, readonly) GoBoardModel* model;

- (id) initWithBoardView:(BoardView*)bView;

@end
