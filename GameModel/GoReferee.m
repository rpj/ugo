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
#import "GoMarker.h"

@implementation GoReferee

@dynamic whitePlayer;
@dynamic blackPlayer;
@synthesize currentPlayer = _currentPlayer;
@synthesize board = _board;
@synthesize gameDelegate = _gameDelegate;
@synthesize state = _state;

- (id) init
{
    if ((self = [super init])) {
        _state = kGoGameStateNotStarted;
        _board = [[GoBoard alloc] initWithBoardSize:[[uGoSettings sharedSettings] boardSize]];
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

- (void) setBlackPlayer:(GoPlayer *)black
{
    if (black != _blackPlayer) {
        [_blackPlayer release];
        _blackPlayer = [black retain];
        _blackPlayer.referee = self;
    }
}

- (GoPlayer *) blackPlayer { return _blackPlayer; }

- (void) setWhitePlayer:(GoPlayer *)white
{
    if (white != _whitePlayer) {
        [_whitePlayer release];
        _whitePlayer = [white retain];
        _whitePlayer.referee = self;
    }
}

- (GoPlayer *) whitePlayer { return _whitePlayer; }

- (BOOL) startGameWithWhitePlayer:(GoPlayer*)white andBlackPlayer:(GoPlayer*)black;
{
	self.blackPlayer = black;
	self.whitePlayer = white;
	
	return [self startGame];
}

- (BOOL) startGame;
{
	if (!_whitePlayer && !_blackPlayer) {
		NSLog(@"Can't start a game with no players!");
        return NO;
    }
	
	_currentPlayer = _blackPlayer;
    if ([_gameDelegate respondsToSelector:@selector(playerWillBeginTurn:)]) [_gameDelegate playerWillBeginTurn:_currentPlayer];
    [_currentPlayer turnWillBegin];
    return YES;
}

- (BOOL) playerIsAllowedToPlay:(GoPlayer *)player
{
    return [_currentPlayer isEqual:player];
}

- (BOOL) locationIsEmpty:(CGPoint)location;
{
	return [_board locationIsEmpty:location];
}

- (GoMoveResponse) attemptMoveAtLocation:(CGPoint)location forPlayer:(GoPlayer *)player
{
	GoMoveResponse resp = kGoMoveDeniedNotYourTurn;
    if (![_currentPlayer isEqual:player]) {
        return kGoMoveDeniedNotYourTurn;
    }
    
    NSAssert2(_whitePlayer && _blackPlayer, @"A move was attempted, but either the white player (%@) or the black player (%@) is nil", _whitePlayer, _blackPlayer);
    
    GoMarker *marker = [GoMarker markerOfType:kGoMarkerStone atLocation:location];
    
    if ([_currentPlayer isEqual:_whitePlayer]) {
        [marker setColor:[UIColor whiteColor]];
    } else {
        [marker setColor:[UIColor blackColor]];
    }
    
    GoBoardCacheValue move = ([_currentPlayer isEqual:_whitePlayer] ? kGoBoardCacheWhitePiece : 
                              ([_currentPlayer isEqual:_blackPlayer] ? kGoBoardCacheBlackPiece : kGoBoardCacheLastValue));
    
    if (move != kGoBoardCacheLastValue) {
        resp = kGoMoveAccepted;
        
        // check for suicide conditions
        if ([_board locationBelongsToPlayer:location] || ![_board libertiesAtLocation:location]) 
            resp = kGoMoveDeniedSuicide;
        
        // check for Ko
        if (resp == kGoMoveAccepted && [_board move:move atLocationWillViolateKo:location])
            resp = kGoMoveDeniedKoRule;
        
        if (resp == kGoMoveAccepted) {
            [_board addMove:move atLocation:location];
            [_gameDelegate markerWasPlaced:marker];
            if ([_gameDelegate respondsToSelector:@selector(playerWillEndTurn:)]) [_gameDelegate playerWillEndTurn:_currentPlayer];
            [_currentPlayer turnDidEnd];
            _currentPlayer = ([_currentPlayer isEqual:_whitePlayer] ? _blackPlayer : _whitePlayer);
            if ([_gameDelegate respondsToSelector:@selector(playerWillBeginTurn:)]) [_gameDelegate playerWillBeginTurn:_currentPlayer];
            [_currentPlayer turnWillBegin];
        }
    }
                 
    if (resp != kGoMoveAccepted) {
        if ([_gameDelegate respondsToSelector:@selector(player:didAttemptIllegalPlacement:withError:)]) [_gameDelegate player:_currentPlayer didAttemptIllegalPlacement:marker withError:resp];
    }
	
    return resp;
}

@end
