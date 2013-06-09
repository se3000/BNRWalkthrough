#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"

@implementation ListViewController

@synthesize webViewController;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [self fetchEntries];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [channel.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:@"UITableViewCell"];
    }
    RSSItem *item = [channel.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    
    return cell;
}

- (void)fetchEntries {
    xmlData = [[NSMutableData alloc] init];
    
//    NSURL *url = [NSURL URLWithString:
//                  @"http://forums.bignerdranch.com/smartfeed.php?"
//                  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    NSURL *url = [NSURL URLWithString: @"http://www.apple.com/pr/feeds/pr.rss"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request 
                                                 delegate:self
                                         startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn
    didReceiveData:(NSData *)data {
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
    [parser parse];
    
    xmlData = nil;
    connection = nil;
    
    [self.tableView reloadData];
    
    NSLog(@"%@\n %@\n %@\n", channel, channel.title, channel.infoString);
}

- (void)connection:(NSURLConnection *)conn 
  didFailWithError:(NSError *)error {
    connection = nil;
    xmlData = nil;
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {
    NSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqualToString:@"channel"]) {
        channel = [[RSSChannel alloc] init];
        channel.parentParserDelegate = self;
        parser.delegate = channel;
    }
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:webViewController 
                                         animated:YES];
    RSSItem *entry = [channel.items objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString: entry.link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [webViewController.webView loadRequest:request];
    webViewController.navigationItem.title = entry.title;
}

@end
