//
//  GoReferee.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoReferee.h"

#import "GoPlayer.h"
#import "GoBoard.h"
#import "GoBoardModel.h"
#import "BoardView.h"

@implementation GoReferee

@synthesize whitePlayer = _whitePlayer;
@synthesize blackPlayer = _blackPlayer;
@synthesize currentPlayer = _currentPlayer;

@synthesize board = _board;

- (id) initWithBoardView:(BoardView*)bView;
{
	if ((self = [super init])) {
		_board = [[GoBoard alloc] initWithBoardView:bView];
		_board.boardView = bView;
		
		_isWhitesMove = NO;
	}
	
	return self;
}

- (void) dealloc;
{
	[_whitePlayer release];
	[_blackPlayer release];
	[_board release];
	
	[super dealloc];
}

- (BOOL) locationIsEmpty:(CGPoint)location;
{
	return [_board.model locationIsEmpty:location];
}

- (GoMoveResponse) attemptMoveAtLocation:(CGPoint)location
{
	GoMoveResponse resp = kGoMoveAccepted;
	GoBoardCacheValue move = (_isWhitesMove ? kGoBoardCacheWhitePiece : kGoBoardCacheBlackPiece);
	
	// check for suicide conditions
	if ([_board.model locationBelongsToPlayer:location] || ![_board.model libertiesAtLocation:location]) 
		resp = kGoMoveDeniedSuicide;
	
	// check for Ko
	if (resp == kGoMoveAccepted && [_board.model move:move atLocationWillViolateKo:location])
		resp = kGoMoveDeniedKoRule;
	
	if (resp == kGoMoveAccepted) {
		[_board.model addMove:move atLocation:location];
		_isWhitesMove = (_isWhitesMove ? NO : YES);
	}
	
    return resp;
}

@end
