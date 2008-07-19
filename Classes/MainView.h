//
//  MainView.h
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainViewController.h"

@interface MainView : UIView {
	IBOutlet MainViewController*	_controller;
	
	NSMutableArray*	_windowArr;
	CGFloat		_startPinchDist;
	CGPoint		_startPinchMidPoint;
}

@end
