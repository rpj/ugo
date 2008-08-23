//
//  MainViewController.h
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardView, MainViewControlBarController;

@interface MainViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView*					_boardScrollView;
	IBOutlet UILabel*						_statusLabel;
	IBOutlet MainViewControlBarController*	_barController;		
	
	BoardView*		_boardView;
    CGFloat         _boardScale;
}

@property(readonly) BoardView *boardView;

@end
