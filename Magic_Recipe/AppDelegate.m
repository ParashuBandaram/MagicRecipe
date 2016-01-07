//
//  AppDelegate.m
//  Magic_Recipe
//
//  Created by Parshuram Bandaram on 06/01/16.
//  Copyright (c) 2016 Magic Recipe. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [AppDelegate isServerReachable];
    
    return YES;
}

+ (BOOL)isServerReachable {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"https://www.google.com"];
    
    reach.reachableOnWWAN = YES;
    
    [reach startNotifier];

//    return YES;
    if([reach isReachable])
        return YES;
    else
        return NO;
}

+ (void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //NSLog(@"%c", [reach isReachable]);
    }
    else
    {
        //NSLog(@"%c", [reach isReachable]);
    }
}

//+(BOOL)checkIfInternetIsAvailable
//{
//    BOOL reachable = NO;
//    NetworkStatus netStatus = [APP_DELEGATE1.internetReachability currentReachabilityStatus];
//    if(netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi)
//    {
//        reachable = YES;
//    }
//    else
//    {
//        reachable = NO;
//    }
//    return reachable;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
