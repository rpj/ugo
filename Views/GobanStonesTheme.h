//
//  GobanStonesTheme.h
//  uGo
//
//  Created by Ryan Joseph on 7/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MarkerTheme.h"

@interface GobanStonesTheme : MarkerTheme {
	NSDictionary *_stoneImages;
	NSArray *_colors;
}

- (void) drawStone:(GoMarkerType)stoneType inContext:(CGContextRef)context;
- (void) drawShape:(NSDictionary *)options inContext:(CGContextRef)context;
- (void) drawLabel:(NSDictionary *)options inContext:(CGContextRef)context;

@end
