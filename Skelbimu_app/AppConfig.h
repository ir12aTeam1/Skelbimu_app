//
//  AppConfig.h
//  Skelbimu_app
//
//  Created by Ruslanas Kudriavcevas on 28/05/14.
//  Copyright (c) 2014 Ruslanas Kudriavcevas. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kSAFE_GREEN_COLOR 0x00CC00
#define kSAFE_ORANGE_COLOR 0xF7861B

#define CUSTOM_FONT_HELVETICA @"HelveticaNeue-Thin"