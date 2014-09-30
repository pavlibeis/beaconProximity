//
//  AppDelegate.m
//  beaconTest
//
//  Created by Pavlos Dimitriou on 9/25/14.
//  Copyright (c) 2014 Pavlos Dimitriou. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
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
    NSURL *url2 = [NSURL URLWithString:@"http://192.168.77.95/api/newdeveloper/lights/3/state"];
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request2 setHTTPBody:[@"{\"on\":false}" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request2 setHTTPMethod:@"PUT"];
    
    
    NSError *requestError2 = NULL;
    NSURLResponse *response2 = NULL;
    NSData *responseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&requestError2];
    
    NSString *responseString2 = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString2);
}

@end
