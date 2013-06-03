#import "TouchViewController.h"
#import "TouchDrawView.h"

@implementation TouchViewController

- (void)loadView {
    [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
}

@end
