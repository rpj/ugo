//
//  GoSGFPlayer.h
//  uGo
//
//  Created by Ryan Joseph on 8/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoPlayer.h"

@class ParserBridge, GoMove;

@interface GoSGFPlayer : GoPlayer {
	ParserBridge *_sgf;
	GoMove *_curMove;
	
	BOOL _canMove;
}

+ (GoSGFPlayer*) playerWithSGFPath:(NSString*)path;

- (void) makeNextMove;
@end
