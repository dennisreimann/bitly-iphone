//
//  BitlyController.m
//  Bitly
//
//  Created by Dennis Blöte on 17.01.10.
//  Copyright 2010 //dennisbloete. All rights reserved.
//

#import "BitlyController.h"
#import "Constants.h"
#import "CJSONDeserializer.h"


@interface BitlyController ()
@property(nonatomic,retain)NSMutableDictionary *connectionData;
- (void)startRequestWithURLString:(NSString *)urlString;
@end


@implementation BitlyController

@synthesize login;
@synthesize apiKey;
@synthesize version;
@synthesize delegate;
@synthesize connectionData;

+ (id)controllerWithLogin:(NSString *)theLogin apiKey:(NSString *)theApiKey version:(NSString *)theVersion {
	BitlyController *service = [[[[self class] alloc] init] autorelease];
	service.login = theLogin;
	service.apiKey = theApiKey;
	service.version = theVersion;
	return service;
}

- (void)dealloc {
    [login release], login = nil;
    [apiKey release], apiKey = nil;
    [version release], version = nil;
    [connectionData release], connectionData = nil;
    [super dealloc];
}

- (NSMutableDictionary *)connectionData {
	if (!connectionData) self.connectionData = [NSMutableDictionary dictionary]; 
	return connectionData;
}

- (void)startRequestWithURLString:(NSString *)urlString {
	NSURL *requestURL = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
	if (connection) {
		NSString *key = [NSString stringWithFormat:@"%d", [connection hash]];
		[self.connectionData setObject:[NSMutableData data] forKey:key];
	}
}

#pragma mark API methods

- (void)shortenURL:(NSString *)urlString {
	NSString *requestURLString = [NSString stringWithFormat:@"%@%@?version=%@&login=%@&apiKey=%@&longUrl=%@", BitlyApiBaseURL, @"shorten", version, login, apiKey, urlString];
	[self startRequestWithURLString:requestURLString];
}

- (void)expandURL:(NSString *)urlString {
	NSString *requestURLString = [NSString stringWithFormat:@"%@%@?version=%@&login=%@&apiKey=%@&shortUrl=%@", BitlyApiBaseURL, @"expand", version, login, apiKey, urlString];
	[self startRequestWithURLString:requestURLString];
}

#pragma mark NSURLConnection callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSString *key = [NSString stringWithFormat:@"%d", [connection hash]];
    NSMutableData *responseData = [self.connectionData objectForKey:key];
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString *key = [NSString stringWithFormat:@"%d", [connection hash]];
	NSMutableData *responseData = [self.connectionData objectForKey:key];
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *key = [NSString stringWithFormat:@"%d", [connection hash]];
	NSData *responseData = [self.connectionData objectForKey:key];
	NSDictionary *result = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:nil];
	NSDictionary *urlResult = [[[result objectForKey:@"results"] allValues] objectAtIndex:0];
	if ([urlResult objectForKey:@"errorCode"] && [urlResult objectForKey:@"errorMessage"]) {
		SEL selector = @selector(bitlyRequestForURL:didFailWithError:);
		if ([delegate respondsToSelector:selector]) {
			NSString *url = [[[result objectForKey:@"results"] allKeys] objectAtIndex:0];
			NSString *errorMessage = [urlResult objectForKey:@"errorMessage"];
			NSInteger errorCode = [[urlResult objectForKey:@"errorCode"] integerValue];
			NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorMessage, @"errorMessage", nil];
			NSError *error = [NSError errorWithDomain:@"BitlyErrorDomain" code:errorCode userInfo:userInfo];
			[delegate performSelector:selector withObject:url withObject:error];
		}
	} else if ([urlResult objectForKey:@"shortUrl"]) {
		SEL selector = @selector(bitlyShortenedLongURL:toShortURL:);
		if ([delegate respondsToSelector:selector]) {
			NSString *longURL = [[[result objectForKey:@"results"] allKeys] objectAtIndex:0];
			NSString *shortURL = [urlResult objectForKey:@"shortUrl"];
			[delegate performSelector:selector withObject:longURL withObject:shortURL];
		}
	} else if ([urlResult objectForKey:@"longUrl"]) {
		SEL selector = @selector(bitlyExpandedShortURL:toLongURL:);
		if ([delegate respondsToSelector:selector]) {
			NSString *hash = [[[result objectForKey:@"results"] allKeys] objectAtIndex:0];
			NSString *shortURL = [NSString stringWithFormat:@"http://bit.ly/%@", hash];
			NSString *longURL = [urlResult objectForKey:@"longUrl"];
			[delegate performSelector:selector withObject:shortURL withObject:longURL];
		}
	}
	[self.connectionData removeObjectForKey:key];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSString *key = [NSString stringWithFormat:@"%d", [connection hash]];
	[self.connectionData removeObjectForKey:key];
}

@end
