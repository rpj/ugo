//
//  GoPlayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoPlayer.h"

#import "GoReferee.h"

@implementation GoPlayer

@synthesize referee = _referee;
+ (GoPlayer*) create;
{
	return [[[self alloc] init] autorelease];
}

- (id) init;
{
	if ((self = [super init])) {
		_canPlay = NO;
	}
	
	return self;
}

- (void) takeTurnWhenReady:(GoReferee*)ref;
{
	if (ref == _referee)
		_canPlay = YES;
}
@end
