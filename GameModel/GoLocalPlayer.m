//
//  GoLocalPlayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoLocalPlayer.h"

#import "GoReferee.h"

@implementation GoLocalPlayer

- (void) locationWasTouched:(CGPoint)boardLocation tapCount:(NSUInteger)tapCount
{
    [self.referee attemptMoveAtLocation:boardLocation];
}

@end
