//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by 梁世平 on 16/3/20.
//  Copyright © 2016年 shiping. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@implementation BNRDrawViewController

- (void)loadView
{
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

@end
