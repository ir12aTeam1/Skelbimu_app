//
//  AddItemDetailsTableViewController.h
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 23/06/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKButton;

@interface AddItemDetailsTableViewController : UITableViewController

@property (nonatomic, strong) PFObject *selectedCategoryObject;
@property (nonatomic, strong) RKButton *selectedButton;

@end
