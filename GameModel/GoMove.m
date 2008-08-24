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
@synthesize point = _point;
@synthesize comment = _comment;
@synthesize moveNumber = _number;
@synthesize sgfNode = _node;

@dynamic nextMove;
@dynamic variations;
@dynamic hasVariations;
@dynamic moveAsString;

+ (GoMove*) createFromParserNode:(struct Node*)node;
{
	return [[[GoMove alloc] initWithParserNode:node] autorelease];
}

+ (GoMove*) createWithBoardPoint:(CGPoint)point isWhitesMove:(BOOL)white;
{
	return [[[GoMove alloc] initWithBoardPoint:point isWhitesMove:white] autorelease];
}

- (id) init;
{
	if (self = [super init]) {
		_point = CGPointMake(-1, -1);
		_node = nil;
		_variations = nil;
		_comment = nil;
		_number = -1;
		_isWhite = YES;
	}
	
	return self;
}

- (id) initWithBoardPoint:(CGPoint)point isWhitesMove:(BOOL)white;
{
	if (self = [self init]) {
		_point = point;
		_isWhite = white;
	}
	
	return self;
}

- (id) initWithParserNode:(struct Node*)node;
{
	if (self = [self init]) {
		_node = node;
		
		void* prop = [ParserBridge _findFirstValueWithID:TKN_W startingWithProperty:node->prop];
		_isWhite = (prop != nil);
		
		if (!prop)
			prop = [ParserBridge _findFirstValueWithID:TKN_B startingWithProperty:node->prop];
		
		if (prop && [(id)prop isKindOfClass:[NSString class]]) {
			NSString *sProp = (NSString*)prop;
			
			if ([sProp length] == 2)
				_point = CGPointMake((CGFloat)([sProp characterAtIndex:0] - 'a'), (CGFloat)([sProp characterAtIndex:1] - 'a'));
		}
		
		if ((prop = [ParserBridge _findFirstValueWithID:TKN_C startingWithProperty:node->prop])) {
			_comment = [[NSString stringWithString:(NSString*)prop] copy];
		}
		
		if ((prop = [ParserBridge _findFirstValueWithID:TKN_MN startingWithProperty:node->prop])) {
			NSLog(@"Got a move number....");
		}
	}
	
	return self;
}

- (void) dealloc;
{
	[_variations release];
	[_comment release];
	
	[super dealloc];
}

- (NSString*) description;
{
	return [NSString stringWithFormat: @"[0x%x] %s to (%@)%@", _node, _isWhite ? "White" : "Black", NSStringFromCGPoint(_point),
			(_comment ? [NSString stringWithFormat:@" (C: \"%@\")", _comment] : @"")];
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
		
		while (walk && (walk = walk->sibling))
			[retArr addObject:[GoMove createFromParserNode:walk]];
		
		_variations = (NSArray*)[retArr retain];
	}
	
	return _variations;
}

- (BOOL) hasVariations;
{
	return ((_variations && [_variations count]) || (!_variations && [self.variations count]));
}

- (NSString*) moveAsString;
{
	NSString* ret = nil;
	
	if (_point.x != -1 && _point.y != -1)
		ret = [NSString stringWithFormat:@"%c%c", 
			   ((char)_point.x + ('a' + 1) + (_point.x > 8 ? 1 : 0)),
			   ((char)_point.y + ('a' + 1) + (_point.y > 8 ? 1 : 0))];
	
	return ret;
}

@end