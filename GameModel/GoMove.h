//
//  GoMove.h
//  uGo
//
//  Created by Ryan Joseph on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParserBridge.h"

@class GoMarker;

///////////////////////////////////////////////////////////////////////////////
@interface GoMove : NSObject {
    GoMarker *_marker;
    NSMutableDictionary *_properties;
    
    // not sure if this is necessary
	int _moveNumber;
	
    GoMove *_nextMove;
    NSMutableArray *_variations;
}

@property (nonatomic, retain) GoMarker *marker;
@property (nonatomic) int moveNumber;

@property (nonatomic, retain) GoMove *nextMove;
@property (nonatomic, readonly) NSMutableArray /* GoMove * */ *variations;

// Get and set specific properties with KVC
@property (nonatomic, readonly) NSDictionary *properties;

+ (GoMove*) moveFromParserNode:(struct Node*)node;

- (NSString*) moveAsString;
- (struct Node *) parserNodeRepresentation;


@end