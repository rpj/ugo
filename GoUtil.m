//
//  GoUtil.m
//  uGo
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoUtil.h"

@implementation CALayerNonAnimating
- (id<CAAction>)actionForKey:(NSString *)key;
{
	// return nil to disable animations on this layer
	return nil;
}
@end
