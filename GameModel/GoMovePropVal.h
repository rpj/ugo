//
//  GoMovePropVal.h
//  uGo
//
//  Created by Jacob Farkas on 8/7/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoMovePropVal : NSObject {
    NSString *_value;
    NSString *_value2;
}

@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *value2;

@property (nonatomic, readonly) BOOL isComposed;

+ (GoMovePropVal *) valueWithPropValueStruct:(struct PropValue*)propVal;
+ (GoMovePropVal *) valueWithValue:(NSString *)value;
+ (GoMovePropVal *) composedValueWithValue:(NSString *)value andValue:(NSString *)value2;

@end
