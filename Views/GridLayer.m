//
//  GridLayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/21/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GridLayer.h"

#define kGridLineWidth					(4.0)
#define kDotSquareWH					(20.0)

@implementation GridLayer

- (void)drawInContext:(CGContextRef)context
{
	CGRect rect = CGContextGetClipBoundingBox(context);
    NSUInteger gridSize = [[uGoSettings sharedSettings] boardSize] - 1;
    CGFloat lineSep = (rect.size.width / gridSize);
    UIGraphicsPushContext(context);
    if (rect.size.width != rect.size.height)
        NSLog(@"Rect for drawLayer::_gridLayer isn't a square!");
    
    // draw grid border
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, kGridLineWidth);
    
    
    // draw grid lines
    for (NSUInteger count = 0; count <= gridSize; count++)
    {
        CGFloat add = lineSep * count;
		
		// account for the fact that grid borders were getting drawn with half of their line width outside the frame
		// probably not the best fix, but it does work and fixes things "correctly"
		// that is, if you ignore the issue that frame-to-board coordinate mapping will be off by kGridLineWidth/2 at the edges...
		float frameadd = (kGridLineWidth / 2);
		add += (count == 0 ? frameadd : (count == gridSize ? -frameadd : 0));
        
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
    NSUInteger correctGSize = gridSize + 1;
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

@end
