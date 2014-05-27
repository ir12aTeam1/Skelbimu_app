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

- (PFUser*)currentUser {
    return [PFUser currentUser];
}

#pragma mark - Facebook

- (void)facebookLoginWithBlock:(PFUserResultBlock)block {
    NSArray *permissions = @[@"user_about_me"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (block) {
            block (user, error);
        }
    }];
}

- (void)logout {
    [PFUser logOut];
}

@end
