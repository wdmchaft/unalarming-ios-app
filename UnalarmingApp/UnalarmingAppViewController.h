//
//  UnalarmingAppViewController.h
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface UnalarmingAppViewController : UIViewController {
    UIButton* alarmButton;
    UIDatePicker* picker;
}

@property (retain) IBOutlet UIButton* alarmButton;
@property (retain) UIDatePicker* picker;

- (IBAction) setAlarm: (id) sender;
- (void) showAlert;
- (void) triggerVibration;
- (void) finalizeAlarm;
- (void) cancelSelection;
- (void) cleanupPicker;

@end
