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
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] 
                                             initWithManagedObjectModel:model];
        NSURL *storeURL = [NSURL fileURLWithPath:[self itemArchivePath]];
        NSError *error;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType 
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error])
            [NSException raise:@"Open failed" 
                        format:@"Reason: %@", [error localizedDescription]];
        
        context = [[NSManagedObjectContext alloc] init];
        context.persistentStoreCoordinator = psc;
        context.undoManager = nil;
        
        [self loadAllItems];
    }
    return self;
}

- (NSArray *)allItems {
    return allItems;
}

- (BNRItem *)createItem {
    double order;
    if ([allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[allItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [allItems count], order);
    
    BNRItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                               inManagedObjectContext:context];

    newItem.orderingValue = order;
    [allItems addObject:newItem];
    return newItem;
}

- (void)removeItem:(BNRItem *)item {
    [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
    [context deleteObject:item];
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
    
    double lowerBound = 0.0;
    if (to > 0) {
        lowerBound = [[allItems objectAtIndex:(to - 1)] orderingValue];
    } else {
        lowerBound = [[allItems objectAtIndex:1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    if (to < [allItems count] - 1) {
        upperBound = [[allItems objectAtIndex:(to + 1)] orderingValue];
    } else {
        upperBound = [[allItems objectAtIndex:(to - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges {
    NSError *error;
    BOOL successful = [context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems {
    if (!allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [[model entitiesByName] objectForKey:@"BNRItem"];
        request.entity = entityDescription;
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" 
                                                                         ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" 
                        format:@"Reason: %@", error.localizedDescription];
        }
        
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes {
    if (!allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [[model entitiesByName] objectForKey:@"BNRAssetType"];
        request.entity = entity;
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" 
                        format:@"Reason: %@", [error localizedDescription]];
        }
        allAssetTypes = [result mutableCopy];
    }
    
    if ([allAssetTypes count] == 0) {
        NSManagedObject *type;
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" 
                                             inManagedObjectContext:context];
        [type setValue:@"Furniture" forKey:@"label"];
        [allAssetTypes addObject:type];
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [allAssetTypes addObject:type];
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:context];
        [type setValue:@"Electronics" forKey:@"label"];
        [allAssetTypes addObject:type];
    }
    
    return allAssetTypes;
}

@end
