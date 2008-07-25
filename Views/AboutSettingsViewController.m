//
//  AboutSettingsViewController.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "AboutSettingsViewController.h"


@implementation AboutSettingsViewController

- (void)viewDidLoad
{
    NSString *legalHTMLPath = [[NSBundle mainBundle] pathForResource:@"legal" ofType:@"html"];
    if (legalHTMLPath) {
        NSData *legalHTMLData = [NSData dataWithContentsOfFile:legalHTMLPath];
        [_webView loadData:legalHTMLData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:legalHTMLPath]];
    } else {
        NSLog(@"Could not find legal file");
    }
    _webView.scalesPageToFit = YES;
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    [_versionLabel setText:[NSString stringWithFormat:@"v%@", version]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

@end
