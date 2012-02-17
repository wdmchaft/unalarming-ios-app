//
//  UnalarmingAppViewController.m
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnalarmingAppViewController.h"

const CGFloat NAV_BAR_HEIGHT = 40.0f;
const NSInteger PICKER_TAG = 650;

@interface UnalarmingAppViewController ()

@property (retain) UIView* selectionDialog;
@property (retain) NSTimer* meditationTimer;

- (UIView*) allocSelectionDialogViewWithPicker: (UIDatePicker*)picker;
- (void) showAlert;
- (void) triggerVibrationAndShowAlert;

@end

@implementation UnalarmingAppViewController

@synthesize alarmButton = _alarmButton;
@synthesize selectionDialog = _selectionDialog;
@synthesize meditationTimer = _meditationTimer;

- (void)dealloc
{
    [_alarmButton release];
    [_selectionDialog release];
    [_meditationTimer release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void) cancelPendingTimer {
    if (YES == self.meditationTimer.isValid) {
        [self.meditationTimer invalidate];
    }
}

- (void) showAlert {
	UIAlertView *alert = [[[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Meditation period over!",
                                                          @"End of period message")
                          message:nil
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK", @"Confirmation"), nil] autorelease];
    [alert show];
}

- (void) triggerVibrationAndShowAlert {
    // Vibrates on iPhone, beeps on iPod Touch
	AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

    [self showAlert];
}


- (void) finalizeAlarm {
    NSLog(@"finalizeAlarm was called!");
    UIDatePicker* picker = (UIDatePicker *)[self.selectionDialog viewWithTag:PICKER_TAG];

	self.meditationTimer = [NSTimer scheduledTimerWithTimeInterval:picker.countDownDuration
                                     target:self
                                   selector:@selector(triggerVibrationAndShowAlert)
                                   userInfo:nil
                                    repeats:NO];

    NSLog(@"Remove the dialog view and release it");
    [self.selectionDialog removeFromSuperview];
}


- (void) cancelSelection {
    NSLog(@"cancelSelection was called - we'll do some clean-up soon");
    [self.selectionDialog removeFromSuperview];
}

- (UIView*)allocSelectionDialogViewWithPicker: (UIDatePicker *)picker {

    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];

    CGRect viewRect = CGRectMake(0.0,
                                 screenRect.origin.y + screenRect.size.height -
                                 (pickerSize.height + NAV_BAR_HEIGHT),
                                 pickerSize.width,
                                 pickerSize.height + NAV_BAR_HEIGHT);
    // compute the end frame
    CGRect pickerRect = CGRectMake(0.0,
                                   NAV_BAR_HEIGHT,
                                   pickerSize.width,
                                   pickerSize.height);
    picker.frame = pickerRect;

    UINavigationBar* navBar = [[UINavigationBar alloc]
                               initWithFrame:CGRectMake(0.0,
                                                        0.0,
                                                        pickerSize.width,
                                                        NAV_BAR_HEIGHT)];
    navBar.barStyle = UIBarStyleBlack;
    [navBar pushNavigationItem:[[[UINavigationItem alloc] init] autorelease] animated:NO];

    navBar.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                          target:self
                                          action:@selector(finalizeAlarm)] autorelease];
    navBar.topItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancelSelection)] autorelease];

    UIView* pickerView = [[UIView alloc] initWithFrame: viewRect];
    pickerView.backgroundColor = [UIColor redColor];

    [pickerView addSubview:picker];

    [pickerView addSubview:navBar];
    // the navBar is now retained by pickerView
    [navBar release];

    return pickerView;
}

- (IBAction)setAlarm:(id)sender {
    NSLog(@"setAlarm tapped..."); // Rule #1 - we *always* tap

    UIDatePicker* picker = [[UIDatePicker alloc] init];
    picker.tag = PICKER_TAG;
    picker.datePickerMode = UIDatePickerModeCountDownTimer;

    self.selectionDialog = [self allocSelectionDialogViewWithPicker:picker];

    [picker release];

    [self.view.window addSubview:self.selectionDialog];
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.alarmButton = nil;
    self.selectionDialog = nil;
    self.meditationTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only support portrait orientation
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
