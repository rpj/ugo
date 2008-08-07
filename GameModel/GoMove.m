//
//  GoMove.m
//  uGo
//
//  Created by Ryan Joseph on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GoMove.h"

///////////////////////////////////////////////////////////////////////////////
@implementation GoMove

@synthesize marker = _marker;
@synthesize moveNumber = _moveNumber;
@synthesize nextMove = _nextMove;
@synthesize variations = _variations;
@synthesize properties = _properties;

+ (GoMove*) moveFromParserNode:(struct Node*)node;
{
	return [[[GoMove alloc] initWithParserNode:node] autorelease];
}

- (id) initWithParserNode:(struct Node*)node;
{
	if ((self = [super init])) {
        _properties = [[NSMutableDictionary alloc] init];
        _variations = [[NSMutableArray alloc] init];
		
		void* prop = [ParserBridge _findFirstValueWithID:TKN_W startingWithProperty:node->prop];
		_isWhite = (prop != nil);
		
		if (!prop)
			prop = [ParserBridge _findFirstValueWithID:TKN_B startingWithProperty:node->prop];
		
		if (prop && [(id)prop isKindOfClass:[NSString class]]) {
			NSString *sProp = (NSString*)prop;
			
			if ([sProp length] == 2)
				_point = CGPointMake((CGFloat)([sProp characterAtIndex:0] - 'a'), (CGFloat)([sProp characterAtIndex:1] - 'a'));
		}
		
		if ((prop = [ParserBridge _findFirstValueWithID:TKN_C startingWithProperty:node->prop])) {
			_comment = [[NSString stringWithString:(NSString*)prop] copy];
		}
		
		if ((prop = [ParserBridge _findFirstValueWithID:TKN_MN startingWithProperty:node->prop])) {
			NSLog(@"Got a move number....");
		}
	}
	
	return self;
}

- (void) dealloc;
{
	[_marker release];
	[_properties release];
    [_nextMove release];
    [_variations release];
	
	[super dealloc];
}

//- (NSString*) description;
//{
//	return [NSString stringWithFormat: @"[0x%x] %s to (%@)%@", _node, _isWhite ? "White" : "Black", NSStringFromCGPoint(_point),
//			(_comment ? [NSString stringWithFormat:@" (C: \"%@\")", _comment] : @"")];
//}

- (NSString*) moveAsString;
{
	NSString* ret = nil;
	CGPoint loc = _marker.location;
    
    // won't this end up returning 'I' as a value?
	if (loc.x != -1 && loc.y != -1)
		ret = [NSString stringWithFormat:@"%c%c", ((char)loc.x + ('a'-1)), ((char)loc.y + ('a'-1))];
	
	return ret;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return [_properties objectForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [_properties setObject:value forKey:key];
}

#pragma mark -
#pragma mark Name Mapping Goop
static NSDictionary *sSGFCodesToPropertyNames = nil;
+ (NSDictionary*) sgfCodesToPropertyNames
{
    if (sSGFCodesToPropertyNames == nil) {
        sSGFCodesToPropertyNames = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"AddBlack", @"AB",
                                    @"AddEmpty", @"AE",
                                    @"Annotation", @"AN",
                                    @"Application", @"AP",
                                    @"Arrow", @"AR",
                                    @"WhoAddsStones", @"AS",
                                    @"AddWhite", @"AW",
                                    @"Black", @"B",
                                    @"BlackTimeLeft", @"BL",
                                    @"BadMove", @"BM",
                                    @"BlackRank", @"BR",
                                    @"BlackTeam", @"BT",
                                    @"Comment", @"C",
                                    @"Charset", @"CA",
                                    @"Copyright", @"CP",
                                    @"Circle", @"CR",
                                    @"DimPoints", @"DD",
                                    @"EvenPosition", @"DM",
                                    @"Doubtful", @"DO",
                                    @"Date", @"DT",
                                    @"Event", @"EV",
                                    @"Fileformat", @"FF",
                                    @"Figure", @"FG",
                                    @"GoodForBlack", @"GB",
                                    @"GameComment", @"GC", 
                                    @"Game", @"GM",        
                                    @"GameName", @"GN",     
                                    @"GoodForWhite", @"GW", 
                                    @"Handicap", @"HA", 
                                    @"Hotspot", @"HO", 
                                    @"InitialPosition", @"IP",
                                    @"Interesting", @"IT", 
                                    @"InvertYAxis", @"IY", 
                                    @"Komi", @"KM",  
                                    @"Ko", @"KO",    
                                    @"Label", @"LB", 
                                    @"Line", @"LN",     
                                    @"Mark", @"MA", 
                                    @"SetMoveNumber", @"MN",
                                    @"Nodename", @"N",  
                                    @"OtStonesBlack", @"OB", 
                                    @"Opening", @"ON", 
                                    @"Overtime", @"OT",      
                                    @"OtStonesWhite", @"OW", 
                                    @"PlayerBlack", @"PB", 
                                    @"Place", @"PC", 
                                    @"PlayerToPlay", @"PL", 
                                    @"PrintMoveMode", @"PM",
                                    @"PlayerWhite", @"PW",
                                    @"Result", @"RE",
                                    @"Round", @"RO",
                                    @"Rules", @"RU",
                                    @"Markup", @"SE",
                                    @"Selected", @"SL",
                                    @"Source", @"SO",
                                    @"Square", @"SQ",
                                    @"Style", @"ST",
                                    @"SetupType", @"SU",
                                    @"Size", @"SZ",
                                    @"TerritoryBlack", @"TB",
                                    @"Tesuji", @"TE",
                                    @"Timelimit", @"TM",
                                    @"Triangle", @"TR",
                                    @"TerritoryWhite", @"TW",
                                    @"UnclearPosition", @"UC",
                                    @"User", @"US",
                                    @"Value", @"V",
                                    @"View", @"VW",
                                    @"White", @"W",
                                    @"WhiteTimeLeft", @"WL",
                                    @"WhiteRank", @"WR",
                                    @"WhiteTeam", @"WT",
                                    nil];
    }
    return sSGFCodesToPropertyNames;
    
}

static NSDictionary *sPropertyNamesToSGFCodes = nil;
+ (NSDictionary*) propertyNamesToSGFCodes
{
    if (sPropertyNamesToSGFCodes == nil) {
        sPropertyNamesToSGFCodes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"AB", @"AddBlack",
                                    @"AE", @"AddEmpty",
                                    @"AN", @"Annotation",
                                    @"AP", @"Application",
                                    @"AR", @"Arrow",
                                    @"AS", @"WhoAddsStones",
                                    @"AW", @"AddWhite",
                                    @"B", @"Black",
                                    @"BL", @"BlackTimeLeft",
                                    @"BM", @"BadMove",
                                    @"BR", @"BlackRank",
                                    @"BT", @"BlackTeam",
                                    @"C", @"Comment",
                                    @"CA", @"Charset",
                                    @"CP", @"Copyright",
                                    @"CR", @"Circle",
                                    @"DD", @"DimPoints",
                                    @"DM", @"EvenPosition",
                                    @"DO", @"Doubtful",
                                    @"DT", @"Date",
                                    @"EV", @"Event",
                                    @"FF", @"Fileformat",
                                    @"FG", @"Figure",
                                    @"GB", @"GoodForBlack",
                                    @"GC", @"GameComment",
                                    @"GM", @"Game",     
                                    @"GN", @"GameName", 
                                    @"GW", @"GoodForWhite",
                                    @"HA", @"Handicap", 
                                    @"HO", @"Hotspot",  
                                    @"IP", @"InitialPosition",
                                    @"IT", @"Interesting",
                                    @"IY", @"InvertYAxis",
                                    @"KM", @"Komi",     
                                    @"KO", @"Ko",       
                                    @"LB", @"Label",    
                                    @"LN", @"Line",     
                                    @"MA", @"Mark",     
                                    @"MN", @"SetMoveNumber",
                                    @"N", @"Nodename",  
                                    @"OB", @"OtStonesBlack",
                                    @"ON", @"Opening",  
                                    @"OT", @"Overtime", 
                                    @"OW", @"OtStonesWhite",
                                    @"PB", @"PlayerBlack",
                                    @"PC", @"Place",     
                                    @"PL", @"PlayerToPlay",
                                    @"PM", @"PrintMoveMode",
                                    @"PW", @"PlayerWhite",
                                    @"RE", @"Result",
                                    @"RO", @"Round",
                                    @"RU", @"Rules",
                                    @"SE", @"Markup",
                                    @"SL", @"Selected",
                                    @"SO", @"Source",
                                    @"SQ", @"Square",
                                    @"ST", @"Style",
                                    @"SU", @"SetupType",
                                    @"SZ", @"Size",
                                    @"TB", @"TerritoryBlack",
                                    @"TE", @"Tesuji",
                                    @"TM", @"Timelimit",
                                    @"TR", @"Triangle",
                                    @"TW", @"TerritoryWhite",
                                    @"UC", @"UnclearPosition",
                                    @"US", @"User",
                                    @"V", @"Value",
                                    @"VW", @"View",
                                    @"W", @"White",
                                    @"WL", @"WhiteTimeLeft",
                                    @"WR", @"WhiteRank",
                                    @"WT", @"WhiteTeam",
                                    nil];
    }
    return sPropertyNamesToSGFCodes;
}

@end