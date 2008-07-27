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
	NSString* _path;
	
	NSUInteger _boardSize;
	NSString *_whiteName;
	NSString *_blackName;
	float _komi;
	NSInteger _handicap;
	NSString* _gameComment;
}

@property (nonatomic) NSUInteger boardSize;
@property (nonatomic, copy) NSString *whiteName;
@property (nonatomic, copy) NSString *blackName;
@property (nonatomic) float komi;
@property (nonatomic) NSInteger handicap;
@property (nonatomic, copy) NSString *gameComment;

@property (nonatomic, readonly) BOOL isActive;
@property (nonatomic, readonly) NSUInteger hash;

- (void) loadSGFFromPath:(NSString*)path;
- (void) loadSGFFile;
- (void) saveSGFFile;
- (void) refreshSGFFile;
@end
