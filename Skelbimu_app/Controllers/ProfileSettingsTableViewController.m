//
//  ProfileSettingsTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 28/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "ProfileSettingsTableViewController.h"

@interface ProfileSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *preloader;
@end

@implementation ProfileSettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.facebookLoginButton setSelected:[[Client get] logedIn]];
    [self reloadView];
}

- (void)reloadView {
    self.userNameLabel.text = [[Client get] logedIn] ? [[PFUser currentUser] username] : @"Neprisijungęs vartotojas";
}

- (IBAction)facebookLoginButtonPressed:(id)sender {
    if ([[Client get] logedIn]) {
        [PFUser logOut];
        [self.facebookLoginButton setSelected:NO];
        [self reloadView];
    } else {
        [self.preloader setHidden:NO];
        [[Client get] facebookLoginWithBlock:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                NSLog(@"User logged in through Facebook!");
            }
            [self.facebookLoginButton setSelected:[[Client get] logedIn]];
            [self.preloader setHidden:YES];
            [self reloadView];
        }];
    }
}


@end
