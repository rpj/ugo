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
#import "GoMove.h"

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
	
	/* this tests building a parser bridge, ie: for tracking a newly-created game with SGF */
	ParserBridge* pbn = [[[ParserBridge alloc] init] autorelease];
	pbn.path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"new.sgf"];
	pbn.boardSize = 19;
	pbn.whiteName = @"Fark";
	pbn.blackName = @"Tweek";
	pbn.blackRank = @"1k";
	pbn.gameComment = @"Game, the first.";
	pbn.handicap = 4;
	pbn.gameDate = [NSDate date];
	pbn.nextMoveInMainTree = [GoMove createWithBoardPoint:CGPointMake(1, 1) isWhitesMove:NO];
	pbn.nextMoveInMainTree = [GoMove createWithBoardPoint:CGPointMake(19, 19) isWhitesMove:YES];
	pbn.nextMoveInMainTree = [GoMove createWithBoardPoint:CGPointMake(2, 2) isWhitesMove:NO];
	pbn.nextMoveInMainTree = [GoMove createWithBoardPoint:CGPointMake(18, 18) isWhitesMove:YES];
	[pbn _unitTest];
	/*
	[pb loadSGFFromPath: [[NSBundle mainBundle] pathForResource:@"SmallTest" ofType:@"sgf"]];
	NSLog(@"--------------------------------------------------");
	[pb loadSGFFromPath: [[NSBundle mainBundle] pathForResource:@"SmallTest2" ofType:@"sgf"]];
	NSLog(@"--------------------------------------------------");
	[pb loadSGFFromPath: [[NSBundle mainBundle] pathForResource:@"SmallTest3" ofType:@"sgf"]];
	 */
#endif
}


- (void)dealloc {
    [_markerController release];
	[rootViewController release];
	[window release];
	[super dealloc];
}

@end
