//
//  UnalarmingAppViewController.m
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnalarmingAppViewController.h"

@implementation UnalarmingAppViewController

@synthesize alarmButton, picker;

- (void)dealloc
{
    [alarmButton release];
    
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
	UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Meditation period over!"
                          message:nil
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    [alert show];    
}

- (void) triggerVibration {
    // Issue vibrate
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self showAlert];
}

- (void) cleanupPicker {
    [picker release];
    [self.navigationItem.rightBarButtonItem release];
    [self.navigationItem.leftBarButtonItem release];
}

- (void) finalizeAlarm {
    NSLog(@"finalizeAlarm was called!");
    
    // temporarily make the interval 2 seconds, should be 
    // picker.countDownDuration
	[NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self 
                                   selector:@selector(triggerVibration)
                                   userInfo:nil 
                                    repeats:NO];
    [self cleanupPicker];
}

- (void) cancelSelection {
    NSLog(@"cancelSelection was called - we'll do some clean-up soon");
    [self cleanupPicker];
}

- (IBAction)setAlarm:(id)sender {
    NSLog(@"setAlarm clicked...");
    self.picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeCountDownTimer;

    if (nil == picker.superview) {
		[self.view.window addSubview: picker];
		
		// compute the start frame
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
		CGRect startRect = CGRectMake(0.0,
									  screenRect.origin.y + screenRect.size.height,
									  pickerSize.width, pickerSize.height);
		picker.frame = startRect;
		
		// compute the end frame
		CGRect pickerRect = CGRectMake(0.0,
									   screenRect.origin.y + screenRect.size.height - pickerSize.height,
									   pickerSize.width,
									   pickerSize.height);
        picker.frame = pickerRect;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finalizeAlarm)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelection)];
    }
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
    [self cleanupPicker];
    // Release any retained subviews of the main view.
    self.alarmButton = nil;
    self.picker = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only support portrait orientation
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
