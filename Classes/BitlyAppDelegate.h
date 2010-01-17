//
//  BitlyAppDelegate.h
//  Bitly
//
//  Created by Dennis Blöte on 17.01.10.
//  Copyright //dennisbloete 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BitlyViewController;

@interface BitlyAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BitlyViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BitlyViewController *viewController;

@end

