#import "HeavyViewController.h"

@implementation HeavyViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait)
        || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end