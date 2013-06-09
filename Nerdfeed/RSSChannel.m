#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel

@synthesize items, title, infoString, parentParserDelegate;

- (id)init {
    if (self = [super init]) {
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict {
    NSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"title"]) {
        currentString = [[NSMutableString alloc] init];
        self.title = currentString;
    } else if ([elementName isEqual:@"description"]) {
        currentString = [[NSMutableString alloc] init];
        self.infoString = currentString;
    } else if ([elementName isEqual:@"item"]) {
        RSSItem *entry = [[RSSItem alloc] init];
        entry.parentParserDelegate = self;
        parser.delegate = entry;

        [items addObject:entry];
    }
}

- (void)parser:(NSXMLParser *)parser 
foundCharacters:(NSString *)string {
    [currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    currentString = nil;
    
    if ([elementName isEqual:@"channel"])
        parser.delegate = parentParserDelegate;
}

@end
