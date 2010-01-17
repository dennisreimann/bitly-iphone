//
//  BitlyAppDelegate.m
//  Bitly
//
//  Created by Dennis Blöte on 17.01.10.
//  Copyright //dennisbloete 2010. All rights reserved.
//

#import "BitlyAppDelegate.h"
#import "BitlyViewController.h"

@implementation BitlyAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
