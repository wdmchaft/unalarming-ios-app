//
//  UnalarmingAppViewController.h
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

// dmandel: The iVars are implied by the property definitions/synthesize declarations.  I never include them when I'm using properties (which is all the time)
@interface UnalarmingAppViewController : UIViewController {
    UIButton* _alarmButton;
    UIView* _selectionDialog;
    UIDatePicker* _picker;
}

@property (nonatomic, retain) IBOutlet UIButton* alarmButton;

// dmandel: I'd probably put these iVars in the class continuation, too.

// I'm marking this as "assign" because the dialog/subview
// will be retaining it, so when I release that it'll be
// cleaned up then (I think)
@property (assign) UIDatePicker* picker;
@property (retain) UIView* selectionDialog;

// dmandel: This is really a private method.  It doesn't belong in the public header.
//- (UIView*) buildSelectionDialogView;

- (IBAction) setAlarm: (id) sender;

// dmandel: These are really private methods.  They don't belong in the public header.
//- (void) showAlert;
//- (void) triggerVibration;

@end
