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
	char _x;
	char _y;
	
@protected
	struct Node* _node;
	NSArray* _variations;
}

@property (nonatomic) BOOL isWhite;
@property (nonatomic) char xPoint;
@property (nonatomic) char yPoint;

@property (nonatomic, readonly) GoMove* nextMove;
@property (nonatomic, readonly) NSArray* variations;
@property (nonatomic, readonly) BOOL hasVariations;

+ (GoMove*) createFromParserNode:(struct Node*)node;
- (id) initWithParserNode:(struct Node*)node;

@end