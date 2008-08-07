//
//  GoMovePropVal.m
//  uGo
//
//  Created by Jacob Farkas on 8/7/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoMovePropVal.h"
#import "all.h"

@implementation GoMovePropVal

@synthesize value = _value;
@synthesize value2 = _value2;

- (id) initWithValue1:(NSString *)value value2:(NSString *)value2
{
    if ((self = [super init])) {
        _value = [value retain];
        _value2 = [value2 retain];
    }
    return self;
}

- (void) dealloc
{
    [_value release];
    [_value2 release];
}

+ (GoMovePropVal *) valueWithPropValueStruct:(struct PropValue*)propVal
{
    NSString *value;
    NSString *value2;
    if (propVal->value) value = [NSString stringWithCString:propVal->value encoding:NSUTF8StringEncoding];
    if (propVal->value2) value2 = [NSString stringWithCString:propVal->value2 encoding:NSUTF8StringEncoding];
    
    return [[[GoMovePropVal alloc] initWithValue1:value value2:value2] autorelease];
}

+ (GoMovePropVal *) valueWithValue:(NSString *)value 
{ 
    return [[[GoMovePropVal alloc] initWithValue1:value value2:nil] autorelease]; 
}

+ (GoMovePropVal *) composedValueWithValue:(NSString *)value andValue:(NSString *)value2
{
    return [[[GoMovePropVal alloc] initWithValue1:value value2:value2] autorelease]; 
}

- (BOOL) isComposed
{
    return (_value != nil && _value2 != nil);
}

@end
