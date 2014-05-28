//
//  BillBoardTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 28/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "BillBoardTableViewController.h"

@interface BillBoardTableViewController () {
    BOOL isItem;
}
@property (nonatomic, strong) NSMutableArray *categoriesArray;
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
    [self.categoriesArray removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    [query whereKey:@"parent_category" equalTo:self.selectedCategory ? self.selectedCategory : @""];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            self.categoriesArray = [objects mutableCopy];
            [self.tableView reloadData];
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
    return self.categoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *category = [self.categoriesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = category[@"title"];
    cell.detailTextLabel.text = category.objectId;
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter

- (NSMutableArray *)categoriesArray {
    if (!_categoriesArray) {
        _categoriesArray = [[NSMutableArray alloc] init];
    }
    return _categoriesArray;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"drill_down"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BillBoardTableViewController *controller = [segue destinationViewController];
        PFObject *category = [self.categoriesArray objectAtIndex:indexPath.row];
        controller.selectedCategory = category.objectId;
    }
}

@end
