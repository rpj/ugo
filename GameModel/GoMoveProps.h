//
//  GoMoveProps.h
//  uGo
//
//  Created by Jacob Farkas on 8/7/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const * kGoPropAddBlack;
extern NSString const * kGoPropAddEmpty;
extern NSString const * kGoPropAnnotation;
extern NSString const * kGoPropApplication;
extern NSString const * kGoPropArrow;
extern NSString const * kGoPropWhoAddsStones;
extern NSString const * kGoPropAddWhite;
extern NSString const * kGoPropBlack;
extern NSString const * kGoPropBlackTimeLeft;
extern NSString const * kGoPropBadMove;
extern NSString const * kGoPropBlackRank;
extern NSString const * kGoPropBlackTeam;
extern NSString const * kGoPropComment;
extern NSString const * kGoPropCharset;
extern NSString const * kGoPropCopyright;
extern NSString const * kGoPropCircle;
extern NSString const * kGoPropDimPoints;
extern NSString const * kGoPropEvenPosition;
extern NSString const * kGoPropDoubtful;
extern NSString const * kGoPropDate;
extern NSString const * kGoPropEvent;
extern NSString const * kGoPropFileformat;
extern NSString const * kGoPropFigure;
extern NSString const * kGoPropGoodForBlack;
extern NSString const * kGoPropGameComment;
extern NSString const * kGoPropGame;
extern NSString const * kGoPropGameName;
extern NSString const * kGoPropGoodForWhite;
extern NSString const * kGoPropHandicap;
extern NSString const * kGoPropHotspot;
extern NSString const * kGoPropInitialPosition;
extern NSString const * kGoPropInteresting;
extern NSString const * kGoPropInvertYAxis;
extern NSString const * kGoPropKomi;
extern NSString const * kGoPropKo;
extern NSString const * kGoPropLabel;
extern NSString const * kGoPropLine;
extern NSString const * kGoPropMark;
extern NSString const * kGoPropSetMoveNumber;
extern NSString const * kGoPropNodename;
extern NSString const * kGoPropOtStonesBlack;
extern NSString const * kGoPropOpening;
extern NSString const * kGoPropOvertime;
extern NSString const * kGoPropOtStonesWhite;
extern NSString const * kGoPropPlayerBlack;
extern NSString const * kGoPropPlace;
extern NSString const * kGoPropPlayerToPlay;
extern NSString const * kGoPropPrintMoveMode;
extern NSString const * kGoPropPlayerWhite;
extern NSString const * kGoPropResult;
extern NSString const * kGoPropRound;
extern NSString const * kGoPropRules;
extern NSString const * kGoPropMarkup;
extern NSString const * kGoPropSelected;
extern NSString const * kGoPropSource;
extern NSString const * kGoPropSquare;
extern NSString const * kGoPropStyle;
extern NSString const * kGoPropSetupType;
extern NSString const * kGoPropSize;
extern NSString const * kGoPropTerritoryBlack;
extern NSString const * kGoPropTesuji;
extern NSString const * kGoPropTimelimit;
extern NSString const * kGoPropTriangle;
extern NSString const * kGoPropTerritoryWhite;
extern NSString const * kGoPropUnclearPosition;
extern NSString const * kGoPropUser;
extern NSString const * kGoPropValue;
extern NSString const * kGoPropView;
extern NSString const * kGoPropWhite;
extern NSString const * kGoPropWhiteTimeLeft;
extern NSString const * kGoPropWhiteRank;
extern NSString const * kGoPropWhiteTeam;


@interface GoMoveProps : NSObject {
}
+ (NSDictionary*) sgfCodesToPropertyNames;
+ (NSDictionary*) propertyNamesToSGFCodes;
@end
