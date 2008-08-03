//
//  ParserBridge.m
//  ugo
//
//  Created by Ryan Joseph on 7/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ParserBridge.h"
#import "GoMove.h"

///////////////////////////////////////////////////////////////////////////////
@implementation ParserBridge (Private)
- (void) _clearSGFInfo;
{
	FreeSGFInfo(&_sgf);
	memset((void*)&_sgf, 0, sizeof(struct SGFInfo));
	
	_curNodeInMainTree = nil;
	
	// need to clear all member variables so that their getters can update on next call
	_boardSize = 0;
	_komi = -1.0;
	_handicap = -1;
	_timeLimit = -1;
	
	[_whiteName release];
	_whiteName = nil;
	[_blackName release];
	_blackName = nil;
	[_gameComment release];
	_gameComment = nil;
	[_gameDate release];
	_gameDate = nil;
	[_whiteRank release];
	_whiteRank = nil;
	[_blackRank release];
	_blackRank = nil;
	[_addWhite release];
	_addWhite = nil;
	[_addBlack release];
	_addBlack = nil;
	
	// this is needed to initialize the sgfc context pointer within the parser
	ParseSGF(&_sgf);
}

- (void) _ensureRoot;
{
	if (!_sgf.root) _sgf.root = NewNode(nil, YES);
}

- (void) _saveSGFFile;
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

- (void) _loadSGFFile;
{
	if (self.isActive)
		[self _clearSGFInfo];
	
	_sgf.name = (char*)[_path cStringUsingEncoding:NSASCIIStringEncoding];
	LoadSGF(&_sgf);
}

- (void) _refreshSGFFile;
{
	[self _saveSGFFile];
	[self _loadSGFFile];
}

- (NSArray*) _searchAllNodesForValuesWithID:(token)tid;
{
	NSMutableArray* ret = [NSMutableArray array];
	struct Node* node = _sgf.first;
	
	for (; node; node = node->next) {
		if (node->prop) {
			NSArray* pVals = [ParserBridge _searchForValuesWithID:tid startingWithProperty:node->prop];
			
			if ([pVals count]) [ret addObjectsFromArray:pVals];
		}
	}
	
	return (NSArray*)ret;
}

+ (NSArray*) _searchForValuesWithID:(token)tid startingWithProperty:(struct Property*)start;
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

+ (void*) _findFirstValueWithID:(token)tid startingWithProperty:(struct Property*)start;
{
	NSArray* tmp = [self _searchForValuesWithID: tid startingWithProperty: start];
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

- (void) _exploreGameTreeAtNode:(struct Node*)node;
{
	if (!node->child) {
		NSLog(@">>>> Leaf node at 0x%x:", node);
		[self _examinePropsForNode: node];
		
		if (node->next) {
			NSLog(@"Exploring NEXT node in chain from 0x%x: 0x%x", node, node->next);
			[self _exploreGameTreeAtNode: node->next];
		}
	}
	else {
		NSLog(@">>>> This node (0x%x):", node);
		[self _examinePropsForNode: node];
		
		if (node->sibling) {
			NSLog(@"Exploring SIBLING node 0x%x for 0x%x", node->sibling, node);
			[self _exploreGameTreeAtNode: node->sibling];
		}
		
		NSLog(@"Exploring CHILD node 0x%x for 0x%x", node->child, node);
		[self _exploreGameTreeAtNode: node->child];
	}
}

- (void) _unitTest;
{
	NSLog(@"Loaded SGF file: %@", _path);
	
	NSLog(@"Board size of: %d", self.boardSize);
	NSLog(@"White name: %@", self.whiteName);
	NSLog(@"White rank: %@", self.whiteRank);
	NSLog(@"Black name: %@", self.blackName);
	NSLog(@"Black rank: %@", self.blackRank);
	NSLog(@"Game comment: %@", self.gameComment);
	NSLog(@"Komi: %f", self.komi);
	NSLog(@"Handicap: %d", self.handicap);
	NSLog(@"Game date: %@", self.gameDate);
	NSLog(@"Time limit: %d secs", self.timeLimit);
	NSLog(@"Got current SGF hash value: 0x%x", self.hash);
	
	NSLog(@"Add white moves:");
	for (NSString* add in self.addWhite)
		NSLog(@"%@", add);
	
	NSLog(@"Add black moves:");
	for (NSString* add in self.addBlack)
		NSLog(@"%@", add);
	
	NSLog(@"Trying move node accessor:");
	GoMove* move = nil;
	
	while (move = self.nextMoveInMainTree) {
		NSLog(@"Move: %@", move);
		
		if (move.hasVariations) {
			NSEnumerator* sEnum = [move.variations objectEnumerator];
			GoMove* var = nil;
			int count = 1;
			
			for (; (var = [sEnum nextObject]); count++) {
				NSLog(@"\tVariation %d:", count);
				GoMove* tmp = var;
				
				do {
					NSLog(@"\t\t%@", tmp);
				} while ((tmp = tmp.nextMove));
			}
		}
	}
	
	//NSLog(@"---- Starting node exam at first (0x%x)", _sgf.first);
	//[self _exploreGameTreeAtNode: _sgf.first];
}
@end

///////////////////////////////////////////////////////////////////////////////
@implementation ParserBridge

@synthesize path = _path;

@synthesize boardSize = _boardSize;
@synthesize whiteName = _whiteName;
@synthesize blackName = _blackName;
@synthesize komi = _komi;
@synthesize handicap = _handicap;
@synthesize gameComment = _gameComment;
@synthesize gameDate = _gameDate;
@synthesize timeLimit = _timeLimit;
@synthesize whiteRank = _whiteRank;
@synthesize blackRank = _blackRank;
@synthesize addWhite = _addWhite;
@synthesize addBlack = _addBlack;

@dynamic isActive;
@dynamic hash;		// this needs to be a hash of *only* the board state, to be able to use for Ko checks
@dynamic nextMoveInMainTree;

- (id) init;
{
	if ((self = [super init])) {
		[self _clearSGFInfo];
		_path = nil;
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
- (void) setPath:(NSString*)path;
{
	if (path) {
		[_path release];
		_path = [path copy];	// this is the way to do it if the parameter hasn't already been copied for us
		
		_sgf.name = (char*)[_path cStringUsingEncoding:NSASCIIStringEncoding];
	}
}

- (void) setBoardSize:(NSUInteger)newSize;
{
	_boardSize = newSize;
	
	[self _ensureRoot];
	New_PropValue(_sgf.root, TKN_SZ, (char*)[[NSString stringWithFormat:@"%d", newSize] cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
	
	[self _refreshSGFFile];
}

- (NSUInteger) boardSize;
{
	[self _ensureRoot];
	
	if (!_boardSize)
		_boardSize = (NSUInteger)[(NSString*)[ParserBridge _findFirstValueWithID: TKN_SZ startingWithProperty: _sgf.root->prop] integerValue];
	
	return _boardSize;
}

- (void) setWhiteName:(NSString*)newName;
{
	if (newName) {
		[_whiteName release];
		_whiteName = [newName copy];	// and this is the way to do it if the param *has* been copied before being passed in...
		
		[self _ensureRoot];
		New_PropValue(_sgf.root, TKN_PW, (char*)[_whiteName cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		
		[self _refreshSGFFile];
	}
}

- (NSString*) whiteName;
{
	[self _ensureRoot];
	
	if (!_whiteName)
		_whiteName = [(NSString*)[ParserBridge _findFirstValueWithID: TKN_PW startingWithProperty: _sgf.root->prop] copy];
	
	return _whiteName;
}

- (void) setBlackName:(NSString*)newName;
{
	if (newName) {
		[_blackName release];
		_blackName = [newName copy];
		
		[self _ensureRoot];
		New_PropValue(_sgf.root, TKN_PB, (char*)[_blackName cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		
		[self _refreshSGFFile];
	}
}

- (NSString*) blackName;
{
	[self _ensureRoot];
	
	if (!_blackName)
		_blackName = [(NSString*)[ParserBridge _findFirstValueWithID: TKN_PB startingWithProperty: _sgf.root->prop] copy];
	
	return _blackName;
}

- (void) setKomi:(float)newKomi;
{
	if (newKomi >= 0.0) {
		_komi = newKomi;
		[self _ensureRoot];
		New_PropValue(_sgf.root, TKN_KM, (char*)[[NSString stringWithFormat:@"%0.1f", _komi] cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		[self _refreshSGFFile];
	}
}

- (float) komi;
{
	[self _ensureRoot];
	
	if (_komi == -1.0)
		_komi = (float)[(NSString*)[ParserBridge _findFirstValueWithID: TKN_KM startingWithProperty: _sgf.root->prop] floatValue];
	
	return _komi;
}

- (void) setHandicap:(NSInteger)newHandicap;
{
	if (newHandicap >= 0) {
		_handicap = newHandicap;
		[self _ensureRoot];
		New_PropValue(_sgf.root, TKN_HA, (char*)[[NSString stringWithFormat:@"%d", _handicap] cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		[self _refreshSGFFile];
	}
}

- (NSInteger) handicap;
{
	[self _ensureRoot];
	
	if (_handicap == -1)
		_handicap = (NSInteger)[(NSString*)[ParserBridge _findFirstValueWithID: TKN_HA startingWithProperty: _sgf.root->prop] integerValue];
	
	return _handicap;
}

- (void) setGameComment:(NSString*)comment;
{
	if (comment) {
		[_gameComment release];
		_gameComment = [comment copy];
		
		[self _ensureRoot];
		char* str = (char*)[_gameComment cStringUsingEncoding:NSASCIIStringEncoding];
		New_PropValue(_sgf.root, TKN_C, str, nil, FALSE);
		New_PropValue(_sgf.root, TKN_GC, str, nil, TRUE);
		
		[self _refreshSGFFile];
	}
}

- (NSString*) gameComment;
{
	if (!_gameComment) {
		[self _ensureRoot];
		
		NSString* tmp = [ParserBridge _findFirstValueWithID:TKN_GC startingWithProperty: _sgf.root->prop];
		if (!tmp) tmp = [ParserBridge _findFirstValueWithID: TKN_C startingWithProperty: _sgf.root->prop];
		
		if (tmp) _gameComment = [tmp copy];
	}
	
	return _gameComment;
}

- (void) setGameDate:(NSDate*)date;
{
	if (date) {
		[_gameDate release];
		_gameDate = [date copy];
		
		[self _ensureRoot];
		//NSDateFormatter* frmtr = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d" allowNaturalLanguage:NO] autorelease];
		NSString* dstr = [_gameDate description];	//[frmtr stringFromDate:_gameDate];
		
		if (dstr) New_PropValue(_sgf.root, TKN_DT, (char*)[dstr cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		
		[self _refreshSGFFile];
	}
}

- (NSDate*) gameDate;
{
	if (!_gameDate) {
		[self _ensureRoot];
		
		NSString* sDate = (NSString*)[ParserBridge _findFirstValueWithID: TKN_DT startingWithProperty: _sgf.root->prop];
		
		if (sDate) {
			//NSDateFormatter* frmtr = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d" allowNaturalLanguage:NO] autorelease];
			_gameDate = [[sDate description] retain]; //[[frmtr dateFromString: sDate] retain];
		}
	}
	
	return _gameDate;
}

- (void) setTimeLimit:(NSInteger)tl;
{
	if (tl >= 0) {
		[self _ensureRoot];
		_timeLimit = tl;
		New_PropValue(_sgf.root, TKN_TM, (char*)[[NSString stringWithFormat:@"%d", _timeLimit] cStringUsingEncoding:NSASCIIStringEncoding], nil, YES);
		[self _refreshSGFFile];
	}
}

- (NSInteger) timeLimit;
{
	[self _ensureRoot];
	
	if (_timeLimit == -1)
		_timeLimit = (NSInteger)[(NSString*)[ParserBridge _findFirstValueWithID: TKN_TM startingWithProperty: _sgf.root->prop] integerValue];
	
	return _timeLimit;
}

- (void) setWhiteRank:(NSString*)rank;
{
	if (rank) {
		[_whiteRank release];
		_whiteRank = [rank copy];
		
		[self _ensureRoot];
		New_PropValue(_sgf.root, TKN_WR, (char*)[_whiteRank cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		[self _refreshSGFFile];
	}
}

- (NSString*) whiteRank;
{
	if (!_whiteRank) {
		[self _ensureRoot];
		_whiteRank = [(NSString*)[ParserBridge _findFirstValueWithID: TKN_WR startingWithProperty: _sgf.root->prop] copy];
	}
	
	return _whiteRank;
}

- (void) setBlackRank:(NSString*)rank;
{
	if (rank) {
		[_blackRank release];
		_blackRank = [rank retain];
		
		[self _ensureRoot];
		New_PropValue(_sgf.root, TKN_BR, (char*)[_blackRank cStringUsingEncoding:NSASCIIStringEncoding], nil, TRUE);
		[self _refreshSGFFile];
	}
}

- (NSString*) blackRank;
{	
	if (!_blackRank) {
		[self _ensureRoot];
		_blackRank = [(NSString*)[ParserBridge _findFirstValueWithID: TKN_BR startingWithProperty: _sgf.root->prop] retain];
	}
	
	return _blackRank;
}

- (void) setAddWhite:(NSArray*)array;
{
	if (array) {
		[_addWhite release];
		_addWhite = [array retain];
		
		[self _ensureRoot];
		for (NSString* add in _addWhite)
			New_PropValue(_sgf.root, TKN_AW, (char*)[add cStringUsingEncoding:NSASCIIStringEncoding], nil, NO);
		[self _refreshSGFFile];
	}
}

- (NSArray*) addWhite;
{
	if (!_addWhite) {
		[self _ensureRoot];
		NSArray* allVals = [self _searchAllNodesForValuesWithID: TKN_AW];
		
		if ([allVals count]) _addWhite = [allVals retain];
	}
	
	return _addWhite;
}

- (void) setAddBlack:(NSArray*)array;
{
	if (array) {
		[_addBlack release];
		_addBlack = [array retain];
		
		[self _ensureRoot];
		for (NSString* add in _addBlack)
			New_PropValue(_sgf.root, TKN_AB, (char*)[add cStringUsingEncoding:NSASCIIStringEncoding], nil, NO);
		[self _refreshSGFFile];
	}
}

- (NSArray*) addBlack;
{
	if (!_addBlack) {
		[self _ensureRoot];
		NSArray* allVals = [self _searchAllNodesForValuesWithID: TKN_AB];
		
		if ([allVals count]) _addBlack = [allVals retain];
	}
	
	return _addBlack;
}

#pragma mark Dyanmic getters
//// dynamic getters

- (BOOL) isActive;
{
	return (_sgf.root != NULL);
}

- (NSUInteger) hash;
{
	return (_sgf.buffer ? [[NSString stringWithFormat:@"%s", _sgf.buffer] hash] : 0);
}

- (void) setNextMoveInMainTree:(GoMove*)move;
{
	if (move.point.x != -1 && move.point.y != -1) {
		move.sgfNode = NewNode(_curNodeInMainTree, YES);
	}
}

- (GoMove*) nextMoveInMainTree;
{
	GoMove* retMove = nil;
	
	// set the current node at first to the root, so that an ->child on it gets the first move node
	if (!_curNodeInMainTree && _sgf.root)
		_curNodeInMainTree = _sgf.root;
	
	if ((_curNodeInMainTree = _curNodeInMainTree->child))
		retMove = [GoMove createFromParserNode:_curNodeInMainTree];
	
	return retMove;
}
/////// end getters/setters

#pragma mark Loading and Saving methods

- (void) loadSGFFromPath:(NSString*)path;
{
	NSFileManager* fMgr = [NSFileManager defaultManager];
	
	if ([fMgr fileExistsAtPath:path] && [fMgr isReadableFileAtPath:path]) {
		self.path = path;
		[self _loadSGFFile];
		[self _unitTest];
	}
}
@end
