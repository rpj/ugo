//
//  GoLocalPlayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoLocalPlayer.h"
#import "GoReferee.h"

@implementation GoLocalPlayer

// I think I'm doing this wrong. Why is this necessary?
+ (GoLocalPlayer *)player
{
    return [[[GoLocalPlayer alloc] init] autorelease];
}

- (NSString *) name { return @"You"; }

- (void) setBoardView:(BoardView *)boardView
{
    if (boardView != _boardView) {
        [_boardView release];
        _boardView = [boardView retain];
        _boardView.delegate = self;
    }
}

- (BoardView *) boardView { return _boardView; }

- (void) dealloc
{
    [_boardView release];
    [super dealloc];
}

- (NSString *) description { return [NSString stringWithFormat:@"Local player %p", self]; }

- (void) turnWillBegin
{
    _boardView.delegate = self;
}

- (void) locationWasTouched:(CGPoint)boardLocation tapCount:(NSUInteger)tapCount
{	
	if ([_referee playerIsAllowedToPlay:self]) {
        [_referee attemptMoveAtLocation:boardLocation forPlayer:self];
	}
	else {
        NSLog(@"It's not your turn. This should be some kind of subtle alert in the UI");
	}
}

@end
