//
//  BitlyViewController.m
//  Bitly
//
//  Created by Dennis Blöte on 17.01.10.
//  Copyright //dennisbloete 2010. All rights reserved.
//

#import "BitlyViewController.h"
#import "BitlyService.h"

NSString* const bitlyLogin = @"YOUR_LOGIN";
NSString* const bitlyApiKey = @"YOUR_API_KEY";
NSString* const bitlyVersion = @"2.0.1";

@implementation BitlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	BitlyService *bitlyService = [BitlyService serviceWithLogin:bitlyLogin apiKey:bitlyApiKey version:bitlyVersion];
	bitlyService.delegate = self;
	[bitlyService shortenURL:@"http://dennisbloete.de"];
	[bitlyService expandURL:@"http://bit.ly/1RmnUT"];
}

#pragma mark Bitly delegation

- (void)shortenedLongURL:(NSString *)longURL toShortURL:(NSString *)shortURL {
	NSLog(@"Shortened %@ to %@", longURL, shortURL);
}

- (void)expandedShortURL:(NSString *)shortURL toLongURL:(NSString *)longURL {
	NSLog(@"Expanded %@ to %@", shortURL, longURL);
}

@end
