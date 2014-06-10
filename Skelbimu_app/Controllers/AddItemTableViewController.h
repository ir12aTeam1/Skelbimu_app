//
//  AddItemTableViewController.h
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 10/06/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemTableViewController : UITableViewController

@property (nonatomic, strong) PFObject *selectedCategoryObject;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end
