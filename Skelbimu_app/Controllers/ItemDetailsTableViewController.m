//
//  ItemDetailsTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 30/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "ItemDetailsTableViewController.h"
#import "ACEExpandableTextCell.h"
#import "UIImage+Tint.h"

@interface ItemDetailsTableViewController () <ACEExpandableTableViewDelegate> {
    CGFloat _cellHeight[1];
}
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet ACEExpandableTextCell *expandableDescriptionCell;
@end

@implementation ItemDetailsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    _cellHeight[indexPath.row] = height;
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
//    [_cellData replaceObjectAtIndex:indexPath.section withObject:text];
}

@end
