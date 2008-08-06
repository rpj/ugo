//
//  MarkerTheme.h
//  uGo
//
//  Created by Jacob Farkas on 7/22/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoMarker;

@interface MarkerTheme : NSObject {
    NSString *_name;
    UIImage *_image;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) UIImage *image; // theme coverflow? brilliant!

- (void) drawMarker:(GoMarker *)marker inContext:(CGContextRef)context;

- (void) drawLabelForMarker:(GoMarker *)marker inContext:(CGContextRef)context;
- (void) drawShapeForMarker:(GoMarker *)marker inContext:(CGContextRef)context;
- (void) drawStoneForMarker:(GoMarker *)marker inContext:(CGContextRef)context;

@end
