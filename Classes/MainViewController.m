//
//  MainViewController.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"

@implementation MainViewController

@synthesize _boardIsZoomed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
		_boardLayer = nil;
		_boardContainer = nil;
	}
	return self;
}


- (void) _zoomBoard: (CGFloat)amount;
{
	CGRect blOrig = _boardLayer.frame;
	_boardLayer.frame = CGRectMake(blOrig.origin.x+(amount/2), blOrig.origin.y+(amount/2), 
								   blOrig.size.width-amount, blOrig.size.height-amount);
	
	[_boardLayer setNeedsDisplay];
}


- (void) resetBoardZoom;
{
	_boardLayer.frame = _boardContainer.frame;
	[_boardLayer setNeedsDisplay];
	_boardIsZoomed = NO;
}


- (void) setZoomPoint: (CGPoint)zPoint withScalingFactor: (CGFloat)scale;
{
	if (!_boardIsZoomed) {
		NSLog(@"zoomPoint: %@", NSStringFromCGPoint(zPoint));
		
		if (CGRectContainsPoint(_boardLayer.frame, zPoint)) {
			CGFloat xtrans = (zPoint.x * scale) - (_boardLayer.frame.size.width / 2);
			CGFloat ytrans = (zPoint.y * scale) - (_boardLayer.frame.size.height / 2); 
			NSLog(@"xtrans: %0.2f, ytrans; %0.2f", xtrans, ytrans);
			
			NSLog(@"Original frame: %@", NSStringFromCGRect(_boardLayer.frame));
			NSLog(@"Original bound: %@", NSStringFromCGRect(_boardLayer.bounds));
			
			CGFloat dx = -_boardLayer.frame.size.width;
			CGFloat dy = -_boardLayer.frame.size.height;
			NSLog(@"dx: %0.2f\tdy: %0.2f", dx, dy);
			
			_boardLayer.frame = CGRectApplyAffineTransform(_boardLayer.frame, CGAffineTransformMakeScale(scale, scale));
			NSLog(@"scale: %@", NSStringFromCGRect(_boardLayer.frame));
			_boardLayer.frame = CGRectApplyAffineTransform(_boardLayer.frame, CGAffineTransformMakeTranslation(-xtrans, -ytrans));
			NSLog(@"translate: %@", NSStringFromCGRect(_boardLayer.frame));
			
			[_boardLayer setNeedsDisplay];
			_boardIsZoomed = YES;
		}
	}
}


- (void) selectorChanged;
{
	NSInteger s = [_sizeSel selectedSegmentIndex];
	[_boardLayer drawGridOfSize: (s == 0 ? 9 : (s == 1 ? 13 : 19))];
}


- (void) _initBoard;
{
	if (!_boardContainer && !_boardContainer)
	{
		_boardContainer = [[CALayer layer] retain];
		_boardLayer = [[BoardLayer layer] retain];
		
		_boardContainer.backgroundColor = _boardLayer.backgroundColor = [UIColor blackColor].CGColor;
		_boardContainer.frame = _boardLayer.frame = CGRectMake(0, 0, 320, 320);
		_boardContainer.delegate = self;
		_boardContainer.masksToBounds = YES;
		
		_boardIsZoomed = NO;
		
		[_boardContainer addSublayer: _boardLayer];
		[self.view.layer addSublayer: _boardContainer];
		
		[_boardLayer setNeedsDisplay];
		[_boardContainer setNeedsDisplay];
	}
}


- (void)viewDidLoad {
	self.view.multipleTouchEnabled = YES;
	[self _initBoard];
	[self selectorChanged];
 }


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


- (IBAction) goButton: (id) sender;
{
}
@end
