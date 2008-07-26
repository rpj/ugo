//
//  ParserBridge.m
//  ugo
//
//  Created by Ryan Joseph on 7/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ParserBridge.h"


@implementation ParserBridge

@synthesize boardSize = _boardSize;
@synthesize whiteName = _whiteName;
@synthesize blackName = _blackName;
@synthesize komi = _komi;
@synthesize handicap = _handicap;

@dynamic isActive;
@dynamic hash;		// different from [NSObject hash]; it's the [NSString hash] value of the current SGF buffer string

- (void) _clearSGFInfo;
{
	FreeSGFInfo(&_sgf);
	memset((void*)&_sgf, 0, sizeof(struct SGFInfo));
	
	// need to clear all member variables so that their getters can update on next call
	_boardSize = 0;
	_whiteName = nil;
	_blackName = nil;
	_komi = 0;
}

- (id) init;
{
	if ((self = [super init])) {
		[self _clearSGFInfo];
	}
	
	return self;
}


- (void) dealloc;
{
	[self _clearSGFInfo];
	[super dealloc];
}

- (void) _examinePropsForNode: (struct Node*)node;
{
	struct Property *pptr = node->prop;
	
	for (; pptr; pptr = pptr->next) {
		NSLog(@"Property: id %d (\"%s\")\t\tFlags: 0x%x", pptr->id, pptr->idstr, pptr->flags);
		
		struct PropValue *pv = pptr->value;
		
		for (; pv; pv = pv->next) {
			if (pv->buffer && pv->value) {
				NSLog(@"\t\tValue: %s", pv->value);
				
				if (pv->value2) NSLog(@"\t\tValue2: %s", pv->value2);
			}
		}
	}
}

- (void) _examineSGF;
{
	if (_sgf.name) {
		if (_sgf.info) {
		}
		
		if (_sgf.root) {
			NSLog(@"Following node chaing from root:");
			
			struct Node* n = _sgf.root;
			
			for (; n; n = n->next) {
				NSLog(@"Node 0x%x (<- 0x%x | 0x%x ->)", n, n->prev, n->next);
				[self _examinePropsForNode:n];
			}
		}
	}
}

- (NSArray*) _searchForValueWithID:(token)tid startingWithProperty:(struct Property*)start;
{
	NSMutableArray* ret = [NSMutableArray array];
	
	for (; start; start = start->next) {
		if (start->id == tid) {
			struct PropValue* tmp = start->value;
			
			for (; tmp; tmp = tmp->next) {
				// stringWithFormat: is probably too slow for use here, but stringWithCString: worries
				// me with it's request for a const string...
				[ret addObject: [NSString stringWithFormat:@"%s", tmp->value]];
				if (tmp->value2) [ret addObject: [NSString stringWithFormat:@"%s", tmp->value2]];
			}
		}
	}
	
	return (NSArray*)ret;
}

- (void*) _findFirstValueWithID:(token)tid startingWithProperty:(struct Property*)start;
{
	NSArray* tmp = [self _searchForValueWithID: tid startingWithProperty: start];
	void* ret = nil;
	
	if ([tmp count]) ret = [tmp objectAtIndex:0];
	
	return ret;
}

/////// getters/setters

- (void) setBoardSize:(NSUInteger)newSize;
{
	_boardSize = newSize;
	
	if (_sgf.root) {
		// need to find the property pointers and set them; should change the whole buffer if I'm right.
	}
}

- (NSUInteger) boardSize;
{
	if (!_boardSize && _sgf.root)
		_boardSize = (NSUInteger)[(NSString*)[self _findFirstValueWithID: TKN_SZ startingWithProperty: _sgf.root->prop] intValue];
	
	return _boardSize;
}

- (void) setWhiteName:(NSString*)newName;
{
	if (newName) {
		[_whiteName release];
		_whiteName = [newName copy];
		
		// do stuff...
	}
}

- (NSString*) whiteName;
{
	if (!_whiteName && _sgf.root)
		self.whiteName = (NSString*)[self _findFirstValueWithID: TKN_PW startingWithProperty: _sgf.root->prop];
	
	return _whiteName;
}

- (void) setBlackName:(NSString*)newName;
{
	if (newName) {
		[_blackName release];
		_blackName = [newName copy];
		
		// do stuff...
	}
}

- (NSString*) blackName;
{
	if (!_blackName && _sgf.root)
		self.blackName = (NSString*)[self _findFirstValueWithID: TKN_PB startingWithProperty: _sgf.root->prop];
	
	return _blackName;
}

- (BOOL) isActive;
{
	return (_sgf.root != NULL);
}

- (NSUInteger) hash;
{
	NSUInteger hash = 0;
	
	if (_sgf.buffer)
		hash = [[NSString stringWithFormat:@"%s", _sgf.buffer] hash];
	
	return hash;
}

/////// end getters/setters

- (void) loadSGFFromPath:(NSString*)path;
{
	NSFileManager* fMgr = [NSFileManager defaultManager];
	
	if ([fMgr fileExistsAtPath:path] && [fMgr isReadableFileAtPath:path]) {
		if (self.isActive)
			[self _clearSGFInfo];
		
		_sgf.name = (char*)[path cStringUsingEncoding:NSASCIIStringEncoding];
		LoadSGF(&_sgf);
		NSLog(@"Loaded SGF file: %@", path);
		
		//[self _examineSGF];
		
		NSLog(@"Got board size of: %d", self.boardSize);
		NSLog(@"Got white name: %@", self.whiteName);
		NSLog(@"Got black name: %@", self.blackName);
		NSLog(@"Got current SGF hash value: 0x%x", self.hash);
	}
}
@end
