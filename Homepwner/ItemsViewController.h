#import <Foundation/Foundation.h>
#import "HomepwnerItemCell.h"

@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate>
{
    IBOutlet UIView *headerView;
    UIPopoverController *imagePopover;
}

- (IBAction)addNewItem:(id)sender;

@end