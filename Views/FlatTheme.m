//
//  FlatTheme.m
//  uGo
//
//  Created by Jacob Farkas on 7/22/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "FlatTheme.h"

#define kStoneLineWidth 8

@implementation FlatTheme

- (id) init
{
    if ((self = [super init])) {
        _name = @"Flat";
    }
    return self;
}

- (void) drawStone:(GoMarkerType)stoneType inContext:(CGContextRef)context
{
	CGRect rect = CGContextGetClipBoundingBox(context);
	UIGraphicsPushContext(context);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextSetLineWidth(context, kStoneLineWidth);
    if (stoneType == kGoMarkerWhiteStone) {
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

- (void) drawShape:(NSDictionary *)options inContext:(CGContextRef)context
{
    // TODO: implement _drawShape
}

- (void) drawLabel:(NSDictionary *)options inContext:(CGContextRef)context
{
    // TODO: implement _drawLabel
}
@end
