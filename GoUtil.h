//
//  GoUtil.h
//  uGo
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CALayerNonAnimating : CALayer
- (id<CAAction>)actionForKey:(NSString *)key;
@end
