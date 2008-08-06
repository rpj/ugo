//
//  GoMarker.m
//  uGo
//
//  Created by Jacob Farkas on 8/5/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoMarker.h"

@implementation GoMarker

@synthesize type = _type;
@synthesize location = _location;
@synthesize color = _color;
@synthesize label = _label;
@synthesize isTemporary = _isTemporary;
@synthesize allowWiggle = _allowWiggle;

- (id) initWithType:(GoMarkerType)type atLocation:(CGPoint)location
{
    if ((self = [super init])) {
        _type = type;
        _location = location;
    }
    return self;
}

- (void) dealloc
{
    [_color release];
    [_label release];
    [super dealloc];
}

+ (GoMarker *) markerOfType:(GoMarkerType)type atLocation:(CGPoint)location
{
    return [[[GoMarker alloc] initWithType:type atLocation:location] autorelease];
}

- (BOOL) isEqual:(id)obj
{
    if (![obj isKindOfClass:[GoMarker class]]) return NO;
    
    GoMarker *other = (GoMarker *)obj;
    if (_type != other.type) return NO;
    if (!CGPointEqualToPoint(_location, other.location)) return NO;
    if (_type == kGoMarkerLabel && ![_label isEqualToString:other.label]) return NO;
    
    return YES;
}

- (NSUInteger)hash
{
    // 01234567 01234567 01234567 01234567
    // type     x pos    y pos
    NSUInteger hash = _type | ((NSUInteger)((int)_location.x & 0xFF) << 8) | ((NSUInteger)((int)_location.y & 0xFF) << 16);
    // XXX: debugging. remove me later
    NSLog(@"Hash for GoMarker of type %d at %@: %04x", _type, NSStringFromCGPoint(_location), hash);
    return hash;
}

@end
