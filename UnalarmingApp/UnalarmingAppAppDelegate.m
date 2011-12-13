//
//  UnalarmingAppAppDelegate.m
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnalarmingAppAppDelegate.h"

#import "UnalarmingAppViewController.h"

@implementation UnalarmingAppAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [((UnalarmingAppViewController*)self.viewController) cancelPendingTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [((UnalarmingAppViewController*)self.viewController) cancelPendingTimer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [((UnalarmingAppViewController*)self.viewController) cancelPendingTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // App is active, but we have no clue cancelled timer should be reactivated. 
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [((UnalarmingAppViewController*)self.viewController) cancelPendingTimer];
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
