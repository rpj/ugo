//
//  MainViewController.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (void) selectorChanged;
{
	NSInteger s = [_sizeSel selectedSegmentIndex];
	[_boardView drawGridOfSize: (s == 0 ? 9 : (s == 1 ? 13 : 19))];
}
- (void) viewDidLoad
{
    // XXX (fark): I want the first view of the board to be of the entire board. I can't figure out how to do that.
    _boardScrollView.minimumZoomScale = 0.25;
    _boardScrollView.maximumZoomScale = 1.0;
    _boardScrollView.scrollsToTop = NO;
    _boardScrollView.contentSize = CGSizeMake(kBoardSize, kBoardSize);
    _boardScrollView.delegate = self;
    _boardView = [[BoardView alloc] init];
    [_boardScrollView addSubview:_boardView];
	[self selectorChanged];
}

- (void)dealloc {
    [_boardView release];
	[super dealloc];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _boardView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    // my best guess is that we should be redrawing the board layer at this point, but I'm not exactly sure what we should be doing
    // there to get a full-res board.
}

- (IBAction) goButton: (id) sender;
{
}
@end
