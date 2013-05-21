#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (NSMutableArray *)cheapItems;
- (NSMutableArray *)notCheapItems;
- (BNRItem *)createItem;

@end
