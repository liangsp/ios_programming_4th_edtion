//
//  main.m
//  RandomItems
//
//  Created by 梁世平 on 16/3/6.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        for (int index = 0; index < 10; index++) {
            BNRItem *item = [BNRItem randomItem];
            [items addObject:item];
        }
        
        for (id item in items)
        {
            NSLog(@"%@", item);
        }
        
        NSLog(@"set items to nil...");
        items = nil;
        
#if defined(MY_TEST_BNRCONTAINER)
        // Preparation
        BNRContainer *smallContainer1 = [BNRContainer randomItem];
        BNRContainer *smallContainer2 = [BNRContainer randomItem];
        BNRContainer *smallContainer3 = [BNRContainer randomItem];
        BNRContainer *smallContainer4 = [BNRContainer randomItem];
        BNRContainer *bigContainer1 = [BNRContainer randomItem];
        BNRContainer *bigContainer2 = [BNRContainer randomItem];
        BNRContainer *hugeContainer = [BNRContainer randomItem];
        
        // Work
        for (int i = 0 ; i < 10 ; i++) {
            [smallContainer1 addItem:[BNRItem randomItem]];
            [smallContainer2 addItem:[BNRItem randomItem]];
            [smallContainer3 addItem:[BNRItem randomItem]];
            [smallContainer4 addItem:[BNRItem randomItem]];
        }
        [bigContainer1 addItem:smallContainer1];
        [bigContainer1 addItem:smallContainer2];
        [bigContainer2 addItem:smallContainer3];
        [bigContainer2 addItem:smallContainer4];
        
        [hugeContainer addItem:bigContainer1];
        [hugeContainer addItem:bigContainer2];
        
        NSLog(@"%@", hugeContainer);
        
        // Destroyer
        smallContainer1 = nil;
        smallContainer2 = nil;
        smallContainer3 = nil;
        smallContainer4 = nil;
        bigContainer1 = nil;
        bigContainer2 = nil;
        hugeContainer = nil;
#endif
    }

    
    return 0;
}
