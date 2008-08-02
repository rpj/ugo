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

@interface GoMove : NSObject {
	BOOL _isWhite;
	char _x;
	char _y;
}

@property (nonatomic) BOOL isWhite;
@property (nonatomic) char xPoint;
@property (nonatomic) char yPoint;

+ (GoMove*) createMoveAtX:(char)x andY:(char)y isWhitesMove:(BOOL)white;
- (id) initWithX:(char)x andY:(char)y isWhitesMove:(BOOL)white;
@end

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
