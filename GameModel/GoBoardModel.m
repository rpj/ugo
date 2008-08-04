//
//  GoBoardModel.m
//  uGo
//
//  Created by Ryan Joseph on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GoBoardModel.h"

#import "ParserBridge.h"

@interface GoBoardModel (Private)
- (UInt8*) _mutableCachePointerForLocation:(CGPoint)loc outShift:(out int*)outShift;
- (int) _libertiesAtLocation:(CGPoint)location isControlledByPlayer:(out GoBoardCacheValue*)player;
- (BOOL) _setValueAtLocation:(CGPoint)loc toValue:(GoBoardCacheValue)val;
- (BOOL) _rollbackLastSetValue;
@end

@implementation  GoBoardModel (Private)
- (UInt8*) _mutableCachePointerForLocation:(CGPoint)loc outShift:(out int*)outShift;
{	
	UInt8* bitPtr = nil;
	int bs = _boardSize;
	int nBits = kGoBoardCacheBitWidth;
	
	int plusBits = (((int)loc.x - 1) * nBits) + ((((int)loc.y - 1) * bs) * nBits);
	bitPtr = ((UInt8*)[_boardCache mutableBytes]) + (int)(plusBits / 8);
	
	if (bitPtr && outShift)
		*outShift = plusBits % 8;
	
	return bitPtr;
}


- (int) _libertiesAtLocation:(CGPoint)location isControlledByPlayer:(out GoBoardCacheValue*)player;
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
				GoBoardCacheValue tVal = [self valueAtLocation:CGPointMake(nx, ny)];
				
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

- (BOOL) _setValueAtLocation:(CGPoint)loc toValue:(GoBoardCacheValue)val;
{
	int shift = -1;
	UInt8* ptr = [self _mutableCachePointerForLocation:loc outShift:&shift];
	BOOL retVal = NO;
	
	// note that _lastSetValue and _lastSetByte are assigned to in the following lines
	if (val != kGoBoardCacheLastValue && (_lastSetByte = ptr) && (retVal = YES))
		*ptr |= (_lastSetValue = (val << shift));
	
	return retVal;
}

- (BOOL) _rollbackLastSetValue;
{
	if (_lastSetByte && _lastSetValue) {
		*_lastSetByte -= _lastSetValue;
		_lastSetByte = nil;
		_lastSetByte = kGoBoardCacheNoPiece;
	}
	
	return NO;
}
@end


@implementation GoBoardModel
- (id) initWithBoardSize:(NSUInteger)boardSize;
{
	if ((self = [super init])) {
		_moveHashes = [[NSMutableArray alloc] init];
		_boardSize = boardSize;
		_lastSetByte = nil;
		_lastSetValue = kGoBoardCacheNoPiece;
		
		// this will need to get changed; crappy file name
		_sgf = [[ParserBridge alloc] initWithPath:[[[NSBundle mainBundle] bundlePath] 
												   stringByAppendingPathComponent:[NSString stringWithFormat:@"%x.sgf"]]];
		
		// board cache is two bits per board location 
		NSUInteger cacheSize = (NSUInteger)(ceilf(powf((float)_boardSize, 2.0) / (8.0 / kGoBoardCacheBitWidth)));
		_boardCache = [[NSMutableData dataWithLength:cacheSize] retain];
		memset([_boardCache mutableBytes], 0, [_boardCache length]);
	}
	
	return self;
}

- (void) dealloc;
{
	[_moveHashes release];
	[_sgf release];
	[_boardCache release];
	
	[super dealloc];
}

- (BOOL) addMove:(GoBoardCacheValue)move atLocation:(CGPoint)location;
{
	if ([self _setValueAtLocation:location toValue:move]) {
		// add move to the parser object here!
		[_moveHashes addObject:[NSNumber numberWithInt:[_boardCache hash]]];
		
		return YES;
	}
	
	return NO;	
}

- (GoBoardCacheValue) valueAtLocation:(CGPoint)location;
{
	int shift = -1;
	GoBoardCacheValue retVal = kGoBoardCacheLastValue;
	UInt8* bitPtr = [self _mutableCachePointerForLocation:location outShift:&shift];
	
	if (shift > -1 && bitPtr)
		retVal = (GoBoardCacheValue)(((*bitPtr) >> shift) & kGoBoardCacheBaseMask);
	
	return retVal;
}

- (int) libertiesAtLocation:(CGPoint)location;
{
	return [self _libertiesAtLocation:location isControlledByPlayer:nil];
}

- (GoBoardCacheValue) locationBelongsToPlayer:(CGPoint)location;
{
	GoBoardCacheValue val = kGoBoardCacheNoPiece;
	[self _libertiesAtLocation:location isControlledByPlayer:&val];
	return val;
}

- (BOOL) move:(GoBoardCacheValue)move atLocationWillViolateKo:(CGPoint)location;
{
	NSUInteger count = [_moveHashes count];
	BOOL retVal = NO;
	
	// apply the move to get the correct new hash; will be (must be) rolled back later
	[self _setValueAtLocation:location toValue:move];
	// this hash (from NSObject) might not be enough, but it seems to be working at the moment
	NSNumber* nHash = [NSNumber numberWithInt:[_boardCache hash]];
	
	// can't check Ko if there aren't yet two moves made prior to this one we're checking
	if (count > 2) {
		id koCheck = [_moveHashes objectAtIndex:(count - 3)];	// - 3 since we pretended to make the move
		
		if (koCheck && [koCheck isKindOfClass:[NSNumber class]] && [koCheck isEqualToNumber:nHash])
			retVal = YES;
	}
	
	[self _rollbackLastSetValue];
	return retVal;
}

- (BOOL) locationIsEmpty:(CGPoint)location;
{
	return [self valueAtLocation:location] == kGoBoardCacheNoPiece;
}
@end
