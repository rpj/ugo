//
//  FlipsideViewController.h
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface FlipsideViewController : UIViewController <UITabBarControllerDelegate> {
    RootViewController*             _rootViewController;
    
    IBOutlet UITabBarController *   _tabBarController;
    IBOutlet UINavigationBar *      _navBar;
    IBOutlet UINavigationItem *     _navBarTitle;
}

@property (nonatomic,assign) RootViewController *rootViewController;
@property (nonatomic,assign) UITabBarController *tabBarController;

- (IBAction) donePressed;

@end
