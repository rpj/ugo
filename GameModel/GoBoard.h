//
//  GoBoard.h
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardView;

@interface GoBoard : NSObject {
    BoardView *_boardView;
}

// not good separation. this needs more thought.
@property (nonatomic, assign) BoardView *boardView;

@end
