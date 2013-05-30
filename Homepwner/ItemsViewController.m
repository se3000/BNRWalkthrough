#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "DetailViewController.h"
#import "BNRImageStore.h"
#import "ImageViewController.h"

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
    BNRItem *item = [[BNRItemStore.sharedStore allItems] objectAtIndex:[indexPath row]];
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    cell.controller = self;
    cell.tableView = tableView;
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    
    return cell;
}

- (IBAction)addNewItem:(id)sender {
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:navController animated:YES completion:nil];
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
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
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

- (BOOL)supportedInterfaceOptions {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Going to show the image for %@", indexPath);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        BNRItem *displayItem = [[BNRItemStore sharedStore].allItems objectAtIndex:[indexPath row]];
        NSString *imageKey = [displayItem imageKey];
        UIImage *image = [[BNRImageStore sharedStore] imageForKey:imageKey];
        if (!image)
            return;
        CGRect rect = [self.view convertRect:[sender bounds] fromView:sender];
        
        ImageViewController *ivc = [[ImageViewController alloc] init];
        ivc.image = image;
        
        imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
        imagePopover.delegate = self;
        imagePopover.popoverContentSize = CGSizeMake(600, 600);
        [imagePopover presentPopoverFromRect:rect 
                                      inView:self.view 
                    permittedArrowDirections:UIPopoverArrowDirectionAny 
                                    animated:YES];
    }
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover = nil;
}

@end
