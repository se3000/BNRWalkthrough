#import "WebViewController.h"

@implementation WebViewController

- (void)loadView {
    CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    [wv setScalesPageToFit:YES];
    
    self.view = wv;
}

- (UIWebView *)webView {
    return (UIWebView *)self.view;
}

@end
