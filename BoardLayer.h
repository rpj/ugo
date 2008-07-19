//
//  BoardLayer.h
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface BoardLayer : CALayer {
	UIImage*	_boardImg;
	CALayer*	_gridLayer;
	
	NSUInteger	_gridSize;
	CGFloat		_gridInnerBorder;
}

@property (nonatomic, retain) UIImage* _boardImg;
@property (nonatomic, retain) CALayer* _gridLayer;

- (void) drawGridOfSize: (NSInteger)size;

@end
