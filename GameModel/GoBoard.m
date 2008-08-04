//
//  GoBoard.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoBoard.h"
#import "GoBoardModel.h"
#import "BoardView.h"

#define _boardPositionToIndex(pos, boardSize) ((pos).x - 1) + (((pos).y - 1) * boardSize)
#define _indexToBoardPosition(idx, boardSize) (CGPointMake((x) % boardSize, (int)((x) / boardSize) + 1))

@implementation GoBoard

@synthesize boardView = _boardView;
@synthesize model = _boardModel;

- (id) initWithBoardView:(BoardView*)bView;
{
	if ((self = [super init]) && bView) {
		_boardView = bView;
		_boardModel = [[GoBoardModel alloc] initWithBoardSize:_boardView.gameBoardSize];
	} 
	
	return self;
}

- (void) dealloc;
{
	[_boardModel release];
	
	[super dealloc];
}
@end
