//
//  GoPlayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoPlayer.h"

#import "GoReferee.h"
#import "GoBoard.h"


@implementation GoPlayer

@synthesize referee = _referee;
+ (GoPlayer*) player;
{
	return [[[self alloc] init] autorelease];
}

- (NSString *) name { return @"Default Player"; }

- (void) turnWillBegin { }

- (void) turnDidEnd { }
@end

@implementation GoPlayer (Utility)
- (CGPoint) boardLocationFromSGFPosition:(NSString*)sgfPosition;
{
	CGPoint ret = CGPointMake(-1, -1);
	
	if (sgfPosition && [sgfPosition length] > 1) {
		char xChar = [sgfPosition characterAtIndex:0];
		CGFloat xPt = xChar > 'I' ? (xChar - 'A') : (xChar - '@');	// so I guess 'I' doesn't exist on ANY go board!?!
		
		int yNum = [[sgfPosition substringFromIndex:1] intValue];
		CGFloat yPt = ((_referee.board.boardSize + 1) - yNum);
		
		ret = CGPointMake(xPt, yPt);
	}
	
	return ret;
}

@end

