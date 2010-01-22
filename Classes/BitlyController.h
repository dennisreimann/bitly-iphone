//
//  BitlyController.h
//  Bitly
//
//  Created by Dennis Blöte on 17.01.10.
//  Copyright 2010 //dennisbloete. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BitlyController : NSObject {
	id delegate;
	NSString *login;
	NSString *apiKey;
	NSString *version;
@private
	NSMutableDictionary *connectionData;
}

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)NSString *login;
@property(nonatomic,retain)NSString *apiKey;
@property(nonatomic,retain)NSString *version;

+ (id)controllerWithLogin:(NSString *)theLogin apiKey:(NSString *)theApiKey version:(NSString *)theVersion;
- (void)shortenURL:(NSString *)urlString;
- (void)expandURL:(NSString *)urlString;

@end

@protocol BitlyControllerDelegate
@optional
- (void)bitlyShortenedLongURL:(NSString *)theLongURL toShortURL:(NSString *)theShortURL;
- (void)bitlyExpandedShortURL:(NSString *)theShortURL toLongURL:(NSString *)theLongURL;
- (void)bitlyRequestForURL:(NSString *)theURL didFailWithError:(NSError *)theError;
@end