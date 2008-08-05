//
//  GoReferee.h
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kGoMoveAccepted,
    kGoMoveDeniedNotYourTurn,
    kGoMoveDeniedSuicide,
    kGoMoveDeniedKoRule,
    kGoMovePieceExists
} GoMoveResponse;

@class GoPlayer, GoBoard, BoardView;

@interface GoReferee : NSObject {
    GoPlayer *_whitePlayer;
    GoPlayer *_blackPlayer;
    
    GoPlayer *_currentPlayer;
    
    GoBoard *_board;
}

@property (nonatomic, retain) GoPlayer *whitePlayer;
@property (nonatomic, retain) GoPlayer *blackPlayer;
@property (nonatomic, readonly) GoPlayer *currentPlayer;
@property (nonatomic, retain) GoBoard *board;

@property (nonatomic, readonly) BOOL hasStarted;

// also not very good separation...
- (id) initWithBoardView:(BoardView*)bView;

- (void) startGameWithWhitePlayer:(GoPlayer*)white andBlackPlayer:(GoPlayer*)black;
- (void) startGame;

- (BOOL) locationIsEmpty:(CGPoint)location;
- (GoMoveResponse) attemptMoveAtLocation:(CGPoint)location;

@end
