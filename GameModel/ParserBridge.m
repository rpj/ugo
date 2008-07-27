//
//  ParserBridge.m
//  ugo
//
//  Created by Ryan Joseph on 7/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ParserBridge.h"

///////////////////////////////////////////////////////////////////////////////
@interface ParserBridge (Private)
- (void) _clearSGFInfo;

- (NSArray*) _searchForValueWithID:(token)tid startingWithProperty:(struct Property*)start;
- (void*) _findFirstValueWithID:(token)tid startingWithProperty:(struct Property*)start;

// debug methods
- (void) _examinePropsForNode: (struct Node*)node;
- (void) _examineSGF;
- (void) _unitTest;
@end

///////////////////////////////////////////////////////////////////////////////
@implementation ParserBridge (Private)
- (void) _clearSGFInfo;
{
	FreeSGFInfo(&_sgf);
	memset((void*)&_sgf, 0, sizeof(struct SGFInfo));
	
	// need to clear all member variables so that their getters can update on next call
	_boardSize = 0;
	_whiteName = nil;
	_blackName = nil;
	_komi = -1.0;
	_handicap = -1;
	_gameComment = nil;
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


- (void) _unitTest;
{
	NSLog(@"Loaded SGF file: %@", _path);
	
	//[self _examineSGF];
	
	NSLog(@"Got board size of: %d", self.boardSize);
	NSLog(@"Got white name: %@", self.whiteName);
	NSLog(@"Got black name: %@", self.blackName);
	NSLog(@"Got game comment: %@", self.gameComment);
	NSLog(@"Got komi: %f", self.komi);
	NSLog(@"Got handicap: %d", self.handicap);
	NSLog(@"Got current SGF hash value: 0x%x", self.hash);
	
	self.boardSize = 17;
	NSLog(@"Set board size, did we? %d", self.boardSize);
	NSLog(@"Hash should have changed: 0x%x", self.hash);
	
	self.whiteName = @"Ryan P. Joseph";
	NSLog(@"Name changed to: %@", self.whiteName);
	NSLog(@"New hash: 0x%x", self.hash);
}
@end

///////////////////////////////////////////////////////////////////////////////
@implementation ParserBridge

@synthesize boardSize = _boardSize;
@synthesize whiteName = _whiteName;
@synthesize blackName = _blackName;
@synthesize komi = _komi;
@synthesize handicap = _handicap;
@synthesize gameComment = _gameComment;

@dynamic isActive;
@dynamic hash;		// different from [NSObject hash]; it's the [NSString hash] value of the current SGF buffer string

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

#pragma mark Getters and Setters
/////// getters/setters

- (void) setBoardSize:(NSUInteger)newSize;
{
	_boardSize = newSize;
	
	if (_sgf.root)
		New_PropValue(_sgf.root, TKN_SZ, (char*)[[NSString stringWithFormat:@"%d", newSize] cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
	
	[self refreshSGFFile];
}

- (NSUInteger) boardSize;
{
	if (!_boardSize && _sgf.root)
		_boardSize = (NSUInteger)[(NSString*)[self _findFirstValueWithID: TKN_SZ startingWithProperty: _sgf.root->prop] integerValue];
	
	return _boardSize;
}

- (void) setWhiteName:(NSString*)newName;
{
	if (newName) {
		[_whiteName release];
		_whiteName = newName;
		
		if (_sgf.root)
			New_PropValue(_sgf.root, TKN_PW, (char*)[_whiteName cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		
		[self refreshSGFFile];
	}
}

- (NSString*) whiteName;
{
	if (!_whiteName && _sgf.root)
		_whiteName = [(NSString*)[self _findFirstValueWithID: TKN_PW startingWithProperty: _sgf.root->prop] copy];
	
	return _whiteName;
}

- (void) setBlackName:(NSString*)newName;
{
	if (newName) {
		[_blackName release];
		_blackName = newName;
		
		if (_sgf.root)
			New_PropValue(_sgf.root, TKN_PB, (char*)[_blackName cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		
		[self refreshSGFFile];
	}
}

- (NSString*) blackName;
{
	if (!_blackName && _sgf.root)
		_blackName = [(NSString*)[self _findFirstValueWithID: TKN_PB startingWithProperty: _sgf.root->prop] copy];
	
	return _blackName;
}

- (void) setKomi:(float)newKomi;
{
	if (newKomi >= 0.0) {
		_komi = newKomi;
		New_PropValue(_sgf.root, TKN_KM, (char*)[[NSString stringWithFormat:@"%0.1f", _komi] cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		[self refreshSGFFile];
	}
}

- (float) komi;
{
	if (_komi == -1.0 && _sgf.root)
		_komi = (float)[(NSString*)[self _findFirstValueWithID: TKN_KM startingWithProperty: _sgf.root->prop] floatValue];
	
	return _komi;
}

- (void) setHandicap:(NSInteger)newHandicap;
{
	if (newHandicap >= 0) {
		_handicap = newHandicap;
		New_PropValue(_sgf.root, TKN_HA, (char*)[[NSString stringWithFormat:@"%d", _handicap] cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		[self refreshSGFFile];
	}
}

- (NSInteger) handicap;
{
	if (_handicap == -1 && _sgf.root)
		_handicap = (NSInteger)[(NSString*)[self _findFirstValueWithID: TKN_HA startingWithProperty: _sgf.root->prop] integerValue];
	
	return _handicap;
}

- (void) setGameComment:(NSString*)comment;
{
	if (comment) {
		[_gameComment release];
		_gameComment = comment;
		
		if (_sgf.root) {
			char* str = (char*)[_gameComment cStringUsingEncoding:NSASCIIStringEncoding];
			New_PropValue(_sgf.root, TKN_C, str, nil, FALSE);
			New_PropValue(_sgf.root, TKN_GC, str, nil, TRUE);
		}
		
		[self refreshSGFFile];
	}
}

- (NSString*) gameComment;
{
	if (!_gameComment && _sgf.root) {
		NSString* tmp = [self _findFirstValueWithID:TKN_GC startingWithProperty: _sgf.root->prop];
		if (!tmp) tmp = [self _findFirstValueWithID: TKN_C startingWithProperty: _sgf.root->prop];
		
		if (tmp) _gameComment = [tmp copy];
	}
	
	return _gameComment;
}

#pragma mark Dyanmic getters
//// dynamic getters

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

#pragma mark Loading and Saving methods

- (void) saveSGFFile;
{
	struct TreeInfo* info = _sgf.tree;
	
	if (!info)
		// not sure why, but the parser isn't creating any TreeInfo structs at all, so we have to do it ourselves
		info = (struct TreeInfo*)malloc(sizeof(struct TreeInfo));
		
	info->num = 1;		// XXX use real accessor
	info->FF = 4;		// XXX use real accessor
	info->GM = 1;		// this really must be 1
	info->bwidth = self.boardSize;
	info->bheight = self.boardSize;
	
	info->root = _sgf.root;
	info->next = info->prev = nil;
	
	_sgf.info = _sgf.tree = info;
	
	SaveSGF(&_sgf);
}

- (void) loadSGFFile;
{
	if (self.isActive)
		[self _clearSGFInfo];
	
	_sgf.name = (char*)[_path cStringUsingEncoding:NSASCIIStringEncoding];
	LoadSGF(&_sgf);
}

- (void) refreshSGFFile;
{
	[self saveSGFFile];
	[self loadSGFFile];
}

- (void) loadSGFFromPath:(NSString*)path;
{
	NSFileManager* fMgr = [NSFileManager defaultManager];
	
	if ([fMgr fileExistsAtPath:path] && [fMgr isReadableFileAtPath:path]) {
		[_path release];
		_path = [path copy];
		
		[self loadSGFFile];
		[self _unitTest];
	}
}
@end
