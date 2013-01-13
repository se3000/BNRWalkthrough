#import "BNRContainer.h"

@implementation BNRContainer

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super initWithItemName:name valueInDollars:value serialNumber:sNumber];
    items = [[NSMutableArray alloc] init];
    
    return self;
}

- (NSMutableArray *)items
{
    return items;
}

- (void)addItem:(BNRItem *)item
{
    [items addObject:item];
}

- (int)valueInDollars
{
    int totalValue = self.valueInDollars;
    for (BNRItem *item in items)
    {
        totalValue += item.valueInDollars;
    }
    return totalValue;
}

- (NSString *)description
{
    NSString *previousItemsDescription;
    NSString *itemsDescription = [NSString stringWithFormat:@"%@ contains:\n", [super description]];

    for(BNRItem *item in items)
    {
        previousItemsDescription = itemsDescription;
        itemsDescription = [NSString stringWithFormat:@"%@\n%@", previousItemsDescription, [item description]];
    }
    return itemsDescription;
}

@end
