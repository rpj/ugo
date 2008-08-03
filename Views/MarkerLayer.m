//
//  MarkerLayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/21/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "MarkerLayer.h"
#import "MarkerTheme.h"

static NSString * const kMarkerTypeKey = @"MarkerType";
static NSString * const kMarkerOptionsKey = @"MarkerOptions";
static NSString * const kMarkerXPos = @"XPosition";
static NSString * const kMarkerYPos = @"YPosition";

@interface MarkerLayer (KnownStuff)
- (void)removeAllMarkers;
- (void)_redrawAllMarkers;
- (void) _resizeMarkerLayer:(CALayer *)markerLayer atLocation:(CGPoint)boardLocation;
@end

@implementation MarkerLayer

@synthesize theme = _theme;
@synthesize boardSize = _boardSize;

- (void) _gridSizeChanged:(NSNotification *)notif
{
    [self removeAllMarkers];
    [_allMarkers release];
    _boardSize = [[uGoSettings sharedSettings] boardSize];
    _allMarkers = [[NSMutableSet alloc] init];
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

- (void) removeAllMarkersAtLocation:(CGPoint)boardLocation
{
    CGFloat xpos = boardLocation.x;
    CGFloat ypos = boardLocation.y;
    NSMutableSet *layersToRemove = [[NSMutableSet alloc] init];
    for (CALayer *layer in _allMarkers) {
        CGFloat foundx = [[layer valueForKey:kMarkerXPos] floatValue];
        CGFloat foundy = [[layer valueForKey:kMarkerYPos] floatValue];
        if (foundx == xpos && foundy == ypos) [layersToRemove addObject:layer];
    }
    
    for (CALayer *layer in layersToRemove) {
        [layer removeFromSuperlayer];
        [_allMarkers removeObject:layer];
    }
    [layersToRemove release];
}

#define _stoneWiggle(x) ((((rand() % 21) - 10)/10.0) * (x))

- (void) _resizeMarkerLayer:(CALayer *)markerLayer
{
    NSAssert1([markerLayer valueForKey:kMarkerXPos], @"Could not get a x coordinate for the layer %@", markerLayer);
    NSAssert1([markerLayer valueForKey:kMarkerYPos], @"Could not get a y coordinate for the layer %@", markerLayer);
    CGFloat xpos = [[markerLayer valueForKey:kMarkerXPos] floatValue];
    CGFloat ypos = [[markerLayer valueForKey:kMarkerYPos] floatValue];
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
    NSNumber *xWiggle = [markerLayer valueForKey:@"xwiggle"];
    if (xWiggle) vpoint.x += [xWiggle doubleValue];
    vpoint.y = (boardLocation.y - 1) * lineSep;
    NSNumber *yWiggle = [markerLayer valueForKey:@"ywiggle"];
    if (yWiggle) vpoint.y += [yWiggle doubleValue];
    markerLayer.frame = CGRectMake(vpoint.x - stoneSize/2.0, vpoint.y - stoneSize/2.0, stoneSize, stoneSize);
    markerLayer.delegate = self;
}

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options
{
    CALayer *markerLayer = [CALayer layer];
    BOOL wiggleStone = YES;
    if ([options valueForKey:kGoMarkerAllowWiggle]) wiggleStone = [[options valueForKey:kGoMarkerAllowWiggle] boolValue];
    
    [markerLayer setValue:[NSNumber numberWithFloat:boardLocation.x] forKey:kMarkerXPos];
    [markerLayer setValue:[NSNumber numberWithFloat:boardLocation.y] forKey:kMarkerYPos];
    
    [_allMarkers addObject:markerLayer];
     
    if ([[options objectForKey:kGoMarkerOptionTemporaryMarker] boolValue] == YES) {
        markerLayer.opacity = 0.5;
    }
    
    CGFloat lineSep = self.frame.size.width / (_boardSize - 1);
    if (wiggleStone) {
        [markerLayer setValue:[NSNumber numberWithDouble:_stoneWiggle(lineSep * 0.03)] forKey:@"xwiggle"];
        [markerLayer setValue:[NSNumber numberWithDouble:_stoneWiggle(lineSep * 0.03)] forKey:@"ywiggle"];
    }
    
    if (options) [markerLayer setValue:options forKey:kMarkerOptionsKey];
    [markerLayer setValue:[NSNumber numberWithInt:type] forKey:kMarkerTypeKey];
    
    [self _resizeMarkerLayer:markerLayer];

    [self addSublayer:markerLayer];
    [markerLayer setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context;
{
    GoMarkerType type = [[layer valueForKey:kMarkerTypeKey] intValue];
    switch (type) {
        case kGoMarkerWhiteStone:
        case kGoMarkerBlackStone:
            [_theme drawStone:type inContext:context];
            break;
        case kGoMarkerShape:
            [_theme drawShape:[layer valueForKey:kMarkerOptionsKey] inContext:context];
            break;
        case kGoMarkerLabel:
            [_theme drawLabel:[layer valueForKey:kMarkerOptionsKey] inContext:context];
            break;
    }    
}

- (void)drawInContext:(CGContextRef)context
{
    [self _redrawAllMarkers];
}

- (void)_redrawAllMarkers
{
    for (CALayer *marker in _allMarkers) {
        if ((NSNull *)marker != [NSNull null]) {
            [self _resizeMarkerLayer:marker];
            [marker setNeedsDisplay];
        }
    }
}

- (void)removeAllMarkers
{
    for (CALayer *marker in _allMarkers) {
        if ((NSNull *)marker != [NSNull null]) [marker removeFromSuperlayer];
    }
    [_allMarkers removeAllObjects];
}

@end
