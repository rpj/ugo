//
//  MarkerTheme.h
//  uGo
//
//  Created by Jacob Farkas on 7/22/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoMarker.h"

@interface MarkerTheme : NSObject {
    NSString *_name;
    UIImage *_image;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) UIImage *image; // theme coverflow? brilliant!

- (void) drawStone:(GoMarkerType)stoneType inContext:(CGContextRef)context;
- (void) drawShape:(NSDictionary *)options inContext:(CGContextRef)context;
- (void) drawLabel:(NSDictionary *)options inContext:(CGContextRef)context;

@end
