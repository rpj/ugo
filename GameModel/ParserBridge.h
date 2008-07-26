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

@interface ParserBridge : NSObject {
	struct SGFInfo	_sgf;
	
	NSUInteger _boardSize;
	NSString *_whiteName;
	NSString *_blackName;
	float _komi;
	NSUInteger _handicap;
}

@property (nonatomic) NSUInteger boardSize;
@property (nonatomic, assign) NSString *whiteName;
@property (nonatomic, assign) NSString *blackName;
@property (nonatomic) float komi;
@property (nonatomic) NSUInteger handicap;

@property (nonatomic, readonly) BOOL isActive;
@property (nonatomic, readonly) NSUInteger hash;

- (void) loadSGFFromPath:(NSString*)path;
@end
