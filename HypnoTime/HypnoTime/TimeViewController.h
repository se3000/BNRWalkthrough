#import <UIKit/UIKit.h>

@interface TimeViewController : UIViewController
{
    __weak IBOutlet UILabel *timeLabel;
}

- (IBAction)showCurrentTime:(id)sender;

- (void)spinTimeLabel;
- (void)bounceTimeLabel;

@end
