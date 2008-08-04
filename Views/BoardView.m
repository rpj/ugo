//
//  BoardView.m
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoardView.h"
#import "MarkerLayer.h"
#import "GridLayer.h"
#import "GoReferee.h"
#import "GoBoard.h"

#define kBoardStartingSize						320
#define kGridBorderMultiplier					(0.20)

NSString * const kGoMarkerOptionTemporaryMarker = @"MarkerIsTemporary";
NSString * const kGoMarkerOptionColor = @"MarkerColor";
NSString * const kGoMarkerOptionLabel = @"MarkerLabel";
NSString * const kGoMarkerAllowWiggle = @"MarkerWiggle";

@interface MarkerLayer (KnownPrivate)
- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options;
- (void) removeAllMarkersAtLocation:(CGPoint)boardLocation;
- (void) removeAllMarkers;
@end

@implementation BoardView

@synthesize gridLayer = _gridLayer;
@synthesize markerLayer = _markerLayer;
@synthesize referee = _referee;
@synthesize delegate = _delegate;
@synthesize boardSize = _boardSize;

@dynamic gameBoardSize;

- (NSUInteger) gameBoardSize;
{
	return _markerLayer.boardSize;
}

- (void) boardSizeDidChange:(NSNotification *)notif
{
	[_referee release];
	_referee = [[GoReferee alloc] initWithBoardView:self];
    [_gridLayer setNeedsDisplay];
}

- (void) _setSublayerFrames
{
    
    CGFloat gridInnerBorder = self.frame.size.width * kGridBorderMultiplier;
    _gridLayer.frame = CGRectMake((gridInnerBorder/2), (gridInnerBorder/2), 
                                  self.frame.size.width-gridInnerBorder, 
                                  self.frame.size.height-gridInnerBorder);
    _markerLayer.frame = _gridLayer.frame;
    
    [_markerLayer setNeedsDisplay];
    [_gridLayer setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame
{
    super.frame = frame;
    [self _setSublayerFrames];
}

- (id) init
{
    if ((self = [super init])) {        
        self.boardSize = kBoardStartingSize;
        self.frame = CGRectMake(0, 0, _boardSize, _boardSize);
        self.layer.contents = (id)[UIImage imageNamed: @"board512.png"].CGImage;
        
        self.markerLayer = [MarkerLayer layer];
        [self.layer addSublayer:self.markerLayer];
    
        self.gridLayer = [GridLayer layer];
        [self.layer insertSublayer:_gridLayer below:_markerLayer];
		
		self.referee = [[GoReferee alloc] initWithBoardView:self];
        
        [self _setSublayerFrames];
        
        [_markerLayer setNeedsDisplay];
        [_gridLayer setNeedsDisplay];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardSizeDidChange:) name:kBoardSizeChangedNotification object:nil];
        
        [self.layer removeAllAnimations];
    }
    return self;
}

- (void) dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_markerLayer release];
    [_gridLayer release];
	[_referee release];
    
	[super dealloc];
}

- (CGPoint) _boardPointForUIPoint:(CGPoint)point
{
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
    CGPoint gpoint;
    CGFloat lineSep = (_gridLayer.frame.size.width / (boardSize - 1));
    gpoint.x = (int)((point.x - (_gridLayer.frame.origin.x - self.frame.origin.x) + (lineSep/2)) / lineSep) + 1;
    gpoint.y = (int)((point.y - (_gridLayer.frame.origin.y - self.frame.origin.y) + (lineSep/2)) / lineSep) + 1;
    
    if (gpoint.x < 1) gpoint.x = 1;
    else if (gpoint.x > boardSize) gpoint.x = boardSize;
    
    if (gpoint.y < 1) gpoint.y = 1;
    else if (gpoint.y > boardSize) gpoint.y = boardSize;
    
    return gpoint;
}

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options 
{ 
	// this method should never be called on a non-empty location, but just to be safe...
	BOOL placeMarker = [_referee locationIsEmpty:boardLocation];
	NSString* statStr = nil;
	
	if (placeMarker && [[options valueForKey:kGoMarkerOptionTemporaryMarker] boolValue] == NO) {
		GoMoveResponse resp = [_referee attemptMoveAtLocation:boardLocation];
		
		if (resp == kGoMoveDeniedSuicide)
			statStr = @"Feeling suicidal?";
		else if (resp == kGoMoveDeniedKoRule)
			statStr = @"Ko rule violation.";
		else if (resp == kGoMoveDeniedNotYourTurn)
			statStr = @"Not your turn.";
		else if (resp == kGoMovePieceExists)
			statStr = @"Location is occupied.";
		
		placeMarker = (resp == kGoMoveAccepted);
	}
	
	if (statStr)
		[[NSNotificationCenter defaultCenter] postNotificationName:kGoBoardViewStatusUpdateNotification
															object:nil
														  userInfo:[NSDictionary dictionaryWithObject:statStr forKey:@"status"]];
		
	if (placeMarker)
		[_markerLayer placeMarker:type atLocation:boardLocation options:options];
}

- (void) removeAllMarkersAtLocation:(CGPoint)boardLocation { [_markerLayer removeAllMarkersAtLocation:boardLocation]; }

- (void) removeAllMarkers { [_markerLayer removeAllMarkers]; }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate) {
        if ([touches count] < 1) return;
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        
        CGPoint boardLocation = [self _boardPointForUIPoint:[touch locationInView:self]];
		
		if ([_referee locationIsEmpty:boardLocation])
			[_delegate locationWasTouched:boardLocation tapCount:touch.tapCount];
    }
}

@end
