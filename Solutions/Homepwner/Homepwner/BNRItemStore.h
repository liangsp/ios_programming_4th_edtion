//
//  BNRItemStore.h
//  Homepwner
//
//  Created by 梁世平 on 16/3/8.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;
@class NSManagedObject;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)shareStore;
- (BNRItem *)createItem;
- (void)removeItem: (BNRItem *)item;
- (void)moveItemAtIndex: (NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL)saveChanges;
- (NSArray *)allAssetTypes;
- (void)createAssetWithName:(NSString *)assetName;
- (void)removeAssetType:(NSManagedObject *)asset;

@end
