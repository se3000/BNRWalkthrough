#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

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
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!allItems) {
            allItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allItems {
    return allItems;
}

- (BNRItem *)createItem {
    BNRItem *newItem = [[BNRItem alloc] init];
    [allItems addObject:newItem];
    return newItem;
}

- (void)removeItem:(BNRItem *)item {
    [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
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

- (NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges {
    return [NSKeyedArchiver archiveRootObject:allItems toFile:[self itemArchivePath]];
}

@end
