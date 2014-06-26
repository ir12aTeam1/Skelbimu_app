//
//  ProfileSettingsTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 28/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "ProfileSettingsTableViewController.h"

@interface ProfileSettingsTableViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *preloader;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
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
    PFUser *user = [PFUser currentUser];
    if ([[Client get] logedIn]) {
        self.userNameLabel.text = user.username;
        self.phoneNumberTextField.text = user[@"phone"];
    } else {
        self.userNameLabel.text = @"Neprisijungęs vartotojas";
        self.phoneNumberTextField.text = @"";
    }
}

- (IBAction)facebookLoginButtonPressed:(id)sender {
    if ([[Client get] logedIn]) {
        [PFUser logOut];
        [self.facebookLoginButton setSelected:NO];
        [self reloadView];
        [self.tableView beginUpdates], [self.tableView endUpdates];
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
            [self.tableView beginUpdates], [self.tableView endUpdates];
        }];
    }
}

- (IBAction)saveAdditionalsButtonPressed:(id)sender {
    [[Client get] showPreloader];
    PFUser *user = [PFUser currentUser];
    [user setObject:[NSNumber numberWithBool:self.checkButton.selected] forKey:@"show_phone"];
    [user setObject:self.phoneNumberTextField.text forKey:@"phone"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[Client get] hidePreloader];
        [[Client get] showSimpleAlert:@"Duomenys išsaugoti"];
    }];
}

- (IBAction)checkButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
}

#pragma mark - TableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[Client get] logedIn] ? 200 : 0;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


@end
