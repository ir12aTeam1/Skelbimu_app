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

#pragma mark - Facebook

- (void)facebookLoginWithBlock:(PFUserResultBlock)block;

#pragma mark - Global

// Naudoti duomenu uzkrovimo/atnaujinimo atvejais
- (void)showPreloader;
- (void)hidePreloader;

@end
