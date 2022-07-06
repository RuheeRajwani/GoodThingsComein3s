//
//  AppDelegate.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ParseClientConfiguration *configuration = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Config" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        configuration.applicationId = [dict objectForKey: @"APP_ID"];
        configuration.clientKey = [dict objectForKey: @"CLIENT_KEY"];
        
        configuration.server = @"https://parseapi.back4app.com/";
    }];
    [Parse initializeWithConfiguration:configuration];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

@end
