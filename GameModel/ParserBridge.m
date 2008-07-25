//
//  ParserBridge.m
//  ugo
//
//  Created by Ryan Joseph on 7/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ParserBridge.h"


@implementation ParserBridge
- (void) _clearSGFInfo;
{
	FreeSGFInfo(&_sgf);
	memset((void*)&_sgf, 0, sizeof(struct SGFInfo));
}

- (id) init;
{
	if ((self = [super init])) {
		[self _clearSGFInfo];
	}
	
	return self;
}


- (void) dealloc;
{
	[self _clearSGFInfo];
	[super dealloc];
}

- (void) _examinePropsForNode: (struct Node*)node;
{
	struct Property *pptr = node->prop;
	
	for (; pptr; pptr = pptr->next) {
		NSLog(@"Property: id %d (\"%s\")\t\tFlags: 0x%x", pptr->id, pptr->idstr, pptr->flags);
		
		struct PropValue *pv = pptr->value;
		
		for (; pv; pv = pv->next) {
			if (pv->buffer && pv->value) {
				NSLog(@"\t\tValue: %s", pv->value);
				
				if (pv->value2) NSLog(@"\t\tValue2: %s", pv->value2);
			}
		}
	}
}

- (void) _examineSGF;
{
	if (_sgf.name) {
		if (_sgf.info) {
		}
		
		if (_sgf.root) {
			NSLog(@"Following node chaing from root:");
			
			struct Node* n = _sgf.root;
			
			for (; n; n = n->next) {
				NSLog(@"Node 0x%x (<- 0x%x | 0x%x ->)", n, n->prev, n->next);
				[self _examinePropsForNode:n];
			}
		}
	}
}

- (void) loadSGFFromPath:(NSString*)path;
{
	NSFileManager* fMgr = [NSFileManager defaultManager];
	
	if ([fMgr fileExistsAtPath:path] && [fMgr isReadableFileAtPath:path]) {
		_sgf.name = (char*)[path cStringUsingEncoding:NSASCIIStringEncoding];
		LoadSGF(&_sgf);
		NSLog(@"root node is %x", _sgf.root);
		
		[self _examineSGF];
	}
}
@end
