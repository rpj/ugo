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

@interface GoReferee (Private)
- (UInt8*) _mutablePointerForLocation:(CGPoint)loc outShift:(out int*)outShift;
- (void) _setCacheValueAtLocation:(CGPoint)loc toValue:(GoBoardCacheValue)val;
- (int) _numberOfLibertiesAtLocation:(CGPoint)location isControlledByPlayer:(out GoBoardCacheValue*)player;
- (int) _libertiesAtLocation:(CGPoint)location;
- (GoBoardCacheValue) _locationBelongsToPlayer:(CGPoint)location;
- (GoBoardCacheValue) _cacheValueAtLocation:(CGPoint)location;
@end

@implementation GoReferee (Private)
- (UInt8*) _mutablePointerForLocation:(CGPoint)loc outShift:(out int*)outShift;
{	
	UInt8* bitPtr = nil;
	int bs = _board.boardView.markerLayer.boardSize;
	int nBits = kGoBoardCacheBitWidth;
	
	int plusBits = (((int)loc.x - 1) * nBits) + ((((int)loc.y - 1) * bs) * nBits);
	bitPtr = ((UInt8*)[_boardCache mutableBytes]) + (int)(plusBits / 8);
	
	if (bitPtr && outShift)
		*outShift = plusBits % 8;
	
	return bitPtr;
}

- (void) _setCacheValueAtLocation:(CGPoint)loc toValue:(GoBoardCacheValue)val;
{
	int shift = -1;
	UInt8* ptr = [self _mutablePointerForLocation:loc outShift:&shift];
	
	if (ptr && val != kGoBoardCacheLastValue)
		*ptr |= (val << shift);
}

- (GoBoardCacheValue) _cacheValueAtLocation:(CGPoint)location;
{
	int shift = -1;
	GoBoardCacheValue retVal = kGoBoardCacheLastValue;
	UInt8* bitPtr = [self _mutablePointerForLocation:location outShift:&shift];
	
	if (shift > -1 && bitPtr)
		retVal = (GoBoardCacheValue)(((*bitPtr) >> shift) & kGoBoardCacheBaseMask);
	
	return retVal;
}

- (int) _numberOfLibertiesAtLocation:(CGPoint)location isControlledByPlayer:(out GoBoardCacheValue*)player;
{
	int libCount = 0;
	int sub = -1, xOrY = 0;
	CGFloat nx = -1, ny = -1;
	char blackCount = 0, whiteCount = 0, possibleCount = 0;
	
	for (; sub < 2; sub += 2) {
		for (xOrY = 0; xOrY < 2; xOrY++) {
			nx = location.x + (xOrY ? sub : 0);
			ny = location.y + (xOrY ? 0 : sub);
			
			if ((nx > 0 && nx <= _boardSize)  && (ny > 0 && ny <= _boardSize) && ++possibleCount) {
				GoBoardCacheValue tVal = [self _cacheValueAtLocation:CGPointMake(nx, ny)];
				
				if (tVal == kGoBoardCacheBlackPiece) blackCount++;
				if (tVal == kGoBoardCacheWhitePiece) whiteCount++;
				if (tVal == kGoBoardCacheNoPiece) libCount++;
			}
		}
	}
	
	if (blackCount + whiteCount + libCount != possibleCount)
		NSLog(@"Bad counts.");
	
	// by the this definition, a location is under "control" if and only if the surronding points
	// are all held by pieces of the same color; this definition may need to be ammended to actually be useful
	if (player && (blackCount == possibleCount || whiteCount == possibleCount))
		*player = (blackCount == possibleCount ? kGoBoardCacheBlackPiece : kGoBoardCacheWhitePiece);
	
	return libCount;
}

- (int) _libertiesAtLocation:(CGPoint)location;
{
	return [self _numberOfLibertiesAtLocation:location isControlledByPlayer:nil];
}

- (GoBoardCacheValue) _locationBelongsToPlayer:(CGPoint)location;
{
	GoBoardCacheValue val = kGoBoardCacheNoPiece;
	
	if ([self _numberOfLibertiesAtLocation:location isControlledByPlayer:&val] != 0)
		NSLog(@"Can't even happen!");
	
	return val;
}
@end

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
		_boardSize = _board.boardView.markerLayer.boardSize;
		
		// board cache is two bits per board location 
		NSUInteger cacheSize = (NSUInteger)(ceilf(powf((float)_boardSize, 2.0) / (8.0 / kGoBoardCacheBitWidth)));
		_boardCache = [[NSMutableData dataWithLength:cacheSize] retain];
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

- (BOOL) locationIsEmpty:(CGPoint)location;
{
	return [self _cacheValueAtLocation:location] == kGoBoardCacheNoPiece;
}

- (GoMoveResponse) attemptMoveAtLocation:(CGPoint)location
{
	static BOOL wMove = NO;		// so hacky it's like the white-trash derby of coding
	GoMoveResponse resp = kGoMoveAccepted;
	
	GoBoardCacheValue control = 0;
	int lib = [self _numberOfLibertiesAtLocation:location isControlledByPlayer:&control];
	
	if (control || !lib) 
		resp = kGoMoveDeniedSuicide;
	
	// check for Ko
	if (resp == kGoMoveAccepted) {
		NSUInteger count = [_moveHashes count];
		// this hash (from NSObject) might not be enough, but it seems to be working at the moment
		NSNumber* nHash = [NSNumber numberWithInt:[_boardCache hash]];
		
		// can't check Ko if there aren't yet two moves made
		if (count >= 2) {
			id koCheck = [_moveHashes objectAtIndex:(count - 2)];
			
			if (koCheck && [koCheck isKindOfClass:[NSNumber class]] && [koCheck isEqualToNumber:nHash])
				resp = kGoMoveDeniedKoRule;
		}
		
		if (resp == kGoMoveAccepted) {
			[self _setCacheValueAtLocation:location toValue:(wMove ? kGoBoardCacheWhitePiece : kGoBoardCacheBlackPiece)];
			wMove = (wMove ? NO : YES);
			// add move to the parser object here!
			// should probably move the "move accepted" code elsewhere
			[_moveHashes addObject:nHash];
		}
	}
	
    return resp;
}

@end
