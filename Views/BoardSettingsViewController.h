//
//  BoardSettingsViewController.h
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardSettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UISegmentedControl*	_sizeSel;
    IBOutlet UIPickerView*          _picker;
    
    BOOL                            _isLoading;
}

- (IBAction) boardSizeChanged;

@end
