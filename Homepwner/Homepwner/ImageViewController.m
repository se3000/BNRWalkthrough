#import "ImageViewController.h"

@implementation ImageViewController

@synthesize image;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGSize size = self.image.size;
    scrollView.contentSize = size;
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    imageView.image = self.image;
}

@end
