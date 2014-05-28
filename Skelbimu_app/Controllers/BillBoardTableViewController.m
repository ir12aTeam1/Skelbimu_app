//
//  BillBoardTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 28/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "BillBoardTableViewController.h"
#import "CategoryTableViewCell.h"
#import "ItemTableViewCell.h"

@interface BillBoardTableViewController () {
    BOOL isItem;
}
@property (nonatomic, strong) NSMutableArray *pfObjectsArray;
@end

@implementation BillBoardTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[Client get] showPreloader];
    [self getListOfCategories];
}

- (void)getListOfCategories {
    [self.pfObjectsArray removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    [query whereKey:@"parent_category" equalTo:self.selectedCategoryObject ? self.selectedCategoryObject.objectId : @""];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            if (objects.count > 0) {
                isItem = NO;
                self.pfObjectsArray = [objects mutableCopy];
                [self.tableView reloadData];
            } else {
                isItem = YES;
                //Get items list
                PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
                [itemQuery whereKey:@"category" equalTo:self.selectedCategoryObject];
                [itemQuery orderByAscending:@"createdAt"];
                [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        self.pfObjectsArray = [objects mutableCopy];
                        [self.tableView reloadData];
                    } else {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            
        } else {
            // Log details of the failure
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
    if (isItem) {
        return 80;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier_cat = @"Category";
    static NSString *cellIdentifier_item = @"Item";
    PFObject *category = [self.pfObjectsArray objectAtIndex:indexPath.row];
    
    if (isItem) {
        ItemTableViewCell *cell = (ItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier_item forIndexPath:indexPath];
        cell.titleLabel.text = category[@"title"];
        return cell;
    } else {
        CategoryTableViewCell *cell = (CategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier_cat forIndexPath:indexPath];
        cell.titleLabel.text = category[@"title"];
        return cell;
    }
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"drill_down"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BillBoardTableViewController *controller = [segue destinationViewController];
        controller.selectedCategoryObject = [self.pfObjectsArray objectAtIndex:indexPath.row];
    }
}

@end
