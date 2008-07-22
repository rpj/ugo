//
//  MainViewController.h
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class BoardView;

@interface MainViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView*          _boardScrollView;
	IBOutlet UIImageView*			_reflectionView;
	
	BoardView*		_boardView;
}

@property(readonly) BoardView *boardView;

@end
