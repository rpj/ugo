//
//  BoardLayer.m
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoardLayer.h"

#define kGridBorderMultiplier			(0.15)
#define kGridLineWidth					(1.0)
#define kDotSquareWH					(4.0)

@implementation BoardLayer

@synthesize _boardImg;
@synthesize _gridLayer;

- (void) setGridFrameAndDisplay;
{
	_gridInnerBorder = self.frame.size.width * kGridBorderMultiplier;
	_gridLayer.frame = CGRectMake((_gridInnerBorder/2), (_gridInnerBorder/2), 
								  self.frame.size.width-_gridInnerBorder, 
								  self.frame.size.height-_gridInnerBorder);
	
	[_gridLayer setNeedsDisplay];
}


- (void) drawGridOfSize: (NSInteger)size;
{
	_gridSize = (size - 1);
	
	if (_gridLayer) {
		[_gridLayer removeFromSuperlayer];
	}
	
	self._gridLayer = [CALayer layer];
	_gridLayer.delegate = self;
	

	[self setGridFrameAndDisplay];
	[self addSublayer: _gridLayer];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context;
{
	CGRect rect = CGContextGetClipBoundingBox(context);
	UIGraphicsPushContext(context);
	
	if (layer == self) {
		[_boardImg drawInRect: rect blendMode: kCGBlendModeNormal alpha: 1.0];
		
		if (_gridLayer) {
			[self setGridFrameAndDisplay];
		}
	}
	else if (layer == _gridLayer)
	{
		if (rect.size.width != rect.size.height)
			NSLog(@"Rect for drawLayer::_gridLayer isn't a square!");

		// draw grid border
		CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.0);
		CGContextStrokeRectWithWidth(context, rect, kGridLineWidth);
		
		NSUInteger count = 1;
		CGFloat lineSep = (rect.size.width / _gridSize);
		
		// draw grid lines
		for (; count < _gridSize; count++)
		{
			CGFloat add = lineSep * count;
			
			// draw with paths...
			// horizontal
			CGContextBeginPath(context);
			CGFloat xCoord = rect.origin.x + add;
			CGContextMoveToPoint(context, xCoord, rect.origin.y);
			CGContextAddLineToPoint(context, xCoord, rect.origin.y + rect.size.height);
			CGContextSetLineWidth(context, 0.5);
			CGContextStrokePath(context);
			
			// vertical
			CGContextBeginPath(context);
			CGFloat yCoord = rect.origin.y + add;
			CGContextMoveToPoint(context, rect.origin.x, yCoord);
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, yCoord);
			CGContextSetLineWidth(context, 0.5);
			CGContextStrokePath(context);
		}
		
		// draw grid dots
		NSUInteger correctGSize = _gridSize + 1;
		NSUInteger cornerSep = (correctGSize < 13) ? 2 : 3;
		NSUInteger numDots = (correctGSize == 7) ? 4 : ((correctGSize < 15) ? 5 : 9);
		
		CGFloat add		= (lineSep * cornerSep);
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
		
		// draw the center dot (if needed) and the other side dots (if needed)
		if (numDots > 4) {
			CGFloat _wd2 = (_w / 2);
			CGFloat _hd2 = (_h / 2);
			
			CGRect _rect = CGRectMake(_wd2 - _whmod, _hd2 - _whmod, kDotSquareWH, kDotSquareWH);
			CGContextStrokeEllipseInRect(context, _rect);
			
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
			}
		}
	}
	
	UIGraphicsPopContext();
}


- (void) dealloc;
{
	[_boardImg release];
	[_gridLayer release];
	
	[super dealloc];
}


+ (BoardLayer*) layer;
{
	BoardLayer* _new = [super layer];
	
	if (_new) {
		_new.delegate = _new;
		_new._boardImg = [UIImage imageNamed: @"board1.png"];
		_new._gridLayer = nil;
	}
	
	return _new;
}
@end
