#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {
//        NSMutableArray *items = [[NSMutableArray alloc] init];
//        BNRContainer *container = [[BNRContainer alloc] initWithItemName:@"Trunk"
//                                                          valueInDollars:1000 
//                                                            serialNumber:@"A1"];
        
//        for (int i = 0; i < 10; i++)
//        {
//            BNRItem *p = [BNRItem randomItem];
//            [items addObject:p];
//            [container addItem:p];
//        }
//        
//        for (BNRItem *item in items)
//            NSLog(@"%@", item);
        
        BNRItem *backpack = [[BNRItem alloc] init];
        [backpack setItemName:@"Backpack"];
        
        
        BNRItem *calculator = [[BNRItem alloc] init];
        [calculator setItemName:@"Calculator"];
        
        [backpack setContainedItem:calculator];
        
        backpack = nil;
        NSLog(@"Container: %@", [calculator container]);
        
        calculator = nil;

//        [items addObject:backpack];
//        [items addObject:calculator];        
        
//        NSLog(@"%@", container);        
//        NSLog(@"Setting items to nil...");
//        items = nil;
    }
    return 0;
}

