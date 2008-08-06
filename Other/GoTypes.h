/*
 *  GoTypes.h
 *  uGo
 *
 *  Created by Jacob Farkas on 8/6/08.
 *  Copyright 2008 Apple Computer. All rights reserved.
 *
 */

typedef enum {
    kGoMoveAccepted,
    kGoMoveDeniedNotYourTurn,
    kGoMoveDeniedSuicide,
    kGoMoveDeniedKoRule,
    kGoMovePieceExists
} GoMoveResponse;

typedef enum {
    kGoGameStateNotStarted,
    kGoGameStateInProgress,
    kGoGameStateFinished
} GoGameState;

// (fark) this may not be the best way to separate the marker types. I'm open to suggestions
typedef enum {
    kGoMarkerStone = 1,
    kGoMarkerSquareShape,
    kGoMarkerTriangleShape,
    kGoMarkerCircleShape,
    kGoMarkerDotShape,
    kGoMarkerLabel
} GoMarkerType;