//
//  BitlyService.h
//  Bitly
//
//  Created by Dennis Blöte on 17.01.10.
//  Copyright 2010 //dennisbloete. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BitlyService : NSObject {
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

+ (id)serviceWithLogin:(NSString *)theLogin apiKey:(NSString *)theApiKey version:(NSString *)theVersion;
- (void)shortenURL:(NSString *)urlString;
- (void)expandURL:(NSString *)urlString;

@end

@protocol BitlyServiceDelegate
@optional
- (void)shortenedLongURL:(NSString *)longURL toShortURL:(NSString *)shortURL;
- (void)expandedShortURL:(NSString *)shortURL toLongURL:(NSString *)longURL;
@end