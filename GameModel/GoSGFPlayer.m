//
//  GoSGFPlayer.m
//  uGo
//
//  Created by Ryan Joseph on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GoSGFPlayer.h"
#import "GoReferee.h"
#import "ParserBridge.h"
#import "GoMove.h"

@implementation GoSGFPlayer

@dynamic isWhitePlayer;
- (void) makeNextMove;
{
	NSAssert(_canMove, @"[GoSGFPlayer nextMove] called when _canMove is false.");
	
	_curMove = [_sgf nextMoveInMainTree];
	
	if (_curMove)
		[_referee attemptMoveAtLocation:[self boardLocationFromSGFPosition:_curMove.moveAsString] forPlayer:self];
}

+ (GoSGFPlayer*) playerWithSGFPath:(NSString*)path;
{
	GoSGFPlayer* me = (GoSGFPlayer*)[super player];
	
	if (me) {
		me->_sgf = [[ParserBridge alloc] initWithPathAndLoad:path];
		me->_canMove = NO;
	}
	
	return me;
}

- (NSString*) name;
{
	return _sgf ? _sgf.gameDate : @"No game laoded."; // use game name
}

- (void) turnWillBegin;
{
	_canMove = YES;
}

- (void) turnWillEnd;
{
	_canMove = NO;
}

- (BOOL) isWhitePlayer;
{
	return (BOOL)_curMove.isWhite;
}

- (void) setIsWhitePlayer:(BOOL)newWhite;
{
	// nothin' doin
}
@end
