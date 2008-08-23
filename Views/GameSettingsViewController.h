//
//  GameSettingsViewController.h
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameSettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UIPickerView *_picker;
}

@end
