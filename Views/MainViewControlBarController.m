//
//  MainViewControlBarController.m
//  uGo
//
//  Created by Ryan Joseph on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MainViewControlBarController.h"
#import "GoGameController.h"
#import "uGoSettings.h"
#import "GoTypes.h"

#import "GoReferee.h"
#import "GoSGFPlayer.h"

@implementation MainViewControlBarController

@synthesize gameController = _game;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

- (void) _backButtonPressed:(id)sender;
{
	NSLog(@"_backButtonPressed");
}

- (void) _fwdButtonPressed:(id)sender;
{
	// yeah, I'm thinking it's getting to be about time for a better architecture...
	static BOOL __gameStarted = NO;
	UIControl *prevButton = nil;
	
	for (UIView* view in _container.subviews) {
		if ([view isKindOfClass:[UIButton class]]) {
			NSString* title = [(UIButton*)view titleForState:UIControlStateNormal];
			
			if ([title isEqualToString:@"Previous"]) {
				prevButton = (UIControl*)view;
			}
			
			if ([title isEqualToString:@"Start Playback"]) {
				[_game.referee startGame];
				[(UIButton*)view setTitle:@"Next" forState:UIControlStateNormal];
				__gameStarted = YES;
				break;
			}
		}
	}
	
	if (__gameStarted) {
		[_sgfPlayer makeNextMove];
		
		if (prevButton)
			prevButton.enabled = YES;
	}
}

- (void) _startLocalGame;
{
	//_game.referee.whitePlayer = [GoLocalPlayer player];
	// shit, we need the board view here for local players...
}

#define BORDER_ADD	10
#define BUTTON_HEIGHT 40
#define BUTTON_ALPHA 0.75

- (UIButton*) _createButtonWithTitle:(NSString*)title andFrame:(CGRect)frame;
{
	UIButton* tBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	[tBut setTitle:title forState:UIControlStateNormal];
	[tBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[tBut setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
	tBut.frame = frame;
	tBut.backgroundColor = [UIColor clearColor];
	tBut.alpha = BUTTON_ALPHA;
	
	return tBut;
}

- (void) _drawGameSetupUI;
{
	CGRect frame = _container.frame;
	frame.origin.x += BORDER_ADD;
	frame.origin.y += BORDER_ADD;
	frame.size.width = (frame.size.width - (BORDER_ADD * 2));
	frame.size.height = BUTTON_HEIGHT;

	UIButton* start = [self _createButtonWithTitle:@"Start Game" andFrame:frame];
	[_container addSubview:start];
}

- (void) _drawSGFPlaybackUI;
{
	UIButton* tBut = nil;
	UILabel* tLabel = nil;
	CGRect frame = _container.frame;
	
	frame.origin.x += BORDER_ADD;
	frame.origin.y += BORDER_ADD;
	frame.size.width = (frame.size.width - (BORDER_ADD * 3)) / 2;
	frame.size.height = BUTTON_HEIGHT;
	
	tBut = [self _createButtonWithTitle:@"Previous" andFrame:frame];	//[UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_container addSubview:tBut];
	tBut.enabled = NO;
	[tBut addTarget:self action:@selector(_backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	frame.origin.x += frame.size.width + BORDER_ADD;
	tBut = [self _createButtonWithTitle:@"Start Playback" andFrame:frame];	//[UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_container addSubview:tBut];
	[tBut addTarget:self action:@selector(_fwdButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	frame = _headerLabel.frame;
	frame.origin.y -= frame.size.height;
	tLabel = [[UILabel alloc] initWithFrame:frame];
	[_container addSubview:tLabel];
	
	NSArray* sgfs = [NSBundle pathsForResourcesOfType:@"sgf" inDirectory:[[NSBundle mainBundle] bundlePath]];
	NSString* sgfPath = [sgfs objectAtIndex:(random() % [sgfs count])];
	tLabel.text = [NSString stringWithFormat:@"Loaded: %@", [sgfPath lastPathComponent]];
	
	_sgfPlayer = [[GoSGFPlayer playerWithSGFPath:sgfPath] retain];
	_game.referee.whitePlayer = _game.referee.blackPlayer = _sgfPlayer;
	
	tLabel.font = [UIFont systemFontOfSize:12.0];
	tLabel.textColor = [UIColor whiteColor];
	tLabel.backgroundColor = [UIColor clearColor];
	tLabel.frame = frame;
}

- (void) _gameModeChanged:(NSNotification*)notify;
{
	for (UIView* sview in _container.subviews) {
		[sview removeFromSuperview];
	}
	
	if (_sgfPlayer) {
		[_sgfPlayer release];
		_sgfPlayer = nil;
	}

	switch ([uGoSettings sharedSettings].gameMode) {
		case kGoGameModePlayback:
			_headerLabel.text = @"SGF Playback Mode";
			[self _drawSGFPlaybackUI];
			break;
			
		case kGoGameModeLocal:
			[self _drawGameSetupUI];
			_headerLabel.text = @"Local Two-Player Mode";
			break;
			
		case kGoGameModeAI:
			_headerLabel.text = @"GnuGo AI Mode";
			break;
			
		case kGoGameModeBonjour:
			_headerLabel.text = @"Bonjour Network Mode";
			break;
			
		case kGoGameModeInternet:
			_headerLabel.text = @"Internet Mode";
			break;
			
		default:
			break;
	}
}


- (void) viewDidLoad;
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(_gameModeChanged:) 
												 name:kGameModeChangedNotification 
											   object:nil];
	
	_headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
	_sgfPlayer = nil;
	[self _gameModeChanged:nil];
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
