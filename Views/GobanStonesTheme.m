//
//  GobanStonesTheme.m
//  uGo
//
//  Created by Ryan Joseph on 7/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GobanStonesTheme.h"
#import "GoMarker.h"

#define kNumberOfWhiteStoneImages		12
#define kNumberOfBlackStoneImages		1
#define kStoneImageResolution			130
#define kWhiteStoneKey					@"White"
#define kBlackStoneKey					@"Black"

@implementation GobanStonesTheme
- (id) init;
{
	if ((self = [super init])) {
		_name = @"FreeGoban Stones";
		_colors = [[NSArray arrayWithObjects: kWhiteStoneKey, kBlackStoneKey, nil] retain];
		NSMutableDictionary* mutImages = [NSMutableDictionary dictionary];
		
		for (NSString* color in _colors) {
			NSUInteger count = 0;
			NSUInteger limit = [color isEqualToString:kWhiteStoneKey] ? kNumberOfWhiteStoneImages : kNumberOfBlackStoneImages;
			NSMutableArray *imgsArr = [NSMutableArray arrayWithCapacity: limit];
			
			for (; count < limit; count++) {
				UIImage* img = [UIImage imageNamed: [NSString stringWithFormat:@"%@Stone%d-%d.png", color, kStoneImageResolution, count]];
				
				if (img)
					[imgsArr addObject: img];
			}
			
			[mutImages setObject:imgsArr forKey:color];
		}
		
		_stoneImages = (NSDictionary*)[mutImages retain];;
		srandom(time(nil));
	}
	
	return self;
}

- (void) dealloc;
{
	[_colors release];
	[_stoneImages release];
	
	[super dealloc];
}

- (void) drawStoneForMarker:(GoMarker *)marker inContext:(CGContextRef)context;
{
	CGRect rect = CGContextGetClipBoundingBox(context);
	UIGraphicsPushContext(context);
	
    NSString *key = nil;
    NSUInteger lim = 0;
    if ([marker.color isEqual:[UIColor whiteColor]]) {
        key = kWhiteStoneKey;
        lim = kNumberOfWhiteStoneImages;
    } else {
        key = kBlackStoneKey;
        lim = kNumberOfBlackStoneImages;
    }
	
	NSArray* sImgs = [_stoneImages objectForKey:key];
	UIImage* img = [sImgs objectAtIndex:(lim ? (random() % lim) : 0)];
	if (img) [img drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
	
	UIGraphicsPopContext();
}

@end
