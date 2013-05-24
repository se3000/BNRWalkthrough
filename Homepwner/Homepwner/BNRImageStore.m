#import "BNRImageStore.h"

@implementation BNRImageStore

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

+ (BNRImageStore *)sharedStore {
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

- (id)init {
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    return [dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key)
        return;
    [dictionary removeObjectForKey:key];
}

@end