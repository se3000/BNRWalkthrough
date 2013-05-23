#import "DetailViewController.h"
#import "BNRItem.h"

@implementation DetailViewController

@synthesize item;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    nameField.text = item.itemName;
    serialNumberField.text = item.serialNumber;
    valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    item.itemName = nameField.text;
    item.serialNumber = serialNumberField.text;
    item.valueInDollars = [valueField.text intValue];
}

- (void)setItem:(BNRItem *)newItem {
    item = newItem;
    self.navigationItem.title = item.itemName;
}

@end