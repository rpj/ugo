//
//  FlipsideViewController.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "FlipsideViewController.h"
#import "RootViewController.h"

@implementation FlipsideViewController

@synthesize rootViewController = _rootViewController;

- (IBAction) selectorChanged
{
	NSInteger s = [_sizeSel selectedSegmentIndex];
	[[uGoSettings sharedSettings] setBoardSize:(s == 0 ? 9 : (s == 1 ? 13 : 19))];
}

- (IBAction) donePressed 
{
    [_rootViewController toggleView];
}

- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];		
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[uGoSettings sharedSettings] allThemes] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *allThemes = [[uGoSettings sharedSettings] allThemes];
    if (row >=0 && row < [allThemes count]) {
        return [allThemes objectAtIndex:row];
    }
    else {
        NSLog(@"Error: Picker row out of range: %d", row);
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *allThemes = [[uGoSettings sharedSettings] allThemes];
    if (row >=0 && row < [allThemes count]) {
        [[uGoSettings sharedSettings] setThemeName:[allThemes objectAtIndex:row]];
    }
    else {
        NSLog(@"Error: Picker selection out of range: %d", row);
    }
}

@end
