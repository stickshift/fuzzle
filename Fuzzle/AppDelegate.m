//
//  AppDelegate.m
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import "Flurry.h"
#import "AppDelegate.h"

@interface AppDelegate()
{
    long _resignTime;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"2PDNNDY8V2D6YPM7M47Q"];
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
