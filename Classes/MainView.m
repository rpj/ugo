//
//  MainView.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainView.h"

#define CGPointDistanceBetweenInX(one, two)		(((two).x - (one).x))
#define CGPointDistanceBetweenInY(one, two)		(((two).y - (one).y))
#define CGPoint2DDistanceBetween(one, two)		(sqrtf(pow(((two).y - (one).y), 2) + pow(((two).x - (one).x), 2)))
#define CGPointMidPoint(one, two)				(CGPointMake((one).x + (((two).x - (one).x) / 2), (one).y + (((two).y - (one).y) / 2)))

//static CGFloat			gZoomingScalingFactor		= 0.7;
static NSUInteger		gFloatingAvgWindowSize		= 10;

@implementation MainView

- (CGFloat) _currentFloatingAverage;
{
	CGFloat retVal = MAXFLOAT;
	
	if ([_windowArr count] == gFloatingAvgWindowSize)
	{
		long double accum = 0;
		for (NSNumber* num in _windowArr) {
			accum += [num floatValue];
		}
		
		retVal = (CGFloat)(accum / gFloatingAvgWindowSize);
	}
	else {
		retVal = M_E;
	}
	
	return retVal;
}


- (CGFloat) _floatingAverageWithNewest: (CGFloat)newest
{
	if (!_windowArr) {
		_windowArr = [[NSMutableArray alloc] init];
	}
	
	if ([_windowArr count] == gFloatingAvgWindowSize) {
		[_windowArr removeLastObject];
	}
	
	[_windowArr addObject: [NSNumber numberWithFloat: (float)newest]];
	
	return [self _currentFloatingAverage];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	/*NSArray* tArr = [[event touchesForView: self] allObjects];
	
	if (tArr && [tArr count] == 2)
	{
		CGPoint touchOne = [(UITouch*)[tArr objectAtIndex: 0] locationInView: self];
		CGPoint touchTwo = [(UITouch*)[tArr objectAtIndex: 1] locationInView: self];
		
		_startPinchDist = CGPoint2DDistanceBetween(touchOne, touchTwo);
		_startPinchMidPoint = CGPointMidPoint(touchOne, touchTwo);
	}*/
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray* tArr = [[event touchesForView: self] allObjects];
	UITouch* tapTapTouch =  [[event touchesForView: self] anyObject];
	
	if ([tArr count] == 2) {
		if (!_controller._boardIsZoomed) {
			//if (_startPinchDist && _startPinchMidPoint.x != MAXFLOAT && _startPinchMidPoint.y != MAXFLOAT) {
			CGPoint touchOne = [(UITouch*)[tArr objectAtIndex: 0] locationInView: self];
			CGPoint touchTwo = [(UITouch*)[tArr objectAtIndex: 1] locationInView: self];
			
			CGFloat scaling = (CGPoint2DDistanceBetween(touchOne, touchTwo) / 320) * 2.0;
			[_controller setZoomPoint:CGPointMidPoint(touchOne, touchTwo) withScalingFactor:scaling];
			//}
		}
		else {
			[_controller resetBoardZoom];
		}
	}
	else if ([tapTapTouch tapCount] == 2) {
		CGPoint zPoint = [tapTapTouch locationInView: self];
		[_controller setZoomPoint: zPoint withScalingFactor: 4.0];
	}
	
	_startPinchDist = 0.0;
	_startPinchMidPoint = CGPointMake(MAXFLOAT, MAXFLOAT);
	[_windowArr removeAllObjects];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// to slow right now...
	/*
	NSArray* tArr = [[event touchesForView: self] allObjects];
	
	if (tArr && [tArr count] == 2)
	{
		CGPoint touchOne = [(UITouch*)[tArr objectAtIndex: 0] locationInView: self];
		CGPoint touchTwo = [(UITouch*)[tArr objectAtIndex: 1] locationInView: self];
		
		CGFloat newDist = CGPoint2DDistanceBetween(touchOne, touchTwo);
		CGFloat distDiff = (_startPinchDist - newDist);
		
		_startPinchDist = newDist;
		
		newDist = [self _currentFloatingAverage];
		if (newDist == M_E || (newDist != MAXFLOAT && abs(distDiff) < abs((newDist * (1.5)))))
		{
			newDist = [self _floatingAverageWithNewest: distDiff];
	 
			if (newDist != M_E) {
				NSLog(@"Setting zoom point %@, scaling factor %0.5f", NSStringFromCGPoint(CGPointMidPoint(touchOne, touchTwo)), newDist);
				[_controller setZoomPoint: CGPointMidPoint(touchOne, touchTwo) withScalingFactor:newDist];
			}
		}
	}
	*/
}


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_windowArr = nil;
		_startPinchMidPoint = CGPointMake(MAXFLOAT, MAXFLOAT);
	}
	
	return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
}


- (void)dealloc {
	[_windowArr release];
	[super dealloc];
}


@end
