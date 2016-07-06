//
//  BNRItem.h
//  Homepwner
//
//  Created by 梁世平 on 16/7/2.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class UIImage;

@interface BNRItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (instancetype)randomItem;

//BNRItem类指定初始化方法
- (instancetype)initWithItemName:(NSString *)name
                   valeInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString*)name;

- (void)setThumbnailFromImage:(UIImage *)image;

- (NSString *)composeSerialNumber;
- (NSString *)composeItemName;
- (int)composeValueInDollars;

@end

NS_ASSUME_NONNULL_END

#import "BNRItem+CoreDataProperties.h"
