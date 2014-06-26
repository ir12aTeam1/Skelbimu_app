//
//  Client.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 27/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "Client.h"

@implementation Client

#pragma mark - Singleton

+ (id) get {
	static Client *inst;
	if (inst == nil) {
		inst = [[Client alloc] init];
	}
	return inst;
}

#pragma mark - User

- (BOOL)logedIn {
    return !![PFUser currentUser];
}

#pragma mark - Facebook

- (void)facebookLoginWithBlock:(PFUserResultBlock)block {
    NSArray *permissions = @[@"user_about_me"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (user) {
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userData = (NSDictionary *)result;
                    [[PFUser currentUser] setUsername:userData[@"name"]];
                    [[PFUser currentUser] setEmail:userData[@"email"]];
                    [[PFUser currentUser] saveEventually];
                    if (block) {
                        block (user, error);
                    }
                }
            }];
        }
    }];
}

#pragma mark - Alert

- (void)showSimpleAlert:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dėmesio!"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Global

- (UIWindow*)globalWindow {
    return [[[UIApplication sharedApplication] windows] objectAtIndex:0];
}

- (void)showPreloader {
    UIView *preloader = [[self globalWindow] viewWithTag:12345];
    [[self globalWindow] bringSubviewToFront:preloader];
    preloader.hidden = NO;
}

- (void)hidePreloader {
    UIView *preloader = [[self globalWindow] viewWithTag:12345];
    preloader.hidden = YES;
}

@end
