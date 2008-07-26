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

- (IBAction) selectorChanged
{
    if (!_isLoading) {
        NSInteger s = [_sizeSel selectedSegmentIndex];
        [[uGoSettings sharedSettings] setBoardSize:(s == 0 ? 9 : (s == 1 ? 13 : 19))];
    }
}

- (IBAction) donePressed 
{
    [_rootViewController toggleView];
}

- (void)viewDidLoad {
    _isLoading = YES;
	NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];		
	_sizeSel.selectedSegmentIndex = (boardSize == 9 ? 0 : (boardSize == 13 ? 1 : 2));
    _isLoading = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    int themeIndex = 0;
    NSArray *allThemes = [[uGoSettings sharedSettings] allThemes];
    MarkerTheme *curTheme = [[uGoSettings sharedSettings] markerTheme];
    // pointer equality isn't the greatest, but it should work here
    for (MarkerTheme *theme in allThemes) {
        if (curTheme == theme) {
            break;
        }
        themeIndex++;
    }
    [_picker selectRow:themeIndex inComponent:0 animated:NO];
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
        MarkerTheme *theme = [allThemes objectAtIndex:row];
        return [theme name];
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
        [[uGoSettings sharedSettings] setMarkerTheme:[allThemes objectAtIndex:row]];
    }
    else {
        NSLog(@"Error: Picker selection out of range: %d", row);
    }
}
@end
