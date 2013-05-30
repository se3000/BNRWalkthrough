#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

@synthesize thumbnailView, nameLabel, serialNumberLabel, valueLabel;
@synthesize controller, tableView;

- (IBAction)showImage:(id)sender {
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    
    if (indexPath && [self.controller respondsToSelector:newSelector]) {
        [self.controller performSelector:newSelector 
                              withObject:sender 
                              withObject:indexPath];
    }
}

@end
