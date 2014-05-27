//
//  ViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 26/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "ViewController.h"
#import "Client.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *preloader;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.loginButton setSelected:[[Client get] logedIn]];
}

- (void)loginButtonPressed:(id)sender {
    if ([PFUser currentUser]) {
        [[Client get] logout];
        [self.loginButton setSelected:NO];
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
            [self.loginButton setSelected:[PFUser currentUser]];
            [self.preloader setHidden:YES];
        }];
    }
}

@end
