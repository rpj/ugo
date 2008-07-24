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

@interface MarkerLayer (KnownStuff)
- (void)removeAllMarkers;
@end

@implementation MarkerLayer

@synthesize theme = _theme;

- (void) _gridSizeChanged:(NSNotification *)notif
{
    [self removeAllMarkers];
    [_allMarkers release];
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
    _allMarkers = [[NSMutableArray alloc] initWithCapacity:boardSize * boardSize];
    for (int i = 0; i < boardSize * boardSize; i++) [_allMarkers addObject:[NSNull null]];
}

- (void) _themeChanged:(NSNotification *)notif
{
    self.theme = [[uGoSettings sharedSettings] markerTheme];
}

- (id) init
{
    if ((self = [super init])) {
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

- (void) removeMarkerAtLocation:(CGPoint)boardLocation
{
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
    NSUInteger idx = (boardLocation.x - 1) + ((boardLocation.y - 1) * boardSize);
    NSAssert4([_allMarkers count] > idx, @"Request to remove a marker at location (%dx%d) that is beyond the board size (%dx%d)", boardLocation.x, boardLocation.y, boardSize, boardSize);
    CALayer *markerLayer = [_allMarkers objectAtIndex:idx];
    if (markerLayer && (NSNull *)markerLayer != [NSNull null]) [markerLayer removeFromSuperlayer];
    [_allMarkers replaceObjectAtIndex:idx withObject:[NSNull null]];
}

#define _stoneWiggle(x) ((((rand() % 21) - 10)/10.0) * (x))

- (void) placeMarker:(GoMarkerType)type atLocation:(CGPoint)boardLocation options:(NSDictionary *)options
{    
    NSUInteger boardSize = [[uGoSettings sharedSettings] boardSize];
    CGFloat lineSep = self.frame.size.width / (boardSize - 1);
    CGFloat stoneSize = lineSep * .95;
    CALayer *markerLayer = [CALayer layer];
    BOOL wiggleStone = YES;
    if ([options valueForKey:kGoMarkerAllowWiggle]) wiggleStone = [[options valueForKey:kGoMarkerAllowWiggle] boolValue];
    
    NSUInteger idx = (boardLocation.x - 1) + ((boardLocation.y - 1) * boardSize);
    NSAssert4([_allMarkers count] > idx, @"Request to add a marker at location (%dx%d) that is beyond the board size (%dx%d)", boardLocation.x, boardLocation.y, boardSize, boardSize);    
    
    CALayer *existingLayer = [_allMarkers objectAtIndex:idx];
    if (existingLayer && (NSNull *)existingLayer != [NSNull null]) [existingLayer removeFromSuperlayer];
    [_allMarkers replaceObjectAtIndex:idx withObject:markerLayer];
     
    if ([[options objectForKey:kGoMarkerOptionTemporaryMarker] boolValue] == YES) {
        markerLayer.opacity = 0.5;
    }
    
    if (options) [markerLayer setValue:options forKey:kMarkerOptionsKey];
    [markerLayer setValue:[NSNumber numberWithInt:type] forKey:kMarkerTypeKey];
    
    CGPoint vpoint;
    // Perfect placement makes for a boring looking board. On a real board, the stones are slightly larger
    //  than the line width, forcing imperfect placement.
    // We should mix things up a bit. However, we need to make sure the stones don't overlap. 
    // For now, space between the stones and a small tolerance should be ok. 
    // In the future we can come up with something better.
    vpoint.x = (boardLocation.x - 1) * lineSep;
    if (wiggleStone) vpoint.x += _stoneWiggle(lineSep * 0.03);
    vpoint.y = (boardLocation.y - 1) * lineSep;
    if (wiggleStone) vpoint.y += _stoneWiggle(lineSep * 0.03);
    markerLayer.frame = CGRectMake(vpoint.x - stoneSize/2.0, vpoint.y - stoneSize/2.0, stoneSize, stoneSize);
    markerLayer.delegate = self;
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

- (void)removeAllMarkers
{
    for (CALayer *marker in _allMarkers) {
        if ((NSNull *)marker != [NSNull null]) [marker removeFromSuperlayer];
    }
}

@end
