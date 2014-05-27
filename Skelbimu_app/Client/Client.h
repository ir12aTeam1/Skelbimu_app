//
//  Client.h
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 27/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Client : NSObject

#pragma mark - Singleton

+ (id) get;

#pragma mark - User

- (BOOL)logedIn;

// Galima naudoti ir tiesiai PFUser *user = [PFUser currentUser];
- (PFUser*)currentUser;

#pragma mark - Facebook

- (void)facebookLoginWithBlock:(PFUserResultBlock)block;
- (void)logout;


@end
