//
//  BNRColorDescription.h
//  Colorboard
//
//  Created by 梁世平 on 16/7/3.
//  Copyright © 2016年 shiping liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface BNRColorDescription : NSObject

@property (nonatomic) UIColor *color;
@property(nonatomic, copy) NSString *name;

@end
