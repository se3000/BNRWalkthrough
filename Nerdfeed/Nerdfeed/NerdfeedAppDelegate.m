#import "NerdfeedAppDelegate.h"
#import "ListViewController.h"
#import "WebViewController.h"

@implementation NerdfeedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    ListViewController *lvc = [[ListViewController alloc] 
                               initWithStyle:UITableViewStylePlain];
    UINavigationController *masterNav = [[UINavigationController alloc]
                                  initWithRootViewController:lvc];
    self.window.rootViewController = masterNav;
    
    WebViewController *wvc = [[WebViewController alloc] init];
    lvc.webViewController = wvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
