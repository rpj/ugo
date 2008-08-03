//
//  GoReferee.h
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGoBoardCacheBitWidth		2
#define kGoBoardCacheBaseMask		0x3

typedef enum {
    kGoMoveAccepted,
    kGoMoveDeniedNotYourTurn,
    kGoMoveDeniedSuicide,
    kGoMoveDeniedKoRule,
    kGoMovePieceExists
} GoMoveResponse;

typedef enum {
	kGoBoardCacheNoPiece	= 0,
	kGoBoardCacheWhitePiece,
	kGoBoardCacheBlackPiece,
	kGoBoardCacheLastValue = 3		// can't be more than three, board cache is two bits per piece
} GoBoardCacheValue;

@class GoPlayer, GoBoard, ParserBridge;

@interface GoReferee : NSObject {
    GoPlayer *_whitePlayer;
    GoPlayer *_blackPlayer;
    
    GoPlayer *_currentPlayer;
    
    GoBoard *_board;
	ParserBridge *_sgf;
	
	NSMutableData* _boardCache;
	NSMutableArray* _moveHashes;
	
	NSUInteger _boardSize;
}

@property (nonatomic, retain) GoPlayer *whitePlayer;
@property (nonatomic, retain) GoPlayer *blackPlayer;
@property (nonatomic, readonly) GoPlayer *currentPlayer;
@property (nonatomic, retain) GoBoard *board;
@property (nonatomic, readonly) const ParserBridge const *parserBridge;

+ (GoReferee*) createWithBoard:(GoBoard*)board;

- (BOOL) locationIsEmpty:(CGPoint)location;
- (GoMoveResponse) attemptMoveAtLocation:(CGPoint)location;

@end
