//
//  FlipsideViewController.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "FlipsideViewController.h"
#import "RootViewController.h"
#import "MarkerTheme.h"

@implementation FlipsideViewController

@synthesize rootViewController = _rootViewController;
@synthesize tabBarController = _tabBarController;

- (IBAction) donePressed 
{
    [_rootViewController toggleView];
}

- (void) viewDidLoad
{
    CGRect tabFrame = _tabBarController.view.frame;
    tabFrame.origin.y = _navBar.frame.origin.y + _navBar.frame.size.height;
    tabFrame.size.height -= _navBar.frame.size.height;
    _tabBarController.view.frame = tabFrame;
    [self.view addSubview:_tabBarController.view];
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

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    _navBarTitle.title = viewController.title;
}

@end
