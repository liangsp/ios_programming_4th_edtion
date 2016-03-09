//
//  BNRItemStore.h
//  Homepwner
//
//  Created by 梁世平 on 16/3/8.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)shareStore;
- (BNRItem *)createItem;

@end
