//
//  UILabel+Utils.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 30/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)

- (void) fitTo:(CGSize)size {
    CGSize csize = [self sizeThatFits:size];
    CGRect frm = self.frame;
    frm.size.width = csize.width;
    frm.size.height = csize.height;
    self.frame = frm;
}

- (void) fitHeight {
    @synchronized (self) {
        CGSize csize = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
        CGRect frm = self.frame;
        frm.size.height = csize.height;
        self.frame = frm;
    }
}

- (void) fitWidth {
    @synchronized (self) {
        CGSize csize = [self sizeThatFits: CGSizeMake(MAXFLOAT, self.frame.size.height)];
        CGRect frm = self.frame;
        frm.size.width = csize.width;
        self.frame = frm;
    }
}

@end
