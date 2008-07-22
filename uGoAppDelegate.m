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
#import "MarkerController.h"
#import "BoardView.h"

@implementation uGoAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // kick the settings into action
    [uGoSettings sharedSettings];
    
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
    
    _markerController = [[MarkerController alloc] init];
    _markerController.boardView = rootViewController.mainViewController.boardView;
}


- (void)dealloc {
    [_markerController release];
	[rootViewController release];
	[window release];
	[super dealloc];
}

@end
