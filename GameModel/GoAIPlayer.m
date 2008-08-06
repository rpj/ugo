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

@interface GoAIPlayer (KnownPrivate)
- (void) _sendMoveRequestToSever;
@end

@implementation GoAIPlayer

@dynamic moveLocation;

- (CGPoint) moveLocation;
{
	CGPoint ret = CGPointMake(-1, -1);
	
	if (_lastStr && [_lastStr length] > 1) {
		char xChar = [_lastStr characterAtIndex:0];
		CGFloat xPt = xChar > 'I' ? (xChar - 'A') : (xChar - '@');	// so I guess 'I' doesn't exist on ANY go board!?!
		
		int yNum = [[_lastStr substringFromIndex:1] intValue];
		CGFloat yPt = ((_referee.board.boardSize + 1) - yNum);
		
		ret = CGPointMake(xPt, yPt);
		NSLog(@"moveLocation: from '%@' to %@", _lastStr, NSStringFromCGPoint(ret));
	}
	
	return ret;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_connectionData == nil) {
        _connectionData = [[NSMutableData alloc] init];
    }
    [_connectionData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_connection release];
    _connection = nil;
    [_connectionData release];
    _connectionData = nil;
    
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (![_referee playerIsAllowedToPlay:self]) {
        NSLog(@"Response received from AI server, but we're not allowed to play. Response: %@", [NSString stringWithCString:[_connectionData bytes]]);
        return;
    }
    
	[_lastStr release];
	_lastStr = [[NSString stringWithCString:[_connectionData bytes] length:[_connectionData length]] retain];
    
    [_connection release];
    _connection = nil;
    [_connectionData release];
    _connectionData = nil;
	
	if ([_lastStr length] > 4) {
		NSLog(@"AI error: \"%@\"", _lastStr);
        // try again. this is pretty much a bad idea and is likely going to throw us into an infinite loop.
        [self _sendMoveRequestToSever];
	}
	else {
		CGPoint mLoc = self.moveLocation;
        GoMoveResponse resp = [_referee attemptMoveAtLocation:mLoc forPlayer:self];
        
        if (resp != kGoMoveAccepted) {
            // try again. this is pretty much a bad idea and is likely going to throw us into an infinite loop.
            [self _sendMoveRequestToSever];
        }
	}
}

- (void) _sendMoveRequestToSever
{
	// grab a copy of the current game's SGF, setup and NSConnection and send it to the server
	// then have the connection response delegate method submit the move to the referee
	
	NSString* sgfAsString = [_referee.board compressedSGFAsStringForGnuGo];
	// player=white is a BAD HACK; fix it!!
	NSString* body = [NSString stringWithFormat:@"player=white&level=5&sgf=%@", sgfAsString];
	
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://209.204.135.246/cgi-bin/index.cgi"]];
	[req setHTTPMethod:@"POST"];
	[req setHTTPShouldHandleCookies:NO];
	[req setHTTPBody:[NSData dataWithBytes:[body cStringUsingEncoding:NSASCIIStringEncoding] 
									length:[body lengthOfBytesUsingEncoding:NSASCIIStringEncoding]]];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [_connectionData release];
    _connectionData = nil;
    [_connection release];
	_connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [_connection start];
}

- (void) turnWillBegin
{
	[super turnWillBegin];
    [self _sendMoveRequestToSever];
}

@end
