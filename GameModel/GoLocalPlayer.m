//
//  GoLocalPlayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoLocalPlayer.h"

#import "GoReferee.h"
#import "GoBoard.h"
#import "BoardView.h"

@implementation GoLocalPlayer
- (void) locationWasTouched:(CGPoint)boardLocation tapCount:(NSUInteger)tapCount
{
	GoMoveResponse resp = kGoMoveAccepted;
	
	if (_canPlay && (resp = [_referee attemptMoveAtLocation:boardLocation]) == kGoMoveAccepted) {
		_canPlay = NO;
		[_referee.board.boardView confirmedLocationTouched:boardLocation tapCount:tapCount];
	}
	else if (resp != kGoMoveAccepted) {
		[_referee.board.boardView moveDeniedWithReason:resp atLocation:boardLocation];
	}
}
@end
