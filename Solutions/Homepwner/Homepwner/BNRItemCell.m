//
//  BNRItemCell.m
//  Homepwner
//
//  Created by 梁世平 on 16/6/20.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender
{
    // 调用 Block 对象之前要检查Block对象是否存在
    if (self.actionBlock){
        self.actionBlock();
    }
}

@end
