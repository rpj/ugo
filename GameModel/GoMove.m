//
//  GoMove.m
//  uGo
//
//  Created by Ryan Joseph on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GoMove.h"

///////////////////////////////////////////////////////////////////////////////
@implementation GoMove

@synthesize isWhite = _isWhite;
@synthesize xPoint = _x;
@synthesize yPoint = _y;

@dynamic nextMove;
@dynamic variations;
@dynamic hasVariations;

+ (GoMove*) createFromParserNode:(struct Node*)node;
{
	return [[[GoMove alloc] initWithParserNode:node] autorelease];
}

- (id) initWithParserNode:(struct Node*)node;
{
	if (self = [super init]) {
		_x = _y = '-';	// sentinel for a bad move
		_node = node;
		_variations = nil;
		
		void* prop = [ParserBridge _findFirstValueWithID:TKN_W startingWithProperty:node->prop];
		_isWhite = (prop != nil);
		
		if (!prop)
			prop = [ParserBridge _findFirstValueWithID:TKN_B startingWithProperty:node->prop];
		
		if (prop && [(id)prop isKindOfClass:[NSString class]]) {
			NSString *sProp = (NSString*)prop;
			
			if ([sProp length] == 2) {
				_x = (char)[sProp characterAtIndex:0];
				_y = (char)[sProp characterAtIndex:1];
			}
		}
	}
	
	return self;
}

- (void) dealloc;
{
	[_variations release];
	
	[super dealloc];
}

- (NSString*) description;
{
	return [NSString stringWithFormat: @"[0x%x] %s to (%c, %c)", _node, _isWhite ? "White" : "Black", _x, _y];
}

- (GoMove*) nextMove; 
{
	return (_node && _node->child ? [GoMove createFromParserNode:_node->child] : nil);
}

- (NSArray*) variations; 
{
	if (!_variations) {
		struct Node* walk = _node;
		NSMutableArray* retArr = [NSMutableArray array];
		
		while ((walk = walk->sibling))
			[retArr addObject:[GoMove createFromParserNode:walk]];
		
		_variations = (NSArray*)[retArr retain];
	}
	
	return _variations;
}

- (BOOL) hasVariations;
{
	return ((_variations && [_variations count]) || (!_variations && [self.variations count]));
}

@end