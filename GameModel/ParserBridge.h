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
}

@property (nonatomic) NSUInteger boardSize;

- (void) loadSGFFromPath:(NSString*)path;
@end
