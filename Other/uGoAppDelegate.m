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

#import "ParserBridge.h"

@implementation uGoAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // kick the settings into action
    [uGoSettings sharedSettings];
	[application setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
    
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
    
    _markerController = [[MarkerController alloc] init];
    _markerController.boardView = rootViewController.mainViewController.boardView;
    
    srand(time(NULL));

#if 0
	ParserBridge* pb = [[[ParserBridge alloc] init] autorelease];
	[pb loadSGFFromPath: [[NSBundle mainBundle] pathForResource:@"ShukoOriginalMove" ofType:@"sgf"]];
	
	ParserBridge* pbn = [[[ParserBridge alloc] init] autorelease];
	pbn.path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"new.sgf"];
	pbn.boardSize = 19;
	pbn.whiteName = @"Fark";
	pbn.blackName = @"Tweek";
	pbn.handicap = 4;
	pbn.gameDate = [NSDate date];
	[pbn _unitTest];
#endif
}


- (void)dealloc {
    [_markerController release];
	[rootViewController release];
	[window release];
	[super dealloc];
}

@end
