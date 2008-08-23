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
}

@property (nonatomic, assign) GoReferee *referee;

+ (GoPlayer*) player;

- (NSString *) name;

- (void) turnWillBegin;
- (void) turnDidEnd;

@end

// stuff that all player classes may find in handy, but also stuff that needs a referee reference to run correctly,
// so I figured it best to put it here
@interface GoPlayer (Utility)
- (CGPoint) boardLocationFromSGFPosition:(NSString*)sgfPosition;
@end
