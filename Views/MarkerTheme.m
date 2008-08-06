//
//  MarkerTheme.m
//  uGo
//
//  Created by Jacob Farkas on 7/22/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "MarkerTheme.h"

#import "GoMarker.h"

#define kStoneLineWidth 8

@implementation MarkerTheme

@synthesize name = _name;
@synthesize image = _image;

- (void) dealloc
{
    [_name release];
    [_image release];
    [super dealloc];
}

- (void) drawMarker:(GoMarker *)marker inContext:(CGContextRef)context
{
    switch (marker.type) {
        case kGoMarkerStone:
            [self drawStoneForMarker:marker inContext:context];
            break;
        case kGoMarkerSquareShape:
        case kGoMarkerTriangleShape:
        case kGoMarkerCircleShape:
        case kGoMarkerDotShape:
            [self drawShapeForMarker:marker inContext:context];
            break;
        case kGoMarkerLabel:
            [self drawLabelForMarker:marker inContext:context];
            break;
    }
}

- (void) drawLabelForMarker:(GoMarker *)marker inContext:(CGContextRef)context
{
	CGRect rect = CGContextGetClipBoundingBox(context);
	UIGraphicsPushContext(context);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    // TODO: Add label drawing
    
    // (fark): there's no way this works correctly, and I haven't tested it.
    CGContextShowTextAtPoint(context, rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2, [marker.label UTF8String], [marker.label length]);
    
    UIGraphicsPopContext(); 
}

- (void) drawShapeForMarker:(GoMarker *)marker inContext:(CGContextRef)context
{
//	CGRect rect = CGContextGetClipBoundingBox(context);
//	UIGraphicsPushContext(context);
//    
//    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
//    
//    // TODO: Add shape drawing
//    
//    UIGraphicsPopContext();  
}

- (void) drawStoneForMarker:(GoMarker *)marker inContext:(CGContextRef)context
{
	CGRect rect = CGContextGetClipBoundingBox(context);
	UIGraphicsPushContext(context);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextSetLineWidth(context, kStoneLineWidth);
    if ([marker.color isEqual:[UIColor whiteColor]]) {
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

@end
