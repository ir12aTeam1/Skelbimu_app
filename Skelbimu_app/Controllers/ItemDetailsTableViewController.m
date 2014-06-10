//
//  ItemDetailsTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 30/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "ItemDetailsTableViewController.h"
#import "ACEExpandableTextCell.h"
#import <MessageUI/MessageUI.h>
#import "UIImage+Tint.h"

@interface ItemDetailsTableViewController () <ACEExpandableTableViewDelegate, MFMessageComposeViewControllerDelegate> {
    CGFloat _cellHeight[1];
}
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (nonatomic, strong) PFObject *itemUser;

@end

@implementation ItemDetailsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Header
    [self.navigationItem setTitle:self.selectedItemObject[@"title"]];
    [self.locationLabel setText:self.selectedItemObject[@"city"]];
    [self.priceLabel setText:[NSString stringWithFormat:@"Kaina: %@ Lt", self.selectedItemObject[@"price"]]];
    [self.itemImageView.layer setCornerRadius:4.0f];
    [self.imageContainerView.layer setCornerRadius:4.0f];
    [self.imageContainerView.layer setBorderWidth:1];
    [self.imageContainerView.layer setBorderColor:UIColorFromRGB(kSAFE_ORANGE_COLOR).CGColor];
    PFFile *iconFile = self.selectedItemObject[@"image"];
    [iconFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            self.itemImageView.image = [UIImage imageWithData:data];
        }
    }];
    [self.locationImageView setImage:[self.locationImageView.image imageWithTintColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.8f]]];
    
    // Footer
    PFObject *usr = self.selectedItemObject[@"user"];
    //TODO: start preloader
    [usr fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.itemUser = object;
        self.phoneNumberLabel.text = [NSString stringWithFormat:@"Tel.: %@", self.itemUser[@"phone"]];
        //TODO: Stop preloader
    }];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Aprašymas:";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACEExpandableTextCell *cell = [tableView expandableTextCellWithId:@"Cell"];
    cell.text = self.selectedItemObject[@"description"];
    cell.userInteractionEnabled = NO;
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MAX(44.0, _cellHeight[indexPath.row]);
}

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath {
    _cellHeight[indexPath.row] = height;
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Actions

- (IBAction)callButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.itemUser[@"phone"]]]];
}

- (IBAction)messageButtonPressed:(id)sender {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Dėmesio!"
                                                               message:@"Jūsų įrenginys nepalaiko SMS"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[self.itemUser[@"phone"]];
    NSString *message = @"Skelbimų App: \n";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    //TODO: Show preloader
    [self presentViewController:messageController animated:YES completion:^{
        //TODO: Hide preloader
    }];
}

#pragma mark - MessageComposer Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    NSString *message = @"";
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Atsaukta");
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        case MessageComposeResultFailed:
            message = @"Kazkas nutiko";
            break;
        case MessageComposeResultSent:
            message = @"Žinutė sėkmingai išsiųsta";
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dėmesio!"
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }];
}

@end
