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

#define kGridBorderMultiplier			(0.20)

NSString * const kGoMarkerOptionTemporaryMarker = @"MarkerIsTemporary";
NSString * const kGoMarkerOptionColor = @"MarkerColor";
NSString * const kGoMarkerOptionLabel = @"MarkerLabel";

@implementation BoardView

@synthesize gridLayer = _gridLayer;
@synthesize markerLayer = _markerLayer;

- (void) boardSizeDidChange:(NSNotification *)notif
{
    [_gridLayer setNeedsDisplay];
}

- (id) init
{
    if ((self = [super init])) {
        _curStone = kGoMarkerBlackStone;
        _tempStoneLocation = CGPointMake(-1, -1);
        
        self.frame = CGRectMake(0, 0, kBoardSize, kBoardSize);
        self.layer.contents = (id)[UIImage imageNamed: @"board1.png"].CGImage;
        
        self.markerLayer = [MarkerLayer layer];
        [self.layer addSublayer:self.markerLayer];
    
        self.gridLayer = [GridLayer layer];
        [self.layer insertSublayer:_gridLayer below:_markerLayer];
        
        CGFloat gridInnerBorder = self.frame.size.width * kGridBorderMultiplier;
        _gridLayer.frame = CGRectMake((gridInnerBorder/2), (gridInnerBorder/2), 
                                      self.frame.size.width-gridInnerBorder, 
                                      self.frame.size.height-gridInnerBorder);
        _markerLayer.frame = _gridLayer.frame;
        
        [_markerLayer setNeedsDisplay];
        [_gridLayer setNeedsDisplay];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardSizeDidChange:) name:kBoardSizeChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_markerLayer release];
    [_gridLayer release];
    
	[super dealloc];
}

- (CGPoint) _boardPointForUIPoint:(CGPoint)point
{
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize] - 1;
    CGPoint gpoint;
    CGFloat lineSep = (_gridLayer.frame.size.width / boardSize);
    gpoint.x = (int)((point.x - (_gridLayer.frame.origin.x - self.frame.origin.x) + (lineSep/2)) / lineSep) + 1;
    gpoint.y = (int)((point.y - (_gridLayer.frame.origin.y - self.frame.origin.y) + (lineSep/2)) / lineSep) + 1;
    
    if (gpoint.x < 1) gpoint.x = 1;
    else if (gpoint.x > boardSize) gpoint.x = boardSize;
    
    if (gpoint.y < 1) gpoint.y = 1;
    else if (gpoint.y > boardSize) gpoint.y = boardSize;
    
    return gpoint;
}

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options { [_markerLayer placeMarker:type atLocation:boardLocation options:options]; }

- (void) removeMarkerAtLocation:(CGPoint)boardLocation { [_markerLayer removeMarkerAtLocation:boardLocation]; }

- (void) removeAllMarkers { [_markerLayer removeAllMarkers]; }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    if ([touches count] < 1) return;
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    CGPoint boardLocation = [self _boardPointForUIPoint:[touch locationInView:self]];
    
    if (_tempStoneLocation.x > 0) {
        [_markerLayer removeMarkerAtLocation:_tempStoneLocation];
        _tempStoneLocation = CGPointMake(-1, -1);
    }
    
    if (touch.tapCount == 1) {
        [options setValue:[NSNumber numberWithBool:YES] forKey:kGoMarkerOptionTemporaryMarker];
        _tempStoneLocation = boardLocation;
    }
    
    [_markerLayer placeMarker:_curStone atLocation:boardLocation options:options];

    if (touch.tapCount == 2) {
        _curStone = (_curStone == kGoMarkerBlackStone) ? kGoMarkerWhiteStone : kGoMarkerBlackStone;
    }
}

@end
