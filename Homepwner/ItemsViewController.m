#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "DetailViewController.h"

@implementation ItemsViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.navigationItem.title = @"Homepwner";
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self
                                                                                     action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        self.navigationItem.leftBarButtonItem = [self editButtonItem];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    BNRItem *item = [[BNRItemStore.sharedStore allItems] objectAtIndex:[indexPath row]];
    cell.textLabel.text = [item description];
    
    return cell;
}

- (IBAction)addNewItem:(id)sender {
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    int lastRow = [[BNRItemStore sharedStore].allItems indexOfObject:newItem];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *sharedStore = [BNRItemStore sharedStore];
        NSArray *items = sharedStore.allItems;
        BNRItem *item = [items objectAtIndex:[indexPath row]];
        [sharedStore removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    NSArray *items = [BNRItemStore sharedStore].allItems;
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    detailViewController.item = selectedItem;
    
    [[self navigationController] pushViewController:detailViewController 
                                           animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

@end
