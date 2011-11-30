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

// dmandel: I'd probably put these property definitions in the class continuation, too.
// I'm marking this as "assign" because the dialog/subview
// will be retaining it, so when I release that it'll be
// cleaned up then (I think)
@property (assign) UIDatePicker* picker;
@property (retain) UIView* selectionDialog;

- (IBAction) setAlarm: (id) sender;

@end
