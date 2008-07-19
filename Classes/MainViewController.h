//
//  MainViewController.h
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import "BoardLayer.h"

@interface MainViewController : UIViewController {
	IBOutlet UISegmentedControl*	_sizeSel;
	IBOutlet UIButton*				_goButton;
	
	CALayer*		_boardContainer;
	BoardLayer*		_boardLayer;
	BOOL			_boardIsZoomed;
}

@property (nonatomic) BOOL _boardIsZoomed;

- (void) _zoomBoard: (CGFloat)amount;
- (void) resetBoardZoom;
- (void) setZoomPoint: (CGPoint)zPoint withScalingFactor: (CGFloat)scale;

- (IBAction) selectorChanged;

- (IBAction) goButton: (id) sender;
@end
