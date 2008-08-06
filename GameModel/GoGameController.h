//
//  GoGameController.h
//  uGo
//
//  Created by Jacob Farkas on 8/5/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoTypes.h"

@class BoardView, GoReferee, GoMarker, GoPlayer;

@protocol GoGameDelegate<NSObject>
- (void) markerWasPlaced:(GoMarker *)marker;
- (void) markerWasRemoved:(GoMarker *)marker;
- (void) playerDidPass:(GoPlayer *)player;
- (void) playerDidResign:(GoPlayer *)player;
@optional
- (void) playerWillBeginTurn:(GoPlayer *)player;
- (void) playerWillEndTurn:(GoPlayer *)player;
- (void) player:(GoPlayer *)player didAttemptIllegalPlacement:(GoMarker *)marker withError:(GoMoveResponse)response;
@end

@interface GoGameController : NSObject <GoGameDelegate> {
    GoReferee *_referee;
    BoardView *_boardView;
}

@property (nonatomic, retain) GoReferee* referee;
@property (nonatomic, retain) BoardView* boardView;

- (id) initWithBoardView:(BoardView *)boardView;

- (BOOL) startGame;

@end
