#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

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
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey) {
        UIImage *imageToDisplay  = [[BNRImageStore sharedStore] imageForKey:imageKey];
        [imageView setImage:imageToDisplay];
    } else {
        [imageView setImage:nil];
    }
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

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)pickeing
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *oldKey = item.imageKey;
    if (oldKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString *key = (__bridge NSString *)newUniqueIDString;
    item.imageKey = key;
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:item.imageKey];
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

@end