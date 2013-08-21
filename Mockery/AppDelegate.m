//
//  AppDelegate.m
//  Mockery
//
//  Created by Josh Holtz on 8/21/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "Mockery.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self startTheMockery];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)startTheMockery {
    [Mockery mockeryWithURL:@"http://mockery"];
    [Mockery get:@"/stuff" block:^MockeryResponse *(NSString *path, NSURLRequest *request, NSArray *routeParams) {
        NSString *responseString = @"Hey yo hey";
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        return [[MockeryResponse alloc] initWithStatus:200 data:data];
    }];
    
    [Mockery get:[NSRegularExpression regularExpressionWithPattern:@"^/stuff/(\\d+)/more/(\\d+)?" options:NSRegularExpressionCaseInsensitive error:nil] block:^MockeryResponse *(NSString *path, NSURLRequest *request, NSArray *routeParams) {
        NSLog(@"Route params - %@", routeParams);
        
        NSString *responseString = @"We found this regex";
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        return [[MockeryResponse alloc] initWithStatus:200 data:data];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
