#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController
{
    IBOutlet UIView *headerView;
}

- (IBAction)addNewItem:(id)sender;

@end