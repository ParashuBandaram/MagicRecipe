//
//  AppDelegate.h
//  Magic_Recipe
//
//  Created by Manish Patil on 06/01/16.
//  Copyright (c) 2016 Magic Recipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (BOOL)isServerReachable;

@end

