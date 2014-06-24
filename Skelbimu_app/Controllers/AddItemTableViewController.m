//
//  AddItemTableViewController.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 10/06/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "AddItemTableViewController.h"
#import "AddItemDetailsTableViewController.h"
#import "CreateItemTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "UIImage+Tint.h"

@interface AddItemTableViewController () {
    BOOL isItem;
}
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
            isItem = !self.pfObjectsArray.count;
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
    if (isItem) return 1;
    return self.pfObjectsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isItem) return 140;
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Category";
    static NSString *cellIdentifier_create = @"Create";
    if (isItem) {
        CreateItemTableViewCell *cell = (CreateItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier_create
                                                                                                  forIndexPath:indexPath];
        
        [cell.proposeButton addTarget:self
                               action:@selector(proposeButtonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
        [cell.proposeButton setIndexPath:indexPath];
        [cell.proposeButton setRkSelection:RK_PROPOSE];
        
        [cell.lookingForButton addTarget:self
                                  action:@selector(lookingForButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
        [cell.lookingForButton setIndexPath:indexPath];
        [cell.lookingForButton setRkSelection:RK_LOOKINGFOR];
        
        return cell;
    } else {
        PFObject *category = [self.pfObjectsArray objectAtIndex:indexPath.row];
        CategoryTableViewCell *cell = (CategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                              forIndexPath:indexPath];
        cell.titleLabel.text = category[@"title"];
        PFFile *iconFile = category[@"icon"];
        [iconFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (data) {
                cell.categoryImageView.image = [[UIImage imageWithData:data] imageWithTintColor:[UIColor lightGrayColor]];
            }
        }];
        return cell;
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)proposeButtonPressed:(UIButton*)sender {
    [self performSegueWithIdentifier:@"Create_propose" sender:sender];
}

- (IBAction)lookingForButtonPressed:(UIButton*)sender {
    [self performSegueWithIdentifier:@"Create_lookingFor" sender:sender];
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
    if ([segue.identifier isEqualToString:@"Create_propose"]) {
        AddItemDetailsTableViewController *controller = [segue destinationViewController];
        controller.selectedCategoryObject = self.selectedCategoryObject;
        controller.selectedButton = sender;
    }
    if ([segue.identifier isEqualToString:@"Create_lookingFor"]) {
        AddItemDetailsTableViewController *controller = [segue destinationViewController];
        controller.selectedCategoryObject = self.selectedCategoryObject;
        controller.selectedButton = sender;
    }
}

@end
