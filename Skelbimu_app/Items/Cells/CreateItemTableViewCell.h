//
//  CreateItemTableViewCell.h
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 23/06/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKButton.h"

@interface CreateItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RKButton *proposeButton;
@property (weak, nonatomic) IBOutlet RKButton *lookingForButton;
@end
