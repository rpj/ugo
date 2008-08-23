//
//  MainViewControlBarController.m
//  uGo
//
//  Created by Ryan Joseph on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MainViewControlBarController.h"
#import "uGoSettings.h"
#import "GoTypes.h"

@implementation MainViewControlBarController

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
	NSLog(@"_fwdButtonPressed");
}

- (void) _gameModeChanged:(NSNotification*)notify;
{
	for (UIView* sview in _container.subviews) {
		[sview removeFromSuperview];
	}
	
	UIButton* tBut = nil;
	UILabel* tLabel = nil;
	CGRect frame = _container.frame;
	
	
	switch ([uGoSettings sharedSettings].gameMode) {
		case kGoGameModePlayback:
			_headerLabel.text = @"SGF Playback Mode";
			
#define BORDER_ADD	10
#define BUTTON_HEIGHT 40
#define BUTTON_ALPHA 0.75
			
			frame.origin.x += BORDER_ADD;
			frame.origin.y += BORDER_ADD;
			frame.size.width = (frame.size.width - (BORDER_ADD * 3)) / 2;
			frame.size.height = BUTTON_HEIGHT;
			
			tBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[_container addSubview:tBut];
			[tBut setTitle:@"Previous" forState:UIControlStateNormal];
			[tBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[tBut setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
			tBut.frame = frame;
			tBut.backgroundColor = [UIColor clearColor];
			tBut.enabled = NO;
			tBut.alpha = BUTTON_ALPHA;
			[tBut addTarget:self action:@selector(_backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			
			tBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[_container addSubview:tBut];
			frame.origin.x += frame.size.width + BORDER_ADD;
			tBut.frame = frame;
			tBut.alpha = BUTTON_ALPHA;
			tBut.backgroundColor = [UIColor clearColor];
			[tBut setTitle:@"Next" forState:UIControlStateNormal];
			[tBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[tBut setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
			[tBut addTarget:self action:@selector(_fwdButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			
			frame = _headerLabel.frame;
			frame.origin.y -= frame.size.height;
			tLabel = [[UILabel alloc] initWithFrame:frame];
			[_container addSubview:tLabel];
			tLabel.text = @"No SGF file loaded.";
			tLabel.font = [UIFont systemFontOfSize:12.0];
			tLabel.textColor = [UIColor whiteColor];
			tLabel.backgroundColor = [UIColor clearColor];
			tLabel.frame = frame;
			break;
			
		case kGoGameModeLocal:
			_headerLabel.text = @"Local Two-Player Mode";
			break;
			
		case kGoGameModeAI:
			_headerLabel.text = @"GnuGO AI Mode";
			break;
			
		default:
			break;
	}
}


- (void) viewDidLoad;
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_gameModeChanged:) name:kGameModeChangedNotification object:nil];
	_headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
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
