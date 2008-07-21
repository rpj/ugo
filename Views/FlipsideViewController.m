//
//  FlipsideViewController.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "FlipsideViewController.h"
#import "RootViewController.h"

@implementation FlipsideViewController

@synthesize rootViewController = _rootViewController;

- (IBAction) selectorChanged
{
	NSInteger s = [_sizeSel selectedSegmentIndex];
	[[uGoSettings sharedSettings] setBoardSize:(s == 0 ? 9 : (s == 1 ? 13 : 19))];
}

- (IBAction) donePressed 
{
    [_rootViewController toggleView];
}

- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];		
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

@end
