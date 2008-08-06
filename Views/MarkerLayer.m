//
//  MarkerLayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/21/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "MarkerLayer.h"
#import "MarkerTheme.h"
#import "GoMarker.h"

#define _stoneWiggle(x) ((((rand() % 21) - 10)/10.0) * (x))
static NSString * const kMarkerXWiggleKey = @"XWiggle";
static NSString * const kMarkerYWiggleKey = @"YWiggle";

static NSString * const kGoMarkerKey = @"GoMarker";

@interface MarkerLayer (KnownStuff)
- (void)removeAllMarkers;
- (void)_redrawAllMarkers;
- (void)_resizeMarkerLayer:(CALayer *)markerLayer;
@end

@implementation MarkerLayer

@synthesize theme = _theme;
@synthesize boardSize = _boardSize;

- (void) _gridSizeChanged:(NSNotification *)notif
{
    [self removeAllMarkers];
    [_allMarkers release];
    _boardSize = [[uGoSettings sharedSettings] boardSize];
    _allMarkers = [[NSMutableArray alloc] initWithCapacity:(_boardSize * _boardSize)];
    for (int ii = 0; ii < (_boardSize * _boardSize); ii++) [_allMarkers addObject:[NSNull null]];
}

- (void) _themeChanged:(NSNotification *)notif
{
    self.theme = [[uGoSettings sharedSettings] markerTheme];
    [self _redrawAllMarkers];
}

- (id) init
{
    if ((self = [super init])) {
        [self removeAllAnimations];
        
        [self _gridSizeChanged:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_gridSizeChanged:) name:kBoardSizeChangedNotification object:nil];
        
        [self _themeChanged:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_themeChanged:) name:kMarkerThemeChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_allMarkers release];
    [_theme release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Layer Bookkeeping

- (void) _addMarkerLayer:(CALayer *)markerLayer forGoMarker:(GoMarker *)marker
{
    [markerLayer setValue:marker forKey:kGoMarkerKey];
    
    NSUInteger idx = boardPositionToIndex(marker.location, _boardSize);
    NSMutableArray *markers = [_allMarkers objectAtIndex:idx];
    if (markers == nil || (NSNull*)markers == [NSNull null]) {
        markers = [[[NSMutableArray alloc] init] autorelease];
        [_allMarkers replaceObjectAtIndex:idx withObject:markers];
    }
    
    // (fark): At this point, we may want to remove any layers that match. 
    //          However, I think it's best to leave that up to whoever is telling us to place the marker
    [markers addObject:markerLayer];
    [self addSublayer:markerLayer];
    [markerLayer setNeedsDisplay];
}

//- (CALayer *) _getMarkerLayerMatching:(GoMarker *)marker
//{
//    CALayer *foundLayer = nil;
//    NSUInteger idx = boardPositionToIndex(marker.location, _boardSize);
//    NSMutableArray *markers = [_allMarkers objectAtIndex:idx];
//    for (CALayer *layer in markers) {
//        GoMarker *curMarker = [layer valueForKey:kGoMarkerKey];
//        if ([curMarker isEqual:marker]) {
//            foundLayer = [[layer retain] autorelease];
//            break;
//        }
//    }
//    return foundLayer;
//}

- (void) removeMarker:(GoMarker *)marker
{
    CALayer *foundLayer = nil;
    NSUInteger idx = boardPositionToIndex(marker.location, _boardSize);
    NSMutableArray *markers = [_allMarkers objectAtIndex:idx];
    for (CALayer *layer in markers) {
        GoMarker *curMarker = [layer valueForKey:kGoMarkerKey];
        if ([curMarker isEqual:marker]) {
            foundLayer = layer;
            break;
        }
    }
    [foundLayer removeFromSuperlayer];
    [markers removeObject:foundLayer];
}

- (void) placeMarker:(GoMarker *)marker
{
    CALayer *markerLayer = [CALayerNonAnimating layer];
    [self _addMarkerLayer:markerLayer forGoMarker:marker];
    
    BOOL wiggleStone = marker.allowWiggle;
    
    if (marker.isTemporary) {
        markerLayer.opacity = 0.5;
    }
    
    CGFloat lineSep = self.frame.size.width / (_boardSize - 1);
    if (wiggleStone) {
        [markerLayer setValue:[NSNumber numberWithDouble:_stoneWiggle(lineSep * 0.03)] forKey:kMarkerXWiggleKey];
        [markerLayer setValue:[NSNumber numberWithDouble:_stoneWiggle(lineSep * 0.03)] forKey:kMarkerYWiggleKey];
    }
    
    [self _resizeMarkerLayer:markerLayer];
}

- (void)removeAllMarkers
{
    for (NSArray *array in _allMarkers) {
        for (CALayer *layer in array) {
            [layer removeFromSuperlayer];
        }
    }
    [_allMarkers removeAllObjects];
    for (int ii = 0; ii < (_boardSize * _boardSize); ii++) [_allMarkers addObject:[NSNull null]];
}

#pragma mark - 
#pragma mark Marker Drawing

- (void) _resizeMarkerLayer:(CALayer *)markerLayer
{
    GoMarker *marker = [markerLayer valueForKey:kGoMarkerKey];
    NSAssert1(marker, @"Layer does not have a marker. We don't know how to resize it. %@", markerLayer);
    CGFloat xpos = marker.location.x;
    CGFloat ypos = marker.location.y;
    CGPoint boardLocation = CGPointMake(xpos, ypos);
    CGFloat lineSep = self.frame.size.width / (_boardSize - 1);
    CGFloat stoneSize = lineSep * .95;
    
    CGPoint vpoint;
    // Perfect placement makes for a boring looking board. On a real board, the stones are slightly larger
    //  than the line width, forcing imperfect placement.
    // We should mix things up a bit. However, we need to make sure the stones don't overlap. 
    // For now, space between the stones and a small tolerance should be ok. 
    // In the future we can come up with something better.
    vpoint.x = (boardLocation.x - 1) * lineSep;
    NSNumber *xWiggle = [markerLayer valueForKey:kMarkerXWiggleKey];
    if (xWiggle && ![xWiggle isEqual:[NSNull null]]) vpoint.x += [xWiggle doubleValue];
    vpoint.y = (boardLocation.y - 1) * lineSep;
    NSNumber *yWiggle = [markerLayer valueForKey:kMarkerYWiggleKey];
    if (yWiggle && ![yWiggle isEqual:[NSNull null]]) vpoint.y += [yWiggle doubleValue];
    markerLayer.frame = CGRectMake(vpoint.x - stoneSize/2.0, vpoint.y - stoneSize/2.0, stoneSize, stoneSize);
    markerLayer.delegate = self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context;
{
    GoMarker *marker = [layer valueForKey:kGoMarkerKey];
    NSAssert(marker, @"Don't forget to bring a marker! Every layer should have a marker.");
    [_theme drawMarker:marker inContext:context];
}

- (void)drawInContext:(CGContextRef)context
{
    [self _redrawAllMarkers];
}

- (void)_redrawAllMarkers
{
    for (NSArray *markers in _allMarkers) {
        if ((NSNull *)markers == [NSNull null]) continue;
        for (CALayer *curMarker in markers) {
            if ((NSNull *)curMarker != [NSNull null]) {
                [self _resizeMarkerLayer:curMarker];
                [curMarker setNeedsDisplay];
            }
        }
    }
}

@end
