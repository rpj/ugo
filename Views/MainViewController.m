//
//  MainViewController.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewControlBarController.h"
#import "BoardView.h"

@implementation MainViewController

@synthesize boardView = _boardView;

- (void) _boardStatusUpdate:(id)notify;
{
	NSString* status = nil;
	
	if (notify && (status = [[notify userInfo] objectForKey:@"status"])) {
		[_statusLabel setText:status];
		
		[NSTimer scheduledTimerWithTimeInterval:5.0
										 target:self
									   selector:@selector(_boardStatusUpdate:)
									   userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"status"]
										repeats:NO];
	}
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	if ((self = [super initWithNibName:nibName bundle:nibBundle])) {
		_barController = [[MainViewControlBarController alloc] initWithNibName:@"MainViewControlBar" bundle:nil];
	}
	
	return self;
}

- (void) viewDidLoad
{
	if (_barController) {
		[self.view addSubview:_barController.view];
		_barController.view.frame = CGRectMake(0, 470 - _barController.view.frame.size.height,
											   _barController.view.frame.size.width, _barController.view.frame.size.height);
		[_barController.view setNeedsDisplay];
	}
	
    // XXX (fark): I want the first view of the board to be of the entire board. I can't figure out how to do that.
    _boardScrollView.minimumZoomScale = 1.0;
    _boardScrollView.maximumZoomScale = 3.0;
    _boardScrollView.alwaysBounceHorizontal = YES;
    _boardScrollView.alwaysBounceVertical = YES;
    _boardScrollView.scrollsToTop = NO;
    _boardScrollView.delegate = self;
    _boardView = [[BoardView alloc] init];
    _boardScale = 1.0;
    _boardScrollView.contentSize = CGSizeMake(_boardView.boardSize, _boardView.boardSize);
    [_boardScrollView addSubview:_boardView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_boardStatusUpdate:)
												 name:kGoBoardViewStatusUpdateNotification
											   object:nil];
}

- (void)dealloc {
    [_boardView release];
	[super dealloc];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // resize the board view back to what UIScrollView is expecting
    [UIView setAnimationsEnabled:NO];
    CGSize oldSize = _boardScrollView.contentSize;
    
    CGPoint oldCenter = _boardView.center;
    _boardView.frame = CGRectMake(0, 0, _boardView.boardSize, _boardView.boardSize);
    _boardView.center = oldCenter;
    _boardView.transform = CGAffineTransformMakeScale(_boardScale, _boardScale);
    _boardScrollView.contentSize = oldSize;
    [UIView setAnimationsEnabled:YES];
    return _boardView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    // I can't figure out how to turn off the animations. It makes this look bad when resizing
    [UIView setAnimationsEnabled:NO];
    
    _boardScale = scale;
    _boardView.transform = CGAffineTransformIdentity;
    CGFloat newSize = _boardView.boardSize * scale;
    _boardView.frame = CGRectMake(0, 0, newSize, newSize);
    
    NSLog(@"Zoomed. Frame: %@ (bounds: %@ center: %@), zoom: %0.2f, content size: %@ offset: %@", NSStringFromCGRect(_boardView.frame), NSStringFromCGRect(_boardView.bounds), NSStringFromCGPoint(_boardView.center), scale, NSStringFromCGSize(_boardScrollView.contentSize), NSStringFromCGPoint(_boardScrollView.contentOffset));
    _boardScrollView.contentSize = CGSizeMake(newSize, newSize);
    
    [UIView setAnimationsEnabled:YES];
}

@end
