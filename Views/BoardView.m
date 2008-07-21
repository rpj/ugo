//
//  BoardView.m
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView

@synthesize _boardLayer;

- (void) boardSizeDidChange:(NSNotification *)notif
{
    [self drawGridOfSize:[[uGoSettings sharedSettings] boardSize]];
}

- (void) drawGridOfSize:(NSInteger)size
{
    [_boardLayer drawGridOfSize:size];
}

- (id) init
{
    if ((self = [super init])) {
        self.frame = CGRectMake(0, 0, kBoardSize, kBoardSize);
        self._boardLayer = [BoardLayer layer];
        _boardLayer.frame = self.frame;
        self.layer.contents = (id)[UIImage imageNamed: @"board1.png"].CGImage;
        
        [self.layer addSublayer:_boardLayer];
        [_boardLayer setNeedsDisplay];
        
        [self drawGridOfSize:[[uGoSettings sharedSettings] boardSize]];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardSizeDidChange:) name:kBoardSizeChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_boardLayer release];
	[super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] < 1) return;
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    if (touch.tapCount == 1) {
        [_boardLayer placeTemporaryStone:[touch locationInView:self]];
    }
    else {
        [_boardLayer placeStone:[touch locationInView:self]];
    }
}

@end
