#import <Foundation/Foundation.h>

@interface RSSChannel : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentString;
}

@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *infoString;
@property (nonatomic, readonly) NSMutableArray *items;

@end
