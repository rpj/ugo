//
//  ParserBridge.h
//  ugo
//
//  Created by Ryan Joseph on 7/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "all.h"
#import "protos.h"

@class GoMove;

///////////////////////////////////////////////////////////////////////////////
@interface ParserBridge : NSObject {
	struct SGFInfo	_sgf;
	NSString* _path;
	
	// record keeping ivars
	struct Node *_curNodeInMainTree;
	
	// property ivars
	NSUInteger _boardSize;
	NSString *_whiteName;
	NSString *_blackName;
	float _komi;
	NSInteger _handicap;
	NSString *_gameComment;
	NSDate *_gameDate;
	NSInteger _timeLimit;
	NSString *_whiteRank;
	NSString *_blackRank;
	NSArray *_addWhite;
	NSArray *_addBlack;
}

// question: when using 'copy' here and having a *custom setter*, has the variable passed in as a parameter to
// the setter *already* been copied, and thus already retained, or *needs to be copied* (and retained).
@property (nonatomic, copy) NSString *path;

// directly translated accessors form the SGF spec: each field below corresponds to a particular token
// found in the root node of an SGF file.
@property (nonatomic) NSUInteger boardSize;
@property (nonatomic, copy) NSString *whiteName;
@property (nonatomic, copy) NSString *blackName;
@property (nonatomic) float komi;
@property (nonatomic) NSInteger handicap;
@property (nonatomic, copy) NSString *gameComment;
@property (nonatomic, copy) NSDate *gameDate;
@property (nonatomic) NSInteger timeLimit;
@property (nonatomic, copy) NSString *whiteRank;
@property (nonatomic, retain) NSString *blackRank;		// still kinda confused about memory management here, so trying a retain instead...
@property (nonatomic, copy) NSArray *addWhite;
@property (nonatomic, copy) NSArray *addBlack;

// dynamic properties
@property (nonatomic, readonly) BOOL isActive;
@property (nonatomic, readonly) NSUInteger hash;
@property (nonatomic, readonly) GoMove* nextMoveInMainTree;

- (void) loadSGFFromPath:(NSString*)path;
@end


///////////////////////////////////////////////////////////////////////////////
@interface ParserBridge (Private)
- (void) _clearSGFInfo;
- (void) _ensureRoot;
- (void) _loadSGFFile;
- (void) _saveSGFFile;
- (void) _refreshSGFFile;

- (NSArray*) _searchAllNodesForValuesWithID:(token)tid;

+ (NSArray*) _searchForValuesWithID:(token)tid startingWithProperty:(struct Property*)start;
+ (void*) _findFirstValueWithID:(token)tid startingWithProperty:(struct Property*)start;

// debug methods
- (void) _examinePropsForNode: (struct Node*)node;
- (void) _unitTest;
@end
