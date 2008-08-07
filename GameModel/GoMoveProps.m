//
//  GoMoveProps.m
//  uGo
//
//  Created by Jacob Farkas on 8/7/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoMoveProps.h"

NSString const * kGoPropAddBlack = @"AddBlack";
NSString const * kGoPropAddEmpty = @"AddEmpty";
NSString const * kGoPropAnnotation = @"Annotation";
NSString const * kGoPropApplication = @"Application";
NSString const * kGoPropArrow = @"Arrow";
NSString const * kGoPropWhoAddsStones = @"WhoAddsStones";
NSString const * kGoPropAddWhite = @"AddWhite";
NSString const * kGoPropBlack = @"Black";
NSString const * kGoPropBlackTimeLeft = @"BlackTimeLeft";
NSString const * kGoPropBadMove = @"BadMove";
NSString const * kGoPropBlackRank = @"BlackRank";
NSString const * kGoPropBlackTeam = @"BlackTeam";
NSString const * kGoPropComment = @"Comment";
NSString const * kGoPropCharset = @"Charset";
NSString const * kGoPropCopyright = @"Copyright";
NSString const * kGoPropCircle = @"Circle";
NSString const * kGoPropDimPoints = @"DimPoints";
NSString const * kGoPropEvenPosition = @"EvenPosition";
NSString const * kGoPropDoubtful = @"Doubtful";
NSString const * kGoPropDate = @"Date";
NSString const * kGoPropEvent = @"Event";
NSString const * kGoPropFileformat = @"Fileformat";
NSString const * kGoPropFigure = @"Figure";
NSString const * kGoPropGoodForBlack = @"GoodForBlack";
NSString const * kGoPropGameComment = @"GameComment";
NSString const * kGoPropGame = @"Game";
NSString const * kGoPropGameName = @"GameName";
NSString const * kGoPropGoodForWhite = @"GoodForWhite";
NSString const * kGoPropHandicap = @"Handicap";
NSString const * kGoPropHotspot = @"Hotspot";
NSString const * kGoPropInitialPosition = @"InitialPosition";
NSString const * kGoPropInteresting = @"Interesting";
NSString const * kGoPropInvertYAxis = @"InvertYAxis";
NSString const * kGoPropKomi = @"Komi";
NSString const * kGoPropKo = @"Ko";
NSString const * kGoPropLabel = @"Label";
NSString const * kGoPropLine = @"Line";
NSString const * kGoPropMark = @"Mark";
NSString const * kGoPropSetMoveNumber = @"SetMoveNumber";
NSString const * kGoPropNodename = @"Nodename";
NSString const * kGoPropOtStonesBlack = @"OtStonesBlack";
NSString const * kGoPropOpening = @"Opening";
NSString const * kGoPropOvertime = @"Overtime";
NSString const * kGoPropOtStonesWhite = @"OtStonesWhite";
NSString const * kGoPropPlayerBlack = @"PlayerBlack";
NSString const * kGoPropPlace = @"Place";
NSString const * kGoPropPlayerToPlay = @"PlayerToPlay";
NSString const * kGoPropPrintMoveMode = @"PrintMoveMode";
NSString const * kGoPropPlayerWhite = @"PlayerWhite";
NSString const * kGoPropResult = @"Result";
NSString const * kGoPropRound = @"Round";
NSString const * kGoPropRules = @"Rules";
NSString const * kGoPropMarkup = @"Markup";
NSString const * kGoPropSelected = @"Selected";
NSString const * kGoPropSource = @"Source";
NSString const * kGoPropSquare = @"Square";
NSString const * kGoPropStyle = @"Style";
NSString const * kGoPropSetupType = @"SetupType";
NSString const * kGoPropSize = @"Size";
NSString const * kGoPropTerritoryBlack = @"TerritoryBlack";
NSString const * kGoPropTesuji = @"Tesuji";
NSString const * kGoPropTimelimit = @"Timelimit";
NSString const * kGoPropTriangle = @"Triangle";
NSString const * kGoPropTerritoryWhite = @"TerritoryWhite";
NSString const * kGoPropUnclearPosition = @"UnclearPosition";
NSString const * kGoPropUser = @"User";
NSString const * kGoPropValue = @"Value";
NSString const * kGoPropView = @"View";
NSString const * kGoPropWhite = @"White";
NSString const * kGoPropWhiteTimeLeft = @"WhiteTimeLeft";
NSString const * kGoPropWhiteRank = @"WhiteRank";
NSString const * kGoPropWhiteTeam = @"WhiteTeam";

@implementation GoMoveProps
static NSDictionary *sSGFCodesToPropertyNames = nil;
+ (NSDictionary*) sgfCodesToPropertyNames
{
    if (sSGFCodesToPropertyNames == nil) {
        sSGFCodesToPropertyNames = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    kGoPropAddBlack, @"AB",
                                    kGoPropAddEmpty, @"AE",
                                    kGoPropAnnotation, @"AN",
                                    kGoPropApplication, @"AP",
                                    kGoPropArrow, @"AR",
                                    kGoPropWhoAddsStones, @"AS",
                                    kGoPropAddWhite, @"AW",
                                    kGoPropBlack, @"B",
                                    kGoPropBlackTimeLeft, @"BL",
                                    kGoPropBadMove, @"BM",
                                    kGoPropBlackRank, @"BR",
                                    kGoPropBlackTeam, @"BT",
                                    kGoPropComment, @"C",
                                    kGoPropCharset, @"CA",
                                    kGoPropCopyright, @"CP",
                                    kGoPropCircle, @"CR",
                                    kGoPropDimPoints, @"DD",
                                    kGoPropEvenPosition, @"DM",
                                    kGoPropDoubtful, @"DO",
                                    kGoPropDate, @"DT",
                                    kGoPropEvent, @"EV",
                                    kGoPropFileformat, @"FF",
                                    kGoPropFigure, @"FG",
                                    kGoPropGoodForBlack, @"GB",
                                    kGoPropGameComment, @"GC", 
                                    kGoPropGame, @"GM", 
                                    kGoPropGameName, @"GN", 
                                    kGoPropGoodForWhite, @"GW", 
                                    kGoPropHandicap, @"HA", 
                                    kGoPropHotspot, @"HO", 
                                    kGoPropInitialPosition, @"IP",
                                    kGoPropInteresting, @"IT", 
                                    kGoPropInvertYAxis, @"IY", 
                                    kGoPropKomi, @"KM", 
                                    kGoPropKo, @"KO", 
                                    kGoPropLabel, @"LB", 
                                    kGoPropLine, @"LN", 
                                    kGoPropMark, @"MA", 
                                    kGoPropSetMoveNumber, @"MN",
                                    kGoPropNodename, @"N", 
                                    kGoPropOtStonesBlack, @"OB", 
                                    kGoPropOpening, @"ON", 
                                    kGoPropOvertime, @"OT", 
                                    kGoPropOtStonesWhite, @"OW", 
                                    kGoPropPlayerBlack, @"PB", 
                                    kGoPropPlace, @"PC", 
                                    kGoPropPlayerToPlay, @"PL", 
                                    kGoPropPrintMoveMode, @"PM",
                                    kGoPropPlayerWhite, @"PW",
                                    kGoPropResult, @"RE",
                                    kGoPropRound, @"RO",
                                    kGoPropRules, @"RU",
                                    kGoPropMarkup, @"SE",
                                    kGoPropSelected, @"SL",
                                    kGoPropSource, @"SO",
                                    kGoPropSquare, @"SQ",
                                    kGoPropStyle, @"ST",
                                    kGoPropSetupType, @"SU",
                                    kGoPropSize, @"SZ",
                                    kGoPropTerritoryBlack, @"TB",
                                    kGoPropTesuji, @"TE",
                                    kGoPropTimelimit, @"TM",
                                    kGoPropTriangle, @"TR",
                                    kGoPropTerritoryWhite, @"TW",
                                    kGoPropUnclearPosition, @"UC",
                                    kGoPropUser, @"US",
                                    kGoPropValue, @"V",
                                    kGoPropView, @"VW",
                                    kGoPropWhite, @"W",
                                    kGoPropWhiteTimeLeft, @"WL",
                                    kGoPropWhiteRank, @"WR",
                                    kGoPropWhiteTeam, @"WT",                                    
                                    nil];
    }
    return sSGFCodesToPropertyNames;
    
}

static NSDictionary *sPropertyNamesToSGFCodes = nil;
+ (NSDictionary*) propertyNamesToSGFCodes
{
    if (sPropertyNamesToSGFCodes == nil) {
        sPropertyNamesToSGFCodes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"AB", kGoPropAddBlack,
                                    @"AE", kGoPropAddEmpty,
                                    @"AN", kGoPropAnnotation,
                                    @"AP", kGoPropApplication,
                                    @"AR", kGoPropArrow,
                                    @"AS", kGoPropWhoAddsStones,
                                    @"AW", kGoPropAddWhite,
                                    @"B", kGoPropBlack,
                                    @"BL", kGoPropBlackTimeLeft,
                                    @"BM", kGoPropBadMove,
                                    @"BR", kGoPropBlackRank,
                                    @"BT", kGoPropBlackTeam,
                                    @"C", kGoPropComment,
                                    @"CA", kGoPropCharset,
                                    @"CP", kGoPropCopyright,
                                    @"CR", kGoPropCircle,
                                    @"DD", kGoPropDimPoints,
                                    @"DM", kGoPropEvenPosition,
                                    @"DO", kGoPropDoubtful,
                                    @"DT", kGoPropDate,
                                    @"EV", kGoPropEvent,
                                    @"FF", kGoPropFileformat,
                                    @"FG", kGoPropFigure,
                                    @"GB", kGoPropGoodForBlack,
                                    @"GC", kGoPropGameComment,
                                    @"GM", kGoPropGame,
                                    @"GN", kGoPropGameName,
                                    @"GW", kGoPropGoodForWhite,
                                    @"HA", kGoPropHandicap,
                                    @"HO", kGoPropHotspot,
                                    @"IP", kGoPropInitialPosition,
                                    @"IT", kGoPropInteresting,
                                    @"IY", kGoPropInvertYAxis,
                                    @"KM", kGoPropKomi,
                                    @"KO", kGoPropKo, 
                                    @"LB", kGoPropLabel,
                                    @"LN", kGoPropLine,
                                    @"MA", kGoPropMark,
                                    @"MN", kGoPropSetMoveNumber,
                                    @"N", kGoPropNodename,
                                    @"OB", kGoPropOtStonesBlack,
                                    @"ON", kGoPropOpening,
                                    @"OT", kGoPropOvertime,
                                    @"OW", kGoPropOtStonesWhite,
                                    @"PB", kGoPropPlayerBlack,
                                    @"PC", kGoPropPlace,
                                    @"PL", kGoPropPlayerToPlay,
                                    @"PM", kGoPropPrintMoveMode,
                                    @"PW", kGoPropPlayerWhite,
                                    @"RE", kGoPropResult,
                                    @"RO", kGoPropRound,
                                    @"RU", kGoPropRules,
                                    @"SE", kGoPropMarkup,
                                    @"SL", kGoPropSelected,
                                    @"SO", kGoPropSource,
                                    @"SQ", kGoPropSquare,
                                    @"ST", kGoPropStyle,
                                    @"SU", kGoPropSetupType,
                                    @"SZ", kGoPropSize,
                                    @"TB", kGoPropTerritoryBlack,
                                    @"TE", kGoPropTesuji,
                                    @"TM", kGoPropTimelimit,
                                    @"TR", kGoPropTriangle,
                                    @"TW", kGoPropTerritoryWhite,
                                    @"UC", kGoPropUnclearPosition,
                                    @"US", kGoPropUser,
                                    @"V", kGoPropValue,
                                    @"VW", kGoPropView,
                                    @"W", kGoPropWhite,
                                    @"WL", kGoPropWhiteTimeLeft,
                                    @"WR", kGoPropWhiteRank,
                                    @"WT", kGoPropWhiteTeam,                                    
                                    nil];
    }
    return sPropertyNamesToSGFCodes;
}
@end
