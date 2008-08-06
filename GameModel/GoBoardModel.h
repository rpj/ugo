//
//  GoBoardModel.h
//  uGo
//
//  Created by Ryan Joseph on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGoBoardCacheBitWidth		2
#define kGoBoardCacheBaseMask		0x3

typedef enum {
	kGoBoardCacheNoPiece	= 0,
	kGoBoardCacheWhitePiece,
	kGoBoardCacheBlackPiece,
	kGoBoardCacheLastValue = 3		// can't be more than three, board cache is two bits per piece
} GoBoardCacheValue;

@class ParserBridge;

@interface GoBoardModel : NSObject {
	NSMutableData* _boardCache;
	NSMutableArray* _moveHashes;
	
	ParserBridge* _sgf;
	
	NSUInteger _boardSize;
	UInt8 _lastSetValue;
	UInt8* _lastSetByte;
}

- (id) initWithBoardSize:(NSUInteger)boardSize;

- (GoBoardCacheValue) valueAtLocation:(CGPoint)location;
- (BOOL) addMove:(GoBoardCacheValue)move atLocation:(CGPoint)location;

- (int) libertiesAtLocation:(CGPoint)location;
- (GoBoardCacheValue) locationBelongsToPlayer:(CGPoint)location;
- (BOOL) move:(GoBoardCacheValue)move atLocationWillViolateKo:(CGPoint)location;
- (BOOL) locationIsEmpty:(CGPoint)location;

- (NSString*) compressedSGFAsStringForGnuGo;
@end
