//
//  UnalarmingAppAppDelegate.h
//  UnalarmingApp
//
//  Created by Andrew Lenards on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnalarmingAppViewController;

@interface UnalarmingAppAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UnalarmingAppViewController *viewController;

@end
