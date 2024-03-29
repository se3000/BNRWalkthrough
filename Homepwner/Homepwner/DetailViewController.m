#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "AssetTypePicker.h"

@implementation DetailViewController

@synthesize item, dismissBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:@"Wrong Initializer" 
                                   reason:@"Use ItemForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (id)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self && isNew) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] 
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                     target:self 
                                     action:@selector(save:)];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] 
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                       target:self 
                                       action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        self.navigationItem.leftBarButtonItem = cancelItem;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *backgroundColor;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        backgroundColor = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    self.view.backgroundColor = backgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    nameField.text = item.itemName;
    serialNumberField.text = item.serialNumber;
    valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:item.dateCreated];
    dateLabel.text = [dateFormatter stringFromDate:date];
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey) {
        UIImage *imageToDisplay  = [[BNRImageStore sharedStore] imageForKey:imageKey];
        [imageView setImage:imageToDisplay];
    } else {
        [imageView setImage:nil];
    }
    
    NSString *typeLabel = [item.assetType valueForKey:@"label"];
    if (!typeLabel)
        typeLabel = @"None";
    
    [assetTypeButton setTitle:[NSString stringWithFormat:@"Type: %@", typeLabel]
                     forState:UIControlStateNormal];
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
    if ([imagePickerPopover isPopoverVisible]) {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    imagePicker.delegate = self;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        imagePickerPopover.delegate = self;
        [imagePickerPopover presentPopoverFromBarButtonItem:sender 
                                   permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                   animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picking
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *oldKey = item.imageKey;
    if (oldKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [item setThumbnailDataFromImage:image];
    
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString *key = (__bridge NSString *)newUniqueIDString;
    item.imageKey = key;
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:item.imageKey];
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    imageView.image = image;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)showAssetTypePicker:(id)sender {
    if ([assetTypePickerPopover isPopoverVisible]) {
        [assetTypePickerPopover dismissPopoverAnimated:YES];
        assetTypePickerPopover = nil;
        return;
    }
    [self.view endEditing:YES];
    AssetTypePicker *assetTypePicker = [[AssetTypePicker alloc] init];
    assetTypePicker.item = item;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        assetTypePickerPopover = [[UIPopoverController alloc] initWithContentViewController:assetTypePicker];
        assetTypePickerPopover.delegate = self;
        
        CGRect rect = [self.view convertRect:[sender bounds] fromView:sender];

        assetTypePickerPopover.popoverContentSize = CGSizeMake(300, 300);
        [assetTypePickerPopover presentPopoverFromRect:rect
                                                inView:self.view 
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
    } else {
        [self.navigationController pushViewController:assetTypePicker
                                             animated:YES];
    }
}

- (BOOL)supportedInterfaceOptions {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}

- (void)save:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES 
                                                      completion:dismissBlock];
}

- (void)cancel:(id)sender {
    [[BNRItemStore sharedStore] removeItem:item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES 
                                                      completion:dismissBlock];
}

@end