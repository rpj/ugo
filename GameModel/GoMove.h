//
//  GoMove.h
//  uGo
//
//  Created by Ryan Joseph on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParserBridge.h"

///////////////////////////////////////////////////////////////////////////////
@interface GoMove : NSObject {
	BOOL _isWhite;
	CGPoint _point;
	NSString* _comment;
	int _number;
	
@protected
	struct Node* _node;
	NSArray* _variations;
}

@property (nonatomic) BOOL isWhite;
@property (nonatomic) CGPoint point;
@property (nonatomic, copy) NSString* comment;
@property (nonatomic) int moveNumber;

@property (nonatomic) struct Node* sgfNode;

@property (nonatomic, readonly) GoMove* nextMove;
@property (nonatomic, readonly) NSArray* variations;
@property (nonatomic, readonly) BOOL hasVariations;
@property (nonatomic, readonly) NSString* moveAsString;

+ (GoMove*) createFromParserNode:(struct Node*)node;
+ (GoMove*) createWithBoardPoint:(CGPoint)point isWhitesMove:(BOOL)white;

- (id) initWithBoardPoint:(CGPoint)point isWhitesMove:(BOOL)white;
- (id) initWithParserNode:(struct Node*)node;

@end