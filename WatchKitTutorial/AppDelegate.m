//
//  AppDelegate.m
//  WatchKitTutorial
//
//  Created by Bowie Xu on 15/1/14.
//  Copyright (c) 2015年 CoconutIsland. All rights reserved.
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#define PICCOUNT 30
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply {
    
    if ([[userInfo objectForKey:@"request"] isEqualToString:@"PIC"]) {
        
        NSLog(@"containing app received message from watch");
        
        
        NSMutableArray* marray = [NSMutableArray arrayWithCapacity:PICCOUNT];
        for (int i=0; i<PICCOUNT; i++) {
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"glance-%d@2x.png", i+_picindex]];
            NSData* imagedata = UIImagePNGRepresentation(image);
            [marray addObject:imagedata];
        }
        
        _picindex += PICCOUNT;
        _picindex %= 360;
        
        NSData* imageData = [NSKeyedArchiver archivedDataWithRootObject:marray];
        
        //NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
        NSDictionary *response = [NSDictionary dictionaryWithObject:imageData forKey:@"PIC"];//@{@"response" : @"Watchkit"};
        
        reply(response);
    }
}


@end
