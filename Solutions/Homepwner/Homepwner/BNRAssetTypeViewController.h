//
//  BNRAssetTypeViewController.h
//  Homepwner
//
//  Created by 梁世平 on 16/7/3.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRAssetTypeViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic) UIAlertController *addAssetAlert;



@end
