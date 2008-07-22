//
//  MainViewController.h
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardView;

@interface MainViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView*          _boardScrollView;
	
	BoardView*		_boardView;
}

@property(readonly) BoardView *boardView;

@end
