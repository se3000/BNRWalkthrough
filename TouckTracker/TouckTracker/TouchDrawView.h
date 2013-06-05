#import <UIKit/UIKit.h>

@class Line;

@interface TouchDrawView : UIView <UIGestureRecognizerDelegate>
{
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
    
    UIPanGestureRecognizer *moveRecognizer;
}

@property (nonatomic, weak) Line *selectedLine;

- (void)clearAll;
- (void)endTouches:(NSSet *)touches;
- (Line *)lineAtPoint:(CGPoint)point;

@end
