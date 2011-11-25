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
    UIButton* _alarmButton;
    UIView* _selectionDialog;
    UIDatePicker* _picker;
}

@property (nonatomic, retain) IBOutlet UIButton* alarmButton;
// I'm marking this as "assign" because the dialog/subview 
// will be retaining it, so when I release that it'll be 
// cleaned up then (I think)
@property (assign) UIDatePicker* picker;
@property (retain) UIView* selectionDialog;

- (UIView*) buildSelectionDialogView;
- (IBAction) setAlarm: (id) sender;
- (void) showAlert;
- (void) triggerVibration;

@end
