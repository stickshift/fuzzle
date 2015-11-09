//
//  AppDelegate.m
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()
{
    long _resignTime;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    long resignedTime = time(NULL) - _resignTime;
    if (resignedTime > 60)
    {
        [((UINavigationController*)self.window.rootViewController) popToRootViewControllerAnimated:NO];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    _resignTime = time(NULL);
}

@end
