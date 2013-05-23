#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemStore

+ (BNRItemStore *)sharedStore {
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

- (id)init {
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems {
    return allItems;
}

- (BNRItem *)createItem {
    BNRItem *newItem = [BNRItem randomItem];
    [allItems addObject:newItem];
    return newItem;
}

- (void)removeItem:(BNRItem *)item {
    [allItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(int)from 
                toIndex:(int)to {
    if (from == to) {
        return;
    }
    
    BNRItem *item = [allItems objectAtIndex:from];
    [allItems removeObjectAtIndex:from];
    [allItems insertObject:item atIndex:to];
}

@end
