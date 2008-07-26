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


@implementation GoReferee

@synthesize whitePlayer = _whitePlayer;
@synthesize blackPlayer = _blackPlayer;
@synthesize currentPlayer = _currentPlayer;

@synthesize board = _board;

- (GoMoveResponse) attemptMoveAtLocation:(CGPoint)location
{
    return kGoMoveAccepted;
}

@end
