//
//  GoAIPlayer.h
//  uGo
//
//  Created by Ryan Joseph on 8/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoPlayer.h"

@interface GoAIPlayer : GoPlayer {
	NSString*	_lastStr;
    NSURLConnection *_connection;
    NSMutableData *_connectionData;
}

@property (nonatomic, readonly) CGPoint moveLocation;

@end
