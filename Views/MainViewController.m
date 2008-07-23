//
//  MainViewController.m
//  uGo
//
//  Created by Ryan Joseph on 7/13/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainViewController.h"s
#import "BoardView.h"

@implementation MainViewController

@synthesize boardView = _boardView;

- (void) _drawReflectionImage:(NSNotification *)notif
{
    CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
    size_t sComponents = CGColorSpaceGetNumberOfComponents(deviceRGB);
    size_t width = _boardView.frame.size.width;
    size_t height = _boardView.frame.size.height;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = (width * bitsPerComponent * (sComponents + 1))/8;
    CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipLast;
    
    CGImageRef img = NULL;
    CGContextRef imageContext = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, deviceRGB, bitmapInfo);
    CGColorSpaceRelease(deviceRGB);
    if (imageContext) {
        [_boardView.layer renderInContext:imageContext];
        img = CGBitmapContextCreateImage(imageContext);
        CGContextRelease(imageContext);
    } else {
        NSLog(@"Could not create an image context for the reflection");
    }
    
	if (img) {
		UIImage* uiimg = [UIImage imageWithCGImage:(CGImageRef)img];
        
		if (uiimg) {
			[_reflectionView setImage:uiimg];
		}
        CGImageRelease(img);
	}
}

- (void) viewDidLoad
{
    // XXX (fark): I want the first view of the board to be of the entire board. I can't figure out how to do that.
    _boardScrollView.minimumZoomScale = 0.25;
    _boardScrollView.maximumZoomScale = 1.0;
    _boardScrollView.scrollsToTop = NO;
    _boardScrollView.contentSize = CGSizeMake(kBoardSize, kBoardSize);
    _boardScrollView.delegate = self;
	_boardScrollView.layer.masksToBounds = YES;
    _boardView = [[BoardView alloc] init];
    [_boardScrollView addSubview:_boardView];
    _reflectionView.frame = _boardView.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_drawReflectionImage:) name:kBoardChangedNotification object:nil];
	
	[self _drawReflectionImage:nil];
}

- (void) dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_boardView release];
	[super dealloc];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _boardView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    // my best guess is that we should be redrawing the board layer at this point, but I'm not exactly sure what we should be doing
    // there to get a full-res board.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // TODO: render _boardView into an image, flip it upside down, and stick it in a layer underneath the gradient
}
@end
