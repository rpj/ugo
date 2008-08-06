//
//  GoPlayer.h
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoReferee;

@interface GoPlayer : NSObject {
    GoReferee *_referee;
	BOOL _canPlay;
}

@property (nonatomic, assign) GoReferee *referee;

+ (GoPlayer*) create;

- (void) takeTurnWhenReady:(GoReferee*)ref;

@end
