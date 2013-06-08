#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"TimeViewController" bundle:appBundle];
    if (self) {
        self.tabBarItem.title = @"Time";
        self.tabBarItem.image = [UIImage imageNamed:@"Time.png"];
    }

    return self;
}

- (IBAction)showCurrentTime:(id)sender {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [timeLabel setText:[formatter stringFromDate:now]];
    
//    [sel f spinTimeLabel];
    [self bounceTimeLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TimeViewController loaded its view.");
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"CurrentTimeViewController will appear");
    [super viewWillAppear:animated];
    [self showCurrentTime:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"CurrentTimeViewController will disappear");
    [super viewWillDisappear:animated];
}

- (void)spinTimeLabel {
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction
                                             functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    spin.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    spin.duration = 1.0;
    spin.timingFunction = timingFunction;
    spin.delegate = self;
    
    
    [timeLabel.layer addAnimation:spin forKey:@"spinAnimation"];
}

- (void)bounceTimeLabel {
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    
    bounce.values = [NSArray arrayWithObjects:
                     [NSValue valueWithCATransform3D:CATransform3DIdentity],
                     [NSValue valueWithCATransform3D:forward],
                     [NSValue valueWithCATransform3D:back],
                     [NSValue valueWithCATransform3D:forward2],
                     [NSValue valueWithCATransform3D:back2],
                     nil];
    bounce.duration = 0.6;

    [timeLabel.layer addAnimation:bounce forKey:@"bounceAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"%@ finished: %d", anim, flag);
}

@end
