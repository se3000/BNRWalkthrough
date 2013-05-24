#import "BNRItem.h"

@implementation BNRItem
@synthesize itemName, containedItem, container, serialNumber, valueInDollars, dateCreated, imageKey;
@synthesize items;

+ (id)randomItem
{
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",
                                                             @"Rusty",
                                                             @"Shiny", nil];
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                                                        @"Spork",
                                                        @"Mac", nil];
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                      valueInDollars:randomValue 
                                        serialNumber:randomSerialNumber];
    
    return newItem;
}

- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    self = [super init];
    if (self) {
        [self setItemName:name];
        [self setValueInDollars:value];
        [self setSerialNumber:sNumber];
        dateCreated = [[NSDate alloc] init];
    }
    
    return self;
}

- (id)init
{
    return [self initWithItemName:@"Item" 
                   valueInDollars:0 
                     serialNumber:@""];
}

- (id)initWithItemName:(NSString *)name 
          serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name 
                   valueInDollars:0
                     serialNumber:sNumber];
}

- (void)setContainedItem:(BNRItem *)item
{
    containedItem = item;
    [item setContainer:self];
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                                                       itemName,
                                                       serialNumber,
                                                       [self valueInDollars],
                                                       dateCreated];
    
    return descriptionString;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}
@end
