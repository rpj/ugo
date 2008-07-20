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

- (void) drawGridOfSize: (NSInteger)size
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
    }
    return self;
}

- (void) dealloc;
{
    [_boardLayer release];
	[super dealloc];
}

@end
