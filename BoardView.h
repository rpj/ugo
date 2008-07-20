//
//  BoardView.h
//  uGo
//
//  Created by Ryan Joseph on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardLayer.h"

#define kBoardSize 1280

@interface BoardView : UIView {
    BoardLayer*    _boardLayer;
}

@property (nonatomic, retain) BoardLayer* _boardLayer;

- (void) drawGridOfSize: (NSInteger)size;

@end
