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
	BOOL _isWhite;
}

@property (nonatomic, assign) GoReferee *referee;
@property (nonatomic, assign) BOOL isWhitePlayer;

+ (GoPlayer*) player;

- (NSString *) name;

- (void) turnWillBegin;
- (void) turnDidEnd;

@end

// stuff that all player classes may find in handy
@interface GoPlayer (Utility)
- (CGPoint) boardLocationFromSGFPosition:(NSString*)sgfPosition;
@end
