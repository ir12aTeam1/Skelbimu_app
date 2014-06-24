//
//  UIImage+Resize.m
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 23/06/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

+ (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size {
    UIImage *tempImage = nil;
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = size.width;
    thumbnailRect.size.height = size.height;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tempImage;
}

@end
