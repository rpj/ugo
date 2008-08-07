//
//  GoMove.m
//  uGo
//
//  Created by Ryan Joseph on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GoMove.h"

#import "GoMoveProperty.h"
#import "GoMovePropVal.h"

///////////////////////////////////////////////////////////////////////////////
@implementation GoMove

@synthesize marker = _marker;
@synthesize nextMove = _nextMove;
@synthesize variations = _variations;
@synthesize properties = _properties;

- (void) _setPropertyFromStruct:(struct Property *)prop
{
    GoMoveProperty *newProp = [[GoMoveProperty alloc] init];
    NSString *propID = [NSString stringWithCString:prop->idstr encoding:NSUTF8StringEncoding];
    NSString *propName = [[GoMoveProperty sgfCodesToPropertyNames] objectForKey:propID];
    if (propName == nil) {
        NSLog(@"Could not get a property name for %s", prop->idstr);
        propName = propID;
    }
        
    struct PropValue *curVal;
    for (curVal = prop->value; curVal; curVal = curVal->next) {
        [newProp.values addObject:[GoMovePropVal valueWithPropValueStruct:curVal]];
        if (curVal == prop->valend) break;
    }
    
    [self setValue:newProp forUndefinedKey:propName];
    [newProp release];
}

- (id) initWithParserNode:(struct Node*)node;
{
	if ((self = [super init])) {
        _properties = [[NSMutableDictionary alloc] init];
        _variations = [[NSMutableArray alloc] init];
        
        struct Property *curProp;
        for (curProp = node->prop; curProp; curProp = curProp->next) {
            [self _setPropertyFromStruct:curProp];
            if (curProp == node->last) break;
        }
	}
    
    // TODO: create a GoMarker based on the move
	
	return self;
}

+ (GoMove*) moveFromParserNode:(struct Node*)node;
{
	return [[[GoMove alloc] initWithParserNode:node] autorelease];
}

- (void) dealloc;
{
	[_marker release];
	[_properties release];
    [_nextMove release];
    [_variations release];
	
	[super dealloc];
}

//- (NSString*) description;
//{
//	return [NSString stringWithFormat: @"[0x%x] %s to (%@)%@", _node, _isWhite ? "White" : "Black", NSStringFromCGPoint(_point),
//			(_comment ? [NSString stringWithFormat:@" (C: \"%@\")", _comment] : @"")];
//}

- (NSString*) moveAsString;
{
	NSString* ret = nil;
	CGPoint loc = _marker.location;
    
    // won't this end up returning 'I' as a value?
	if (loc.x != -1 && loc.y != -1)
		ret = [NSString stringWithFormat:@"%c%c", ((char)loc.x + ('a'-1)), ((char)loc.y + ('a'-1))];
	
	return ret;
}

- (struct Node *) parserNodeRepresentation
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return [_properties objectForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [_properties setObject:value forKey:key];
}

@end