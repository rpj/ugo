//
//  BoardLayer.m
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoardLayer.h"

#define kGridBorderMultiplier			(0.20)
#define kGridLineWidth					(4.0)
#define kDotSquareWH					(20.0)

@implementation BoardLayer

@synthesize gridLayer = _gridLayer;
@synthesize stoneLayer = _stoneLayer;

- (void) setGridFrameAndDisplay;
{
	_gridInnerBorder = self.frame.size.width * kGridBorderMultiplier;
	_gridLayer.frame = CGRectMake((_gridInnerBorder/2), (_gridInnerBorder/2), 
								  self.frame.size.width-_gridInnerBorder, 
								  self.frame.size.height-_gridInnerBorder);
	
	[_gridLayer setNeedsDisplay];
}

- (CGPoint) boardPointForUIPoint:(CGPoint)point
{
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
    CGPoint gpoint;
    gpoint.x = (int)((point.x - (_gridLayer.frame.origin.x - self.frame.origin.x) + (_lineSep/2)) / _lineSep) + 1;
    gpoint.y = (int)((point.y - (_gridLayer.frame.origin.y - self.frame.origin.y) + (_lineSep/2)) / _lineSep) + 1;
    
    if (gpoint.x < 1) gpoint.x = 1;
    else if (gpoint.x > boardSize) gpoint.x = boardSize;

    if (gpoint.y < 1) gpoint.y = 1;
    else if (gpoint.y > boardSize) gpoint.y = boardSize;
    
    return gpoint;
}

- (void) _placeLayer:(CALayer *)layer asStoneAtLocation:(CGPoint)location
{
    CGFloat stoneSize = _lineSep * .95;
    
    [layer setValue:(_whiteTurn ? @"WhiteStone" : @"BlackStone") forKey:@"StoneType"]; //egregious hack for testing
    
    CGPoint vpoint;
    vpoint.x = (location.x - 1) * _lineSep + (_gridLayer.frame.origin.x - self.frame.origin.x);
    vpoint.y = (location.y - 1) * _lineSep + (_gridLayer.frame.origin.y - self.frame.origin.y);
    layer.frame = CGRectMake(vpoint.x - stoneSize/2.0, vpoint.y - stoneSize/2.0, stoneSize, stoneSize);
    layer.delegate = self;
    [_stoneLayer addSublayer:layer];
    [layer setNeedsDisplay];
    
    [_allStones addObject:layer];
}

- (void) placeTemporaryStone:(CGPoint)boardLocation
{
    [_tempStoneLayer removeFromSuperlayer];
    _tempStoneLayer = [CALayer layer];
    _tempStoneLayer.opacity = 0.5;
    [self _placeLayer:_tempStoneLayer asStoneAtLocation:boardLocation];
}

- (void) placeStone:(CGPoint)boardLocation
{
    [_tempStoneLayer removeFromSuperlayer];
    _tempStoneLayer = nil;
    [self _placeLayer:[CALayer layer] asStoneAtLocation:boardLocation];
    _whiteTurn = !_whiteTurn;
}

- (void) drawGridOfSize: (NSInteger)size;
{
	_gridSize = (size - 1);
	
	if (_gridLayer) {
		[_gridLayer removeFromSuperlayer];
	}
    
    for (CALayer *stone in _allStones) {
        [stone removeFromSuperlayer];
    }
    [_allStones removeAllObjects];
    _tempStoneLayer = nil;
	
	self.gridLayer = [CALayer layer];
	_gridLayer.delegate = self;
	
	[self setGridFrameAndDisplay];
	[self insertSublayer:_gridLayer below:_stoneLayer];
}
	
- (void)drawInContext:(CGContextRef)context
{
    [self setGridFrameAndDisplay];
}

- (void) _drawGridInContext:(CGContextRef)context
{
	CGRect rect = CGContextGetClipBoundingBox(context);
	UIGraphicsPushContext(context);
    if (rect.size.width != rect.size.height)
        NSLog(@"Rect for drawLayer::_gridLayer isn't a square!");
    
    // draw grid border
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, kGridLineWidth);
    
    _lineSep = (rect.size.width / _gridSize);
    
    // draw grid lines
    for (NSUInteger count = 0; count <= _gridSize; count++)
    {
        CGFloat add = _lineSep * count;
		
		// account for the fact that grid borders were getting drawn with half of their line width outside the frame
		// probably not the best fix, but it does work and fixes things "correctly"
		// that is, if you ignore the issue that frame-to-board coordinate mapping will be off by kGridLineWidth/2 at the edges...
		float frameadd = (kGridLineWidth / 2);
		add += (count == 0 ? frameadd : (count == _gridSize ? -frameadd : 0));
        
        // draw with paths...
        // vertical
        CGContextBeginPath(context);
        CGFloat xCoord = rect.origin.x + add;
        CGContextMoveToPoint(context, xCoord, rect.origin.y);
        CGContextAddLineToPoint(context, xCoord, rect.origin.y + rect.size.height);
        CGContextStrokePath(context);
        
        // horizontal
        CGContextBeginPath(context);
        CGFloat yCoord = rect.origin.y + add;
        CGContextMoveToPoint(context, rect.origin.x, yCoord);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, yCoord);
        CGContextStrokePath(context);
    }
    
    // draw grid dots
    NSUInteger correctGSize = _gridSize + 1;
    NSUInteger cornerSep = (correctGSize < 13) ? 2 : 3;
    NSUInteger numDots = (correctGSize == 7) ? 4 : ((correctGSize < 15) ? 5 : 9);
    
    CGFloat add		= (_lineSep * cornerSep);
    CGFloat _x		= rect.origin.x; 
    CGFloat _y		= rect.origin.y;
    CGFloat _w		= rect.size.width;
    CGFloat _h		= rect.size.height;
    CGFloat _whmod	= (kDotSquareWH / 2);
    
    
    CGPoint tl = CGPointMake(_x + add, _y + add);
    CGPoint tr = CGPointMake(_w - add, _y + add);
    CGPoint bl = CGPointMake(_x + add, _h - add);
    CGPoint br = CGPointMake(_w - add, _h - add);
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokeEllipseInRect(context, CGRectMake(tl.x - _whmod, tl.y - _whmod, kDotSquareWH, kDotSquareWH));
    CGContextStrokeEllipseInRect(context, CGRectMake(tr.x - _whmod, tr.y - _whmod, kDotSquareWH, kDotSquareWH));
    CGContextStrokeEllipseInRect(context, CGRectMake(br.x - _whmod, br.y - _whmod, kDotSquareWH, kDotSquareWH));
    CGContextStrokeEllipseInRect(context, CGRectMake(bl.x - _whmod, bl.y - _whmod, kDotSquareWH, kDotSquareWH));
    
    CGContextFillEllipseInRect(context, CGRectMake(tl.x - _whmod, tl.y - _whmod, kDotSquareWH, kDotSquareWH));
    CGContextFillEllipseInRect(context, CGRectMake(tr.x - _whmod, tr.y - _whmod, kDotSquareWH, kDotSquareWH));
    CGContextFillEllipseInRect(context, CGRectMake(br.x - _whmod, br.y - _whmod, kDotSquareWH, kDotSquareWH));
    CGContextFillEllipseInRect(context, CGRectMake(bl.x - _whmod, bl.y - _whmod, kDotSquareWH, kDotSquareWH));
    
    // draw the center dot (if needed) and the other side dots (if needed)
    if (numDots > 4) {
        CGFloat _wd2 = (_w / 2);
        CGFloat _hd2 = (_h / 2);
        
        CGRect _rect = CGRectMake(_wd2 - _whmod, _hd2 - _whmod, kDotSquareWH, kDotSquareWH);
        CGContextStrokeEllipseInRect(context, _rect);
        CGContextFillEllipseInRect(context, _rect);
        
        if (numDots > 5) {
            tl = CGPointMake(_wd2, _y + add);
            bl = CGPointMake(_wd2, _h - add);
            tr = CGPointMake(_x + add, _hd2);
            br = CGPointMake(_w - add, _hd2);
            
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
            CGContextStrokeEllipseInRect(context, CGRectMake(tl.x - _whmod, tl.y - _whmod, kDotSquareWH, kDotSquareWH));
            CGContextStrokeEllipseInRect(context, CGRectMake(tr.x - _whmod, tr.y - _whmod, kDotSquareWH, kDotSquareWH));
            CGContextStrokeEllipseInRect(context, CGRectMake(br.x - _whmod, br.y - _whmod, kDotSquareWH, kDotSquareWH));
            CGContextStrokeEllipseInRect(context, CGRectMake(bl.x - _whmod, bl.y - _whmod, kDotSquareWH, kDotSquareWH));
            
            CGContextFillEllipseInRect(context, CGRectMake(tl.x - _whmod, tl.y - _whmod, kDotSquareWH, kDotSquareWH));
            CGContextFillEllipseInRect(context, CGRectMake(tr.x - _whmod, tr.y - _whmod, kDotSquareWH, kDotSquareWH));
            CGContextFillEllipseInRect(context, CGRectMake(br.x - _whmod, br.y - _whmod, kDotSquareWH, kDotSquareWH));
            CGContextFillEllipseInRect(context, CGRectMake(bl.x - _whmod, bl.y - _whmod, kDotSquareWH, kDotSquareWH));
        }
    }
	
	UIGraphicsPopContext();    
}

#define kStoneLineWidth 8
- (void) _drawStone:(NSString *)stoneType inContext:(CGContextRef)context
{
	CGRect rect = CGContextGetClipBoundingBox(context);
	UIGraphicsPushContext(context);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextSetLineWidth(context, kStoneLineWidth);
    if ([stoneType isEqualToString:@"WhiteStone"]) {
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    } else {
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    }
    
    CGContextAddEllipseInRect(context, CGRectMake(rect.origin.x + (kStoneLineWidth/2), rect.origin.y + (kStoneLineWidth/2), rect.size.width - kStoneLineWidth, rect.size.height - kStoneLineWidth));
    CGContextStrokePath(context);
    CGContextFillEllipseInRect(context, rect);
    
    UIGraphicsPopContext(); 
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context;
{
    NSString *stoneType = [layer valueForKey:@"StoneType"];
    if (layer == _gridLayer) {
        [self _drawGridInContext:context];
    }
    else if (stoneType) {
        [self _drawStone:stoneType inContext:context];
    }
}

- (id) init
{
    if ((self = [super init])) {
        _allStones = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc;
{
	[_gridLayer release];
	[_stoneLayer release];
    [_allStones release];
    
	[super dealloc];
}


+ (BoardLayer*) layer;
{
	BoardLayer* _new = [super layer];
	
	if (_new) {
		_new.gridLayer = nil;
        _new.stoneLayer = [CALayer layer];
        [_new addSublayer:_new.stoneLayer];
	}
	
	return _new;
}
@end
