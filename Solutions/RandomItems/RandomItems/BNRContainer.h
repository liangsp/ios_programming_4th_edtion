//
//  BNRContainer.h
//  RandomItems
//
//  Created by 梁世平 on 16/3/6.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRItem.h"

@interface BNRContainer : BNRItem
{
    NSMutableArray *_subItems;
    unsigned _totalValue;
    NSString *_subItemDescription;
}

- (unsigned)totalValue;
- (NSString *)subItemDescription;

- (void)addItem:(id)item;

@end
