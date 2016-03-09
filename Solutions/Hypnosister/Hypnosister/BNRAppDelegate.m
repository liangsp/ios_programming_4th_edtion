//
//  BNRAppDelegate.m
//  Hypnosister
//
//  Created by 梁世平 on 16/3/6.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRAppDelegate.h"
#import "BNRHypnosisView.h"
#include "BNRViewController.h"

@interface BNRAppDelegate () <UIScrollViewDelegate>

@property (nonatomic, strong) BNRHypnosisView *hyposis;

@end

@implementation BNRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Generic way to make root view controller;
    BNRViewController *pvc = [[BNRViewController alloc]init];
    self.window.rootViewController = pvc;
    
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    bigRect.size.height *= 2.0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    [scrollView setPagingEnabled:NO];
    [pvc.view addSubview:scrollView];
    
    
    BNRHypnosisView *hypnosisView = [[BNRHypnosisView alloc] initWithFrame:bigRect];
    self.hyposis = hypnosisView;
    [scrollView addSubview:self.hyposis];
    
    
    scrollView.contentSize = bigRect.size;
    
    //如果把firstView视图添加到window窗口，单点触控会没法响应
    //[self.window addSubview:firstView];
    //[self.window.rootViewController.view addSubview:hypnosisView];
    
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 2;
    scrollView.delegate = self;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

//捏合-缩放功能
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"viewForZoomingInScrollView works!!");
    return self.hyposis;
}

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
