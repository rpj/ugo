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
@synthesize isWhitePlayer = _isWhite;

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
		sgfPosition = [sgfPosition lowercaseString];
		
		char xChar = [sgfPosition characterAtIndex:0];
		CGFloat xPt = (xChar > 'i') ? (xChar - 'b') : (xChar - 'a');
		
		char yChar = [sgfPosition characterAtIndex:1];
		CGFloat yPt = (yChar > 'i') ? (yChar - 'b') : (yChar - 'a');
		
		ret = CGPointMake(xPt, yPt);
	}
	
	return ret;
}

@end

