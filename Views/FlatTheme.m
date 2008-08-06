//
//  FlatTheme.m
//  uGo
//
//  Created by Jacob Farkas on 7/22/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "FlatTheme.h"

@implementation FlatTheme

- (id) init
{
    if ((self = [super init])) {
        _name = @"Flat";
    }
    return self;
}

// Let the superclass do all the work. The flat theme is the default theme.

@end
