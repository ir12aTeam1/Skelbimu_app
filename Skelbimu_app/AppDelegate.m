//
//  AppDelegate.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 26/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"m2AzAzjqQWCrdGbTcWDM7hCRhITQKW234gtlk7Aq"
                  clientKey:@"TvwGLJ1s4ZQopQMvOMbGsZznQgtFLCCLZRNX99qT"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    [self setupGlobalPreloader];
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(kSAFE_ORANGE_COLOR)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:CUSTOM_FONT_HELVETICA size:24],
                                                          NSFontAttributeName,
                                                          [UIColor whiteColor],
                                                          NSForegroundColorAttributeName,
                                                          nil]];    
    return YES;
}
							
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

#pragma mark - Global

- (void)setupGlobalPreloader {
    UIView *preloaderView = [[UIView alloc] initWithFrame:self.window.frame];
    [preloaderView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setFrame:CGRectMake(preloaderView.center.x - (activity.frame.size.width / 2),
                                  preloaderView.center.y - (activity.frame.size.height / 2),
                                  activity.frame.size.width,
                                  activity.frame.size.height)];
    [activity startAnimating];
    [preloaderView addSubview:activity];
    preloaderView.tag = 12345;
    preloaderView.hidden = YES;
    [self.window addSubview:preloaderView];
}

@end
