//
//  BNRColorDescription.m
//  Colorboard
//
//  Created by 梁世平 on 16/7/3.
//  Copyright © 2016年 shiping liang. All rights reserved.
//

#import "BNRColorDescription.h"
#import <UIKit/UIKit.h>

@implementation BNRColorDescription

- (instancetype)init
{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        _name = @"Blue";
    }
    
    return self;
}

@end
