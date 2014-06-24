//
//  RKButton.h
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 23/06/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RK_PROPOSE,
    RK_LOOKINGFOR
} RKSelection;

@interface RKButton : UIButton

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) RKSelection rkSelection;

@end
