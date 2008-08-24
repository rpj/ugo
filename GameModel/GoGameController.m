//
//  GoGameController.m
//  uGo
//
//  Created by Jacob Farkas on 8/5/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoGameController.h"

#import "BoardView.h"

#import "GoReferee.h"
#import "GoPlayer.h"
#import "GoLocalPlayer.h"
#import "GoAIPlayer.h"

#import "GoMarker.h"

@implementation GoGameController

@synthesize referee = _referee;
@synthesize boardView = _boardView;

- (id) initWithBoardView:(BoardView *)boardView
{
    if ((self = [super init])) { 
        _boardView = boardView;
        _referee = [[GoReferee alloc] init];
		
        _referee.blackPlayer = nil;
        _referee.whitePlayer = nil;
        _referee.gameDelegate = self;
    }
    return self;
}

- (void) dealloc
{
    [_referee release];
    [super dealloc];
}

- (BOOL) startGame
{
    return [_referee startGame];
}

- (void) markerWasPlaced:(GoMarker *)marker
{
    [_boardView placeMarker:marker];
}

- (void) markerWasRemoved:(GoMarker *)marker
{
    [_boardView removeMarker:marker];
}

- (void) playerWillBeginTurn:(GoPlayer *)player
{
    
}

- (void) playerWillEndTurn:(GoPlayer *)player
{
    
}

- (void) playerDidPass:(GoPlayer *)player
{
    
}

- (void) playerDidResign:(GoPlayer *)player
{
    
}

@end
