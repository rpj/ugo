//
//  GoReferee.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoReferee.h"

#import "GoPlayer.h"
#import "GoBoard.h"
#import "BoardView.h"
#import "MarkerLayer.h"

#import "ParserBridge.h"


@implementation GoReferee

@synthesize whitePlayer = _whitePlayer;
@synthesize blackPlayer = _blackPlayer;
@synthesize currentPlayer = _currentPlayer;

@synthesize board = _board;

@synthesize parserBridge = _sgf;

- (id) init
{
    if ((self = [super init])) {
        _sgf = [[ParserBridge alloc] init];
		_boardCache = nil;
		_moveHashes = [[NSMutableArray alloc] init];
    }
	
    return self;
}

- (id) initWithBoard:(GoBoard*)board;
{
	if ((self = [self init]) && board) {
		self.board = board;
		
		// board cache is two bits per board location 
		_boardCache = [[NSMutableData dataWithLength:(int)(ceilf(powf((float)_board.boardView.markerLayer.boardSize, 2.0) / (8.0 / kGoBoardCacheBitWidth)))] retain];
		NSLog(@"Board cache is %d bytes for boardSize %d", [_boardCache length], _board.boardView.markerLayer.boardSize);
		memset([_boardCache mutableBytes], 0, [_boardCache length]);
	}
	
	return self;
}

+ (GoReferee*) createWithBoard:(GoBoard*)board;
{
	return [[[GoReferee alloc] initWithBoard:board] autorelease];
}

- (void) dealloc;
{
	[_sgf release];
	[_boardCache release];
	[_moveHashes release];
	[super dealloc];
}

- (GoBoardCacheValue) _cacheValueAtLocation:(CGPoint)location;
{
	int bs = _board.boardView.markerLayer.boardSize;
	int nBits = kGoBoardCacheBitWidth;
	
	int plusBits = (((int)location.x - 1) * nBits) + ((((int)location.y - 1) * bs) * nBits);
	UInt8* bitPtr = ((UInt8*)[_boardCache bytes]) + (int)(plusBits / 8);
	int mask = 0x3 << (plusBits % 4);
	NSLog(@"plusBits: %d\tbitPtr: %x\tmask: %x\tval: %x", plusBits, bitPtr, mask, ((*bitPtr) & mask));
	
	return ((*bitPtr) & mask);
}

- (GoMoveResponse) attemptMoveAtLocation:(CGPoint)location
{
	[self _cacheValueAtLocation:location];
    return kGoMoveAccepted;
}

@end
