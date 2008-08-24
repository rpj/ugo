//
//  MainViewControlBarController.h
//  uGo
//
//  Created by Ryan Joseph on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoGameController, GoSGFPlayer;

@interface MainViewControlBarController : UIViewController {
	IBOutlet UIImageView *_bgImage;
	IBOutlet UILabel *_headerLabel;
	IBOutlet UIView *_container;
	
	GoGameController *_game;
	
	GoSGFPlayer *_sgfPlayer;
}

@property (nonatomic, assign) GoGameController* gameController;

@end
