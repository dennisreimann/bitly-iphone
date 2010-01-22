//
//  BitlyViewController.m
//  Bitly
//
//  Created by Dennis Blöte on 17.01.10.
//  Copyright //dennisbloete 2010. All rights reserved.
//

#import "BitlyViewController.h"
#import "Constants.h"


@interface BitlyViewController ()
- (void)resignFirstResponders;
@end


@implementation BitlyViewController

@synthesize bitlyController;
@synthesize longURLField;
@synthesize shortenedURLField;
@synthesize expandedURLField;

- (void)dealloc {
    [bitlyController release], bitlyController = nil;
    [longURLField release], longURLField = nil;
    [shortenedURLField release], shortenedURLField = nil;
    [expandedURLField release], expandedURLField = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    self.longURLField = nil;
    self.shortenedURLField = nil;
    self.expandedURLField = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.bitlyController = [BitlyController controllerWithLogin:BitlyLogin apiKey:BitlyApiKey version:BitlyVersion];
	self.bitlyController.delegate = self;
}

#pragma mark Actions

- (IBAction)shorten:(id)sender {
	[self resignFirstResponders];
	[bitlyController shortenURL:longURLField.text];
}

- (IBAction)expand:(id)sender {
	[self resignFirstResponders];
	[bitlyController expandURL:shortenedURLField.text];
}

#pragma mark Bitly delegation

- (void)bitlyShortenedLongURL:(NSString *)theLongURL toShortURL:(NSString *)theShortURL {
	NSLog(@"Shortened %@ to %@", theLongURL, theShortURL);
	shortenedURLField.text = theShortURL;
}

- (void)bitlyExpandedShortURL:(NSString *)theShortURL toLongURL:(NSString *)theLongURL {
	NSLog(@"Expanded %@ to %@", theShortURL, theLongURL);
	expandedURLField.text = theLongURL;
}

- (void)bitlyRequestForURL:(NSString *)theURL didFailWithError:(NSError *)theError {
	NSLog(@"Request for %@ failed with error: %@", theURL, theError);
	NSString *errorTitle = [NSString stringWithFormat:@"Bitly Error %d", theError.code];
	NSString *errorMessage = [theError.userInfo objectForKey:@"errorMessage"];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark Touches

- (void)resignFirstResponders {
	// Resign all first responders so the keyboard gets closed
	[longURLField resignFirstResponder];
	[shortenedURLField resignFirstResponder];
	[expandedURLField resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self resignFirstResponders];
}

@end
