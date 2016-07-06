//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by 梁世平 on 16/3/7.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"
#import "BNR_Def.h"

@interface BNRItemsViewController () <UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController *imagePopover;
@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        
        navItem.title = NSLocalizedString(@"Homepwer", @"Name of application");
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        //注册当前区域设置发生变化的通知
        [nc addObserver:self selector:@selector(localeChangeed:) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
    //return [super initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
#if defined(BRONZE_CHANGE)
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    
    self.tableView.rowHeight = 60;
    
    self.tableView.sectionFooterHeight = 60;
    self.tableView.sectionHeaderHeight = 60;
#endif
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore shareStore] createItem];
//    NSInteger lastRow = [[[BNRItemStore shareStore] allItems] indexOfObject:newItem];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    BNRDetailViewController *detailVC = [[BNRDetailViewController alloc] initForNewItem:YES];
    
    detailVC.item = newItem;
    
    detailVC.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];;
}

#pragma mark - Notification
- (void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate protocol

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *removeString = NSLocalizedString(@"Remove", @"Table cell remove text");
    return removeString;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section)
    {
        return sourceIndexPath;
    }
    else
    {
        if (proposedDestinationIndexPath.row == [[[BNRItemStore shareStore] allItems] count]) {
            return sourceIndexPath;
        }
        else
        {
            return proposedDestinationIndexPath;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore shareStore] allItems];
    BNRItem *selectItem = items[indexPath.row];
    
    detailViewController.item = selectItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger number;
    
#if defined(BRONZE_CHANGE)
    number = 2;
#else
    number = 1;
#endif
    
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#if defined(BRONZE_CHANGE)
    
    NSPredicate *predicate;
    if (section == 0) {
        predicate = [NSPredicate predicateWithFormat:@"SELF.valueInDollars < 50"];
    }
    else if (section == 1){
        predicate = [NSPredicate predicateWithFormat:@"SELF.valueInDollars > 50"];
    }
    NSArray *arr = [[[BNRItemStore shareStore] allItems] filteredArrayUsingPredicate:predicate];
    return [arr count];
#else
    NSUInteger count = [[[BNRItemStore shareStore] allItems] count];
    return count;
#endif
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger desRow = destinationIndexPath.row;
    //NSUInteger srcRow = sourceIndexPath.row;
    
    if (desRow == [[[BNRItemStore shareStore] allItems] count]) {
        return;
    }
    
    [[BNRItemStore shareStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

-  (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle)
    {
        NSArray *items = [[BNRItemStore shareStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore shareStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger lastRow = [[[BNRItemStore shareStore] allItems] count] + 1;
    
    if (row == lastRow -1) {
        return NO;
    } else {
        return YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
//                                                            forIndexPath:indexPath];
    
    // 获取BNRItemCell对象，返回的可能是现有的对象，也可能是新创建的对象
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell"
                                                            forIndexPath:indexPath];
    
#if defined(BRONZE_CHANGE)
    
    NSPredicate *predicate;
    if (indexPath.section == 0) {
        predicate = [NSPredicate predicateWithFormat:@"SELF.valueInDollars < 50"];
    }else if(indexPath.section == 1){
        predicate = [NSPredicate predicateWithFormat:@"SELF.valueInDollars > 50"];
    }
    NSArray *aItems = [[[BNRItemStore shareStore] allItems] filteredArrayUsingPredicate:predicate];
    BNRItem *item =aItems[indexPath.row];
    cell.textLabel.text = item.description;
    //cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    //cell.backgroundColor = [UIColor clearColor];
    
#else
    
//    NSUInteger row = indexPath.row;
//    NSUInteger lastRow = [[[BNRItemStore shareStore] allItems] count];
//    if (indexPath.row == [[[BNRItemStore shareStore] allItems] count]) {
//        cell.textLabel.text = @"No more items!";
//        cell.valueLabel.text = @"";
//        cell.userInteractionEnabled = NO;
//        return cell;
//    }
    
    // Configure the cell...
    NSArray *aItems = [[BNRItemStore shareStore] allItems];
    BNRItem *item = aItems[indexPath.row];
//    cell.textLabel.text = item.description;
    
    //根据BNRItem对象设置BNRItemCell对象
    cell.textLabel.text = @"";
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    
    //本地化
    static NSNumberFormatter *currencyFormatter = nil;
    if (currencyFormatter == nil)
    {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    //cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.valueLabel.text = [currencyFormatter stringFromNumber: @(item.valueInDollars)];

    cell.thumbnailView.image = item.thumbnail;
    
        
    __weak BNRItemCell *weakCell = cell;
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        BNRItemCell *strongCell = weakCell;
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            
            // 如果BNRItem对象没有图片，就直接返回
            UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            
            BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
            ivc.image = img;
            
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };
#endif
    return cell;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}

#if defined(BRONZE_CHANGE)
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    switch (section) {
        case 0:
            sectionTitle = @"Items < $50";
            break;
            
        case 1:
            sectionTitle = @"Items > $50";
            break;
            
        default:
            break;
    }

    return sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    footer.textLabel.text = @"No more items!";
    
    return footer;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    header.contentView.backgroundColor = [UIColor lightGrayColor];
    
    if (section == 0) {
        header.textLabel.text = @"Items > $50";
    }
    if (section == 1) {
        header.textLabel.text = @"Items < $50";
    }
    
    return header;
}
#endif


@end
