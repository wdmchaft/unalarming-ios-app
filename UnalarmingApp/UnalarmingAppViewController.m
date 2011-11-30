//
//  UnalarmingAppViewController.m
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnalarmingAppViewController.h"

const NSUInteger NAV_BAR_HEIGHT = 40;

@interface UnalarmingAppViewController ()

- (UIView*) buildSelectionDialogView;
- (void) showAlert;
- (void) triggerVibration;

@end

@implementation UnalarmingAppViewController

@synthesize alarmButton = _alarmButton;
@synthesize picker = _picker;
@synthesize selectionDialog = _selectionDialog;

- (void)dealloc
{
    [_alarmButton release];
    [_selectionDialog release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void) showAlert {
	// Also issue visual alert
	UIAlertView *alert = [[[UIAlertView alloc]
                          initWithTitle:@"Meditation period over!"
                          message:nil
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] autorelease];
    [alert show];
}

- (void) triggerVibration {
    // Issue vibrate
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    [self showAlert];
}


- (void) finalizeAlarm {
    NSLog(@"finalizeAlarm was called!");
    NSLog(@"FINAL COUNTDOWN! %@", self.picker.countDownDuration);

    // I think I want to autorelease this because it'll be a leak otherwise
	[NSTimer scheduledTimerWithTimeInterval:self.picker.countDownDuration
                                     target:self
                                   selector:@selector(triggerVibration)
                                   userInfo:nil
                                    repeats:NO];
    NSLog(@"Remove the dialog view and release it");
    [self.selectionDialog removeFromSuperview];
    // Okay - so I thought I needed to release the dialog view, but when
    // I do - it causes a EXC_BAD_ACCESS, so I'm releasing something
    // that I guess isn't really *mine* ... gonna have to think on this.
    //[selectionDialog release];
}


- (void) cancelSelection {
    NSLog(@"cancelSelection was called - we'll do some clean-up soon");
    [self.selectionDialog removeFromSuperview];
    // see come in -(void)finalizeAlarm
    //[selectionDialog release];
}

- (UIView*)buildSelectionDialogView {
    self.picker = [[UIDatePicker alloc] init];
    self.picker.datePickerMode = UIDatePickerModeCountDownTimer;

    CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
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
    self.picker.frame = pickerRect;

    UINavigationBar* navBar = [[UINavigationBar alloc]
                               initWithFrame:CGRectMake(0.0,
                                                        0.0,
                                                        pickerSize.width,
                                                        NAV_BAR_HEIGHT)];
    navBar.barStyle = UIBarStyleBlack;
    [navBar pushNavigationItem:[[UINavigationItem alloc] init] animated:NO];

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

    [pickerView addSubview:self.picker];
    // so I think adding self.picker will up the retain count, but I have "assign"
    // on self.picker so the app isn't retaining it - but the subview is. Trying to
    // reason about my retain-counts here for practice.
    [pickerView addSubview:navBar];
    // the navBar is retained by pickerView, SWEET RELEASE!
    [navBar release];

    return pickerView;
}

- (IBAction)setAlarm:(id)sender {
    NSLog(@"setAlarm clicked...");

    self.selectionDialog = [self buildSelectionDialogView];

    [self.view.window addSubview:self.selectionDialog];

    // the selectionDialog view has the retain on child widgets now, SWEET RELEASE!
    [_picker release];
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
    self.picker = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only support portrait orientation
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
