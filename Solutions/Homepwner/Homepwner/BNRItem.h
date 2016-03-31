//
//  BNRItem.h
//  RandomItems
//
//  Created by 梁世平 on 16/3/6.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic, unsafe_unretained) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, readonly, strong) NSString *itemKey;

+ (instancetype)randomItem;

//BNRItem类指定初始化方法
- (instancetype)initWithItemName:(NSString *)name
                   valeInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString*)name;

@end
