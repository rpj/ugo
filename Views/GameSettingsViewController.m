//
//  GameSettingsViewController.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GameSettingsViewController.h"
#import "uGoSettings.h"

@implementation GameSettingsViewController
- (void)viewDidLoad;
{
	NSLog(@"game mode %d", [uGoSettings sharedSettings].gameMode);
	[_picker selectRow:[uGoSettings sharedSettings].gameMode inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return kGoGameModeLastMode;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* ret = @"Invalid Mode";
	
	switch (row) {
		case kGoGameModeAI: ret = @"Versus an AI player"; break;
		case kGoGameModeLocal: ret = @"Two players locally"; break;
		case kGoGameModeBonjour: ret = @"Bonjour network"; break;
		case kGoGameModeInternet: ret = @"Internet"; break;
		case kGoGameModePlayback: ret = @"SGF file playback"; break;
		default: break;
	}
	
	return ret;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (row < kGoGameModeLastMode) [uGoSettings sharedSettings].gameMode = row;
}

@end
