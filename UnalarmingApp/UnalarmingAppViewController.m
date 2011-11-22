//
//  UnalarmingAppViewController.m
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnalarmingAppViewController.h"

@implementation UnalarmingAppViewController

@synthesize alarmButton;

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

- (IBAction)setAlarm:(id)sender {
    NSLog(@"setAlarm clicked...");
    UIDatePicker* picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeCountDownTimer;
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = picker.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
    
    picker.frame = endFrame;
    
    // show picker - however I do that... 
    // temporarily make the interval 2 seconds, should be 
    // picker.countDownDuration
	[NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self 
                                   selector:@selector(triggerVibration)
                                   userInfo:nil 
                                    repeats:NO];    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only support portrait orientation
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
