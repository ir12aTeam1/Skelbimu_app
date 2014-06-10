//
//  AddItemTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 10/06/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "AddItemTableViewController.h"
#import "CategoryTableViewCell.h"
#import "UIImage+Tint.h"

@interface AddItemTableViewController ()
@property (nonatomic, strong) NSMutableArray *pfObjectsArray;
@end

@implementation AddItemTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"Pridėti skelbimą"];
    [[Client get] showPreloader];
    [self getListOfCategories];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationItem setTitle:@""];
}

- (void)getListOfCategories {
    [self.pfObjectsArray removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    [query whereKey:@"parent_category" equalTo:self.selectedCategoryObject ? self.selectedCategoryObject.objectId : @""];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.pfObjectsArray = [objects mutableCopy];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [[Client get] hidePreloader];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pfObjectsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Category";
    PFObject *category = [self.pfObjectsArray objectAtIndex:indexPath.row];
    CategoryTableViewCell *cell = (CategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = category[@"title"];
    PFFile *iconFile = category[@"icon"];
    [iconFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            cell.categoryImageView.image = [[UIImage imageWithData:data] imageWithTintColor:[UIColor lightGrayColor]];
        }
    }];
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter

- (NSMutableArray *)pfObjectsArray {
    if (!_pfObjectsArray) {
        _pfObjectsArray = [[NSMutableArray alloc] init];
    }
    return _pfObjectsArray;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"drill_down"]) {
        AddItemTableViewController *controller = [segue destinationViewController];
        controller.selectedCategoryObject = [self.pfObjectsArray objectAtIndex:indexPath.row];
    }
//    if ([segue.identifier isEqualToString:@"item_details"]) {
//        ItemDetailsTableViewController *controller = [segue destinationViewController];
//        controller.selectedItemObject = [self.pfObjectsArray objectAtIndex:indexPath.row];
//    }
}

@end
