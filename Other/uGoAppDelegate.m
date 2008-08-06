//
//  uGoAppDelegate.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "uGoAppDelegate.h"

#import "RootViewController.h"
#import "MainViewController.h"

#import "GoGameController.h"

@implementation uGoAppDelegate

@synthesize window;
@synthesize rootViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // kick the settings into action
    [uGoSettings sharedSettings];
	[application setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
    
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
    
    srand(time(NULL));
    
    _goGame = [[GoGameController alloc] initWithBoardView:rootViewController.mainViewController.boardView];
    [_goGame startGame];
}

- (void)dealloc {
	[rootViewController release];
	[window release];
    
    [_goGame release];
    
	[super dealloc];
}

@end
