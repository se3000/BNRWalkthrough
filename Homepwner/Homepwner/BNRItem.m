#import "BNRItem.h"

@implementation BNRItem

@synthesize itemName, containedItem, container, serialNumber, valueInDollars, dateCreated, imageKey;
@synthesize thumbnail, thumbnailData;

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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
    
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        self.serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        self.imageKey = [aDecoder decodeObjectForKey:@"imageKey"];
        self.valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];

        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        
        thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    return self;
}

- (UIImage *)thumbnail {
    if (!thumbnailData) {
        return nil;
    }
    
    if (!thumbnail) {
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image {
    CGSize originalImageSize = [image size];
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    //figure out scaling ratio
    float ratio = MAX(newRect.size.width / originalImageSize.width, 
                      newRect.size.height / originalImageSize.height);
    //create a transparent bitmap context with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    //create a rounded rectangle path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect 
                                                    cornerRadius:5.0];
    //make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    //center the image
    CGRect projectRect;
    projectRect.size.width = ratio * originalImageSize.width;
    projectRect.size.height = ratio * originalImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    //draw image
    [image drawInRect:projectRect];
    //get image from the image context, keep it as thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    //get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    self.thumbnailData = data;
    //cleanup image context resources
    UIGraphicsEndImageContext();
}

@end
