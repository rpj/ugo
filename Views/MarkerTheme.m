//
//  MarkerTheme.m
//  uGo
//
//  Created by Jacob Farkas on 7/22/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "MarkerTheme.h"

@implementation MarkerTheme

@synthesize name = _name;
@synthesize image = _image;

- (void) dealloc
{
    [_name release];
    [_image release];
    [super dealloc];
}

- (void) drawStone:(GoMarkerType)stoneType inContext:(CGContextRef)context
{ NSAssert(false, @"drawStone: called on superclass"); }

- (void) drawShape:(NSDictionary *)options inContext:(CGContextRef)context
{ NSAssert(false, @"drawShape: called on superclass"); }

- (void) drawLabel:(NSDictionary *)options inContext:(CGContextRef)context;
{ NSAssert(false, @"drawLabel: called on superclass"); }
@end
