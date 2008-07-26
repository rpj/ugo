//
//  FlipsideViewController.h
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface FlipsideViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    RootViewController*             _rootViewController;
    
    IBOutlet UISegmentedControl*	_sizeSel;
    IBOutlet UIPickerView*          _picker;
    
    BOOL                            _isLoading;
}

@property (nonatomic,assign) RootViewController *rootViewController;

- (IBAction) selectorChanged;
- (IBAction) donePressed;

@end
