#import "BNRITem.h"

@interface BNRContainer : BNRItem
{
    NSMutableArray *items;
}
- (NSMutableArray *)items;
- (void)addItem:(BNRItem *)item;

@end