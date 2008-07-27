//
//  GridLayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/21/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GridLayer.h"

@implementation GridLayer

- (id) init
{
    if ((self = [super init])) {
        self.needsDisplayOnBoundsChange = YES;
        [self removeAllAnimations];
    }
    return self;
}

/*
 http://senseis.xmp.net/?EquipmentDimensions
 
 Dimension                  SI       Imperial      Japanese
 (mm)       (inch)
 Board width               424.2     16 23/32     1.4  shaku 尺
 Board length              454.5     17 29/32     1.5  shaku 尺
 Board thickness           151.5      5 31/32     0.5  shaku 尺
 Line spacing width-wise    22           7/8      7.26 bu 分
 Line spacing length-wise   23.7        15/16     7.82 bu 分
 Line thickness              1           1/32     0.3  bu 分
 Star point marker diameter  4           5/32     1.2  bu 分
 Stone diameter             22.5        29/32     7.5  bu 分
 
 Making the grid rectangular would be nice, but not necessary yet. 
 However, we can get the rest of the proportions correct in terms of the line spacing width-wise:
*/

#define kStarPointDiameterRatio     0.18182
#define kLineWidthRatio             0.04545

- (void)drawInContext:(CGContextRef)context
{
    NSLog(@"Drawing grid");
	CGRect rect = CGContextGetClipBoundingBox(context);
    NSUInteger gridSize = [[uGoSettings sharedSettings] boardSize] - 1;
    CGFloat lineSep = rect.size.width / gridSize;
    CGFloat lineWidth = lineSep * kLineWidthRatio;
    CGFloat starPointDiameter = lineSep * kStarPointDiameterRatio;
    
    UIGraphicsPushContext(context);
    if (rect.size.width != rect.size.height)
        NSLog(@"Rect for drawLayer::_gridLayer isn't a square!");
    
    // draw grid border
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, lineWidth);
    
    // draw grid lines
    for (NSUInteger count = 0; count <= gridSize; count++)
    {
        CGFloat add = lineSep * count;
		
		// account for the fact that grid borders were getting drawn with half of their line width outside the frame
		// probably not the best fix, but it does work and fixes things "correctly"
		// that is, if you ignore the issue that frame-to-board coordinate mapping will be off by kGridLineWidth/2 at the edges...
		float frameadd = (lineWidth / 2);
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
    CGFloat _whmod	= (starPointDiameter / 2);
    
    
    CGPoint tl = CGPointMake(_x + add, _y + add);
    CGPoint tr = CGPointMake(_w - add, _y + add);
    CGPoint bl = CGPointMake(_x + add, _h - add);
    CGPoint br = CGPointMake(_w - add, _h - add);
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokeEllipseInRect(context, CGRectMake(tl.x - _whmod, tl.y - _whmod, starPointDiameter, starPointDiameter));
    CGContextStrokeEllipseInRect(context, CGRectMake(tr.x - _whmod, tr.y - _whmod, starPointDiameter, starPointDiameter));
    CGContextStrokeEllipseInRect(context, CGRectMake(br.x - _whmod, br.y - _whmod, starPointDiameter, starPointDiameter));
    CGContextStrokeEllipseInRect(context, CGRectMake(bl.x - _whmod, bl.y - _whmod, starPointDiameter, starPointDiameter));
    
    CGContextFillEllipseInRect(context, CGRectMake(tl.x - _whmod, tl.y - _whmod, starPointDiameter, starPointDiameter));
    CGContextFillEllipseInRect(context, CGRectMake(tr.x - _whmod, tr.y - _whmod, starPointDiameter, starPointDiameter));
    CGContextFillEllipseInRect(context, CGRectMake(br.x - _whmod, br.y - _whmod, starPointDiameter, starPointDiameter));
    CGContextFillEllipseInRect(context, CGRectMake(bl.x - _whmod, bl.y - _whmod, starPointDiameter, starPointDiameter));
    
    // draw the center dot (if needed) and the other side dots (if needed)
    if (numDots > 4) {
        CGFloat _wd2 = (_w / 2);
        CGFloat _hd2 = (_h / 2);
        
        CGRect _rect = CGRectMake(_wd2 - _whmod, _hd2 - _whmod, starPointDiameter, starPointDiameter);
        CGContextStrokeEllipseInRect(context, _rect);
        CGContextFillEllipseInRect(context, _rect);
        
        if (numDots > 5) {
            tl = CGPointMake(_wd2, _y + add);
            bl = CGPointMake(_wd2, _h - add);
            tr = CGPointMake(_x + add, _hd2);
            br = CGPointMake(_w - add, _hd2);
            
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
            CGContextStrokeEllipseInRect(context, CGRectMake(tl.x - _whmod, tl.y - _whmod, starPointDiameter, starPointDiameter));
            CGContextStrokeEllipseInRect(context, CGRectMake(tr.x - _whmod, tr.y - _whmod, starPointDiameter, starPointDiameter));
            CGContextStrokeEllipseInRect(context, CGRectMake(br.x - _whmod, br.y - _whmod, starPointDiameter, starPointDiameter));
            CGContextStrokeEllipseInRect(context, CGRectMake(bl.x - _whmod, bl.y - _whmod, starPointDiameter, starPointDiameter));
            
            CGContextFillEllipseInRect(context, CGRectMake(tl.x - _whmod, tl.y - _whmod, starPointDiameter, starPointDiameter));
            CGContextFillEllipseInRect(context, CGRectMake(tr.x - _whmod, tr.y - _whmod, starPointDiameter, starPointDiameter));
            CGContextFillEllipseInRect(context, CGRectMake(br.x - _whmod, br.y - _whmod, starPointDiameter, starPointDiameter));
            CGContextFillEllipseInRect(context, CGRectMake(bl.x - _whmod, bl.y - _whmod, starPointDiameter, starPointDiameter));
        }
    }
	
	UIGraphicsPopContext();    
}

@end
