//
//  GoAIPlayer.m
//  uGo
//
//  Created by Ryan Joseph on 8/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GoAIPlayer.h"
#import "GoReferee.h"
#import "GoBoard.h"
#import "GoBoardModel.h"
#import "BoardView.h"

@implementation GoAIPlayer

@dynamic moveLocation;

- (CGPoint) moveLocation;
{
	CGPoint ret = CGPointMake(-1, -1);
	
	if (_lastStr && [_lastStr length] > 1) {
		char xChar = [_lastStr characterAtIndex:0];
		CGFloat xPt = (xChar - 'A');
		
		int yNum = [[_lastStr substringFromIndex:1] intValue];
		CGFloat yPt = (_referee.board.boardView.gameBoardSize - yNum);
		
		ret = CGPointMake(xPt, yPt);
		NSLog(@"moveLocation: from '%@' to %@", _lastStr, NSStringFromCGPoint(ret));
	}
	
	return ret;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[_lastStr release];
	_lastStr = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[_lastStr release];
	_lastStr = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	_lastStr = [[NSString stringWithCString:[data bytes] length:[data length]] retain];
	
	if ([_lastStr length] > 4) {
		NSLog(@"AI error: \"%@\"", _lastStr);
	}
	else {
		[_referee attemptMoveAtLocation:self.moveLocation];
	}
}

- (void) takeTurnWhenReady:(GoReferee*)ref;
{
	[super takeTurnWhenReady:ref];
	// grab a copy of the current game's SGF, setup and NSConnection and send it to the server
	// then have the connection response delegate method submit the move to the referee
	
	NSString* sgfAsString = [_referee.board.model compressedSGFAsStringForGnuGo];
	// player=white is a BAD HACK; fix it!!
	NSString* body = [NSString stringWithFormat:@"player=white&level=5&sgf=%@", sgfAsString];
	NSLog(@"body for URL connection: '%@'", body);
	
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://10.0.1.145/cgi-bin/index.cgi"]];
	[req setHTTPMethod:@"POST"];
	[req setHTTPShouldHandleCookies:NO];
	[req setHTTPBody:[NSData dataWithBytes:[body cStringUsingEncoding:NSASCIIStringEncoding] 
									length:[body lengthOfBytesUsingEncoding:NSASCIIStringEncoding]]];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[[NSURLConnection connectionWithRequest:req delegate:self] start];
}

@end
