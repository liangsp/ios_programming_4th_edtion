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
#import "BNR_Def.h"

@interface BNRItemsViewController ()

@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
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
    NSInteger lastRow = [[[BNRItemStore shareStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}


#pragma mark - UITableViewDelegate protocol

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
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
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
    
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
    return [[[BNRItemStore shareStore] allItems] count] + 1;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
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
    
    if (indexPath.row == [[[BNRItemStore shareStore] allItems] count]) {
        cell.textLabel.text = @"No more items!";
        return cell;
    }
    // Configure the cell...
    NSArray *aItems = [[BNRItemStore shareStore] allItems];
    BNRItem *item = aItems[indexPath.row];
    
    cell.textLabel.text = [item description];
    
#endif
    return cell;
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
