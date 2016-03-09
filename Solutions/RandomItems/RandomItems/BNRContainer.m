//
//  BNRContainer.m
//  RandomItems
//
//  Created by 梁世平 on 16/3/6.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRContainer.h"

@implementation BNRContainer

- (unsigned)totalValue
{
    _totalValue = 0;
    for (id v in _subItems) {
        if ([v isMemberOfClass:[BNRItem class]]) {
            _totalValue += [v valueInDollars];
        } else if ([v isMemberOfClass:[BNRContainer class]]) {
            _totalValue += [v totalValue];
        }
    }
    return _totalValue;
}
- (NSString *)subItemDescription
{
    _subItemDescription = nil;
    _subItemDescription = [[NSString alloc] initWithFormat:@"\n(\n"];
    for (id v in _subItems) {
        if ([v isKindOfClass:[BNRItem class]]) {
            _subItemDescription = [_subItemDescription stringByAppendingFormat:@"%@,\n",[v description]];
        }
    }
    _subItemDescription = [_subItemDescription stringByAppendingString:@")"];
    return _subItemDescription;
}
- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:
                                   @"%@ (%@): Container Worth $%u (container itself: $%u), recorded on %@%@\n",
                                   self.itemName,
                                   self.serialNumber,
                                   self.totalValue,
                                   self.valueInDollars,
                                   self.dateCreated,
                                   self.subItemDescription];
    return descriptionString;
}

- (void)addItem:(id)item
{
    if ( !_subItems )
    {
        _subItems = [[NSMutableArray alloc] init];
    }
    
    if ([item isKindOfClass:[BNRItem class]]) {
        [_subItems addObject:item];
    }
    else {
        NSLog(@"The given item cannot be identified by this container: %@", item);
    }
}

@end
