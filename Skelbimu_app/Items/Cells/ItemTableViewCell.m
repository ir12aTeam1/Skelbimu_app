//
//  ItemTableViewCell.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 29/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self.containerView.layer setCornerRadius:3.0f];
    [self.containerView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.containerView.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.containerView.layer setShadowOpacity:0.35];
    [self.containerView.layer setShadowRadius:1];
    
    [self.itemImageView.layer setCornerRadius:3.0f];
    [self.priceContainerView.layer setCornerRadius:3.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
