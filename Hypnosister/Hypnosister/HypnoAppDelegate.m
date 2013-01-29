#import "HypnoAppDelegate.h"
#import "HypnoView.h"

@implementation HypnoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES 
//                                            withAnimation:UIStatusBarAnimationFade];
    // Override point for customization after application launch.
 
    CGRect screenRect = [[self window] bounds];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    [self.window addSubview:scrollView];
    
    CGRect bigRect = screenRect;
//    bigRect.size.width *= 2.0;
//    bigRect.size.height *= 2.0;
//    HypnoView *view = [[HypnoView alloc] initWithFrame:bigRect];
    view = [[HypnoView alloc] initWithFrame:screenRect];
    [scrollView addSubview:view];
    
    //    [scrollView addSubview:view];
    //
    //    screenRect.origin.x = screenRect.size.width;
    //    HypnoView *anotherView = [[HypnoView alloc] initWithFrame:screenRect];
    ////    [scrollView setPagingEnabled:YES];
    //    [scrollView addSubview:anotherView];
    
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:5.0];
    [scrollView setDelegate:self];
    
    [scrollView addSubview:view];
    
    [scrollView setContentSize:bigRect.size];
    
    
    BOOL success = [view becomeFirstResponder];
    if (success) {
        NSLog(@"HypnosisView became the first responder");
    } else {
        NSLog(@"Could not become first responder");
    }
    
    

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return view;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
