//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by 梁世平 on 16/7/3.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@implementation BNRAssetTypeViewController

- (instancetype)init
{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Asset Type", @"BNRAssetTypeViewController title");
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                               target:self
                               action:@selector(addNewAssetType:)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)addNewAssetType:(id)sender
{
    if (!_addAssetAlert) {
        NSString *title = NSLocalizedString(@"Asset Type", @"alert controller title");
        NSString *msg = NSLocalizedString(@"Add new asset type", "alert controller message");
        _addAssetAlert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        [self.addAssetAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = NSLocalizedString(@"Please add asset type", @"alert text placeholder");
        }];
        
        NSString *okString = NSLocalizedString(@"Ok", @"alert controller ok action");
        __weak UIAlertController *weakRef = _addAssetAlert;
        UIAlertAction *ok = [UIAlertAction actionWithTitle:okString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK button tapped!");
            UIAlertController *strongRef = weakRef;
            NSString *assetType = ((UITextField *)[strongRef.textFields objectAtIndex:0]).text;
            if (assetType.length > 0) {
                [[BNRItemStore shareStore] createAssetWithName:assetType];
            }
            
            [self.tableView reloadData];
        }];
        [self.addAssetAlert addAction:ok];
        
        NSString *cancelString = NSLocalizedString(@"Cancel", @"alert controller cancel action");
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Dismiss button tapped!");
        }];
        [self.addAssetAlert addAction:cancel];
    }
    [self presentViewController:_addAssetAlert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore shareStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *allAssetType = [[BNRItemStore shareStore] allAssetTypes];
    NSManagedObject *assetType = allAssetType[indexPath.row];
    
    NSString *assetLabel = [assetType valueForKey:@"label"];
    cell.textLabel.text = assetLabel;
    
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[BNRItemStore shareStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UITableViewCellEditingStyleDelete == editingStyle)
    {
        NSArray *allAssetType = [[BNRItemStore shareStore] allAssetTypes];
        NSManagedObject *assetType = allAssetType[indexPath.row];
        
        [[BNRItemStore shareStore] removeAssetType:assetType];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//-  (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (UITableViewCellEditingStyleDelete == editingStyle)
//    {
//        NSArray *items = [[BNRItemStore shareStore] allItems];
//        BNRItem *item = items[indexPath.row];
//        [[BNRItemStore shareStore] removeItem:item];
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}

@end
