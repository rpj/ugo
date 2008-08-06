//
//  GoReferee.h
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoTypes.h"
#import "GoGameController.h"

@class GoPlayer, GoBoard;

@interface GoReferee : NSObject {
    GoPlayer *_whitePlayer;
    GoPlayer *_blackPlayer;
    GoPlayer *_currentPlayer;
    
    GoBoard *_board;
    
    id <GoGameDelegate> _gameDelegate;
    
    GoGameState _state;
}

@property (nonatomic, retain) GoPlayer *whitePlayer;
@property (nonatomic, retain) GoPlayer *blackPlayer;
@property (nonatomic, readonly) GoPlayer *currentPlayer;
@property (nonatomic, retain) GoBoard *board;
@property (nonatomic, assign) id<GoGameDelegate> gameDelegate;

@property (nonatomic, readonly) GoGameState state;

- (BOOL) startGameWithWhitePlayer:(GoPlayer*)white andBlackPlayer:(GoPlayer*)black;
- (BOOL) startGame;

- (BOOL) playerIsAllowedToPlay:(GoPlayer *)player;
- (BOOL) locationIsEmpty:(CGPoint)location;

- (GoMoveResponse) attemptMoveAtLocation:(CGPoint)location forPlayer:(GoPlayer *)player;

@end
