/*
 *  GoMarker.h
 *  uGo
 *
 *  Created by Jacob Farkas on 7/22/08.
 *  Copyright 2008 Apple Computer. All rights reserved.
 *
 */

typedef enum {
    kGoMarkerWhiteStone,
    kGoMarkerBlackStone,
    kGoMarkerShape,
    kGoMarkerLabel
} GoMarkerType;

// NSNumber (BOOL) for whether to display the marker as temporary 
extern NSString * const kGoMarkerOptionTemporaryMarker;
// UIColor of the marker
extern NSString * const kGoMarkerOptionColor;
// NSString to use as the label for the marker 
extern NSString * const kGoMarkerOptionLabel;
// By default the stones are placed imperfectly. Pass NO to place perfectly grid-aligned
extern NSString * const kGoMarkerAllowWiggle;