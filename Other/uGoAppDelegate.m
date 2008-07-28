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

#if 1
	ParserBridge* pb = [[[ParserBridge alloc] init] autorelease];
	//[pb loadSGFFromPath: [[NSBundle mainBundle] pathForResource:@"ShukoOriginalMove" ofType:@"sgf"]];
	/*
	ParserBridge* pbn = [[[ParserBridge alloc] init] autorelease];
	pbn.path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"new.sgf"];
	pbn.boardSize = 19;
	pbn.addWhite = [NSArray arrayWithObjects: @"ab", @"cd", @"pq", @"df", nil];
	pbn.addBlack = [NSArray arrayWithObjects: @"cc", @"dd", @"ee", @"ff", @"gg", nil];
	pbn.whiteName = @"Fark";
	pbn.blackName = @"Tweek";
	pbn.blackRank = @"1k";
	pbn.gameComment = @"Game, the first.";
	pbn.handicap = 4;
	pbn.gameDate = [NSDate date];
	[pbn _unitTest];*/
	
	[pb loadSGFFromPath: [[NSBundle mainBundle] pathForResource:@"FromSensei" ofType:@"sgf"]];
#endif
}


- (void)dealloc {
    [_markerController release];
	[rootViewController release];
	[window release];
	[super dealloc];
}

@end
