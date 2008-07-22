//
//  RootViewController.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"

@implementation RootViewController

@synthesize infoButton = _infoButton;
@synthesize mainViewController = _mainViewController;
@synthesize flipsideViewController = _flipsideViewController;

- (void)viewDidLoad {
	
	MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = viewController;
	[viewController release];
	
	[self.view insertSubview:_mainViewController.view belowSubview:_infoButton];
}


- (void)loadFlipsideViewController {
	
	FlipsideViewController *viewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    viewController.rootViewController = self;
	self.flipsideViewController = viewController;
	[viewController release];
}


- (IBAction)toggleView 
{
	/*
	 This method is called when the info or Done button is pressed.
	 It flips the displayed view from the main view to the flipside view and vice-versa.
	 */
	if (_flipsideViewController == nil) {
		[self loadFlipsideViewController];
	}
	
	UIView *mainView = _mainViewController.view;
	UIView *flipsideView = _flipsideViewController.view;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	
	if ([mainView superview] != nil) {
		[_flipsideViewController viewWillAppear:YES];
		[_mainViewController viewWillDisappear:YES];
		[mainView removeFromSuperview];
        [_infoButton removeFromSuperview];
		[self.view addSubview:flipsideView];
		[_mainViewController viewDidDisappear:YES];
		[_flipsideViewController viewDidAppear:YES];

	} else {
		[_mainViewController viewWillAppear:YES];
		[_flipsideViewController viewWillDisappear:YES];
		[flipsideView removeFromSuperview];
		[self.view addSubview:mainView];
		[self.view insertSubview:_infoButton aboveSubview:_mainViewController.view];
		[_flipsideViewController viewDidDisappear:YES];
		[_mainViewController viewDidAppear:YES];
	}
	[UIView commitAnimations];
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
	[_infoButton release];
	[_mainViewController release];
	[_flipsideViewController release];
	[super dealloc];
}


@end
