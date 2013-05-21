#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation ItemsViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView
     numberOfRowsInSection:(NSInteger)section {
        if (section == 0) {
            return [[[BNRItemStore sharedStore] cheapItems] count];
        } else {
            return [[[BNRItemStore sharedStore] notCheapItems] count];
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    BNRItem *item;
    if ([indexPath section] == 0) {
        item = [[[BNRItemStore sharedStore] cheapItems] objectAtIndex:[indexPath row]];
    } else {
        item = [[[BNRItemStore sharedStore] notCheapItems] objectAtIndex:[indexPath row]];
    }

    cell.textLabel.text = [item description];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
