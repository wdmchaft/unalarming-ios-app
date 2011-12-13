//
//  UnalarmingAppViewController.h
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface UnalarmingAppViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton* alarmButton;

- (IBAction) setAlarm: (id) sender;
- (void) cancelPendingTimer;

@end
