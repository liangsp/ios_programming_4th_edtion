//
//  BNRImageStore.h
//  Homepwner
//
//  Created by 梁世平 on 16/3/19.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface BNRImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forkey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
