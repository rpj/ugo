//
//  BoardSettingsViewController.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "BoardSettingsViewController.h"


@implementation BoardSettingsViewController
- (void)viewWillAppear:(BOOL)animated
{
    _isLoading = YES;
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
    
	NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
	_sizeSel.selectedSegmentIndex = (boardSize == 9 ? 0 : (boardSize == 13 ? 1 : 2));
    
    _isLoading = NO;
}

- (IBAction) boardSizeChanged
{
    if (!_isLoading) {
        NSInteger s = [_sizeSel selectedSegmentIndex];
        [[uGoSettings sharedSettings] setBoardSize:(s == 0 ? 9 : (s == 1 ? 13 : 19))];
    }
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
