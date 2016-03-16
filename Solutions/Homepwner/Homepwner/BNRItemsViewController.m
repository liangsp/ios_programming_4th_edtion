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

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
//        for (int i= 0; i < 5; ++i) {
//            [[BNRItemStore shareStore] createItem];
//        };
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
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
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

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState: UIControlStateNormal];
        [self setEditing:NO animated:YES];
    }
    else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (UIView *)headerView
{
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    
    return _headerView;
}

-  (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        NSArray *items = [[BNRItemStore shareStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore shareStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore shareStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

#pragma mark - Table view data source

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
    return [[[BNRItemStore shareStore] allItems] count];
#endif
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
