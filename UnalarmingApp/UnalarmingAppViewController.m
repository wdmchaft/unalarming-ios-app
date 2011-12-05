//
//  UnalarmingAppViewController.m
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnalarmingAppViewController.h"

// dmandel: In general, unless you have a good reason not to, you should use NSInteger and NSUInteger for your integral types.
// [alg] FWIW, we do so much C++, that our standards aren't anal about it.
const int NAV_BAR_HEIGHT = 40;

@interface UnalarmingAppViewController ()

- (UIView*) allocSelectionDialogView;
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
    //
    // [alg] tapsquare code standards: Don't ever pass a string to the UI like
    // this, instead use the `NSLocalizedString` macro. e.g.,
    //
    //     ...
    //     initWithTitle:NSLocalizedString(@"Meditiation period over!", @"End of period message")
    //     ...
	UIAlertView *alert = [[[UIAlertView alloc]
                          initWithTitle:@"Meditation period over!"
                          message:nil
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] autorelease];
    [alert show];
}

- (void) triggerVibration {
    // Issue vibrate <-- [alg] tapsquare code standards: don't have silly comments
    // like this that just say what the code tells you. If you think this line
    // of code isn't self-explanatory, write an `issueVibrate` method to
    // encapsulate it. (Which is what this method is, so dang)
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    // the name of this method is not `triggerVibrationAndShowAlert`
    [self showAlert];
}


- (void) finalizeAlarm {
    NSLog(@"finalizeAlarm was called!");
    NSLog(@"FINAL COUNTDOWN! %@", self.picker.countDownDuration);

    // I think I want to autorelease this because it'll be a leak otherwise
    // [alg] It's autoreleased by definition, though I'd probably keep a retained 
    // reference to the timer around in an iVar anyway. If you needed to clean
    // up before the timer fired, how would you cancel it?
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

- (UIView*)allocSelectionDialogView {

    /*
     * This property has assign semantics, but I don't see you release or 
     * autorelease the instance you create here.
     */
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
    [navBar pushNavigationItem:[[[UINavigationItem alloc] init] autorelease] animated:NO];

    navBar.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                          target:self
                                          action:@selector(finalizeAlarm)] autorelease];
    navBar.topItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancelSelection)] autorelease];

    // dmandel: The fact that this method returns a view that has a +1 retain count is incorrect.  The cocoa convention is that
    // only things with a method name of “alloc”, “new”, “copy”, or “mutableCopy” http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmRules.html have a +1 retain count
    // anything else is presumed to be autoreleased so the caller will need to retain
    UIView* pickerView = [[UIView alloc] initWithFrame: viewRect];
    pickerView.backgroundColor = [UIColor redColor];

    [pickerView addSubview:self.picker];
    // so I think adding self.picker will up the retain count, but I have "assign"
    // on self.picker so the app isn't retaining it - but the subview is. Trying to
    // reason about my retain-counts here for practice.
    
    // [alg] Agreed — UIView always retains its subviews. You don't even have to keep
    // a reference to the picker. You could alternately set the picker's `tag` property
    // and get it whenever you need it like
    //
    // UIDatePicker *picker = [[UIDatePicker alloc] init];
    // picker.tag = PICKER_TAG;
    // ... configure picker ...
    //
    // [someOtherFuckingView addSubview:picker];
    // [picker release];
    //
    // UIDatePicker *picker = [someOtherFuckingView viewWithTag:PICKER_TAG]
    //
    //

    // dmandel: You have "assign" semantics on self.picker, but as I stated above it gets a +1 retain count on inception which is why it is sticking around.
    
    [pickerView addSubview:navBar];
    // the navBar is retained by pickerView, SWEET RELEASE!
    // dmandel: This is a good practice.  If you have local objects that you know are bound to a specific method, you absolutely want to do what you are doing here, and release after the object is living with its owner.  Otherwise you can pollute autorelease pools and get poor performance.  Probably wouldn't make a difference in this case, but it can kill you in a tight loop.
    [navBar release];

    return pickerView;
}

- (IBAction)setAlarm:(id)sender {
    // [alg] Clicked with what? Their finger? This is a serious tapsquare pet peeve.
    // TAPPED, MOTHERFUCKER. DO YOU SPEAK IT?
    NSLog(@"setAlarm clicked...");

    self.selectionDialog = [self allocSelectionDialogView];

    [self.view.window addSubview:self.selectionDialog];

    // the selectionDialog view has the retain on child widgets now, SWEET RELEASE!
    // [alg] a) Why are you bypassing the property here and using the iVar directly?
    // b) It's not immediately clear to me why you release this here. Surely
    // there's a cleaner way to localize memory management for this?
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
