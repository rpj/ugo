//
//  BoardView.m
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoardView.h"
#import "BoardLayer.h"
#import "MarkerLayer.h"

NSString * const kGoMarkerOptionTemporaryMarker = @"MarkerIsTemporary";
NSString * const kGoMarkerOptionColor = @"MarkerColor";
NSString * const kGoMarkerOptionLabel = @"MarkerLabel";

@implementation BoardView

@synthesize _boardLayer;

- (void) boardSizeDidChange:(NSNotification *)notif
{
    [self drawGridOfSize:[[uGoSettings sharedSettings] boardSize]];
}

- (void) drawGridOfSize:(NSInteger)size
{
    [_boardLayer drawGridOfSize:size];
}

- (id) init
{
    if ((self = [super init])) {
        _curStone = kGoMarkerBlackStone;
        _tempStoneLocation = CGPointMake(-1, -1);
        
        self.frame = CGRectMake(0, 0, kBoardSize, kBoardSize);
        self._boardLayer = [BoardLayer layer];
        _boardLayer.frame = self.frame;
        self.layer.contents = (id)[UIImage imageNamed: @"board1.png"].CGImage;
        
        [self.layer addSublayer:_boardLayer];
        [_boardLayer setNeedsDisplay];
        
        [self drawGridOfSize:[[uGoSettings sharedSettings] boardSize]];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardSizeDidChange:) name:kBoardSizeChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_boardLayer release];
	[super dealloc];
}

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options
{
    [_boardLayer placeMarker:type atLocation:boardLocation options:options];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    if ([touches count] < 1) return;
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    CGPoint boardLocation = [_boardLayer boardPointForUIPoint:[touch locationInView:self]];
    
    if (_tempStoneLocation.x > 0) {
        [_boardLayer removeMarkerAtLocation:_tempStoneLocation];
        _tempStoneLocation = CGPointMake(-1, -1);
    }
    
    if (touch.tapCount == 1) {
        [options setValue:[NSNumber numberWithBool:YES] forKey:kGoMarkerOptionTemporaryMarker];
        _tempStoneLocation = boardLocation;
    }
    
    [_boardLayer placeMarker:_curStone atLocation:boardLocation options:options];

    if (touch.tapCount == 2) {
        _curStone = (_curStone == kGoMarkerBlackStone) ? kGoMarkerWhiteStone : kGoMarkerBlackStone;
    }
}

@end
