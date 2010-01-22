//
//  BitlyViewController.h
//  Bitly
//
//  Created by Dennis Blöte on 17.01.10.
//  Copyright //dennisbloete 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitlyViewController.h"
#import "BitlyController.h"


@interface BitlyViewController : UIViewController <BitlyControllerDelegate> {
	BitlyController *bitlyController;
	UITextField *longURLField;
	UITextField *shortenedURLField;
	UITextField *expandedURLField;
}

@property(nonatomic,retain)BitlyController *bitlyController;
@property(nonatomic,retain)IBOutlet UITextField *longURLField;
@property(nonatomic,retain)IBOutlet UITextField *shortenedURLField;
@property(nonatomic,retain)IBOutlet UITextField *expandedURLField;

- (IBAction)shorten:(id)sender;
- (IBAction)expand:(id)sender;

@end

