#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        linesInProcess = [[NSMutableDictionary alloc] init];
        completeLines = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    [[UIColor blackColor] set];
    for (Line *line in completeLines) {
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
    
    [[UIColor redColor] set];
    for (NSValue *value in linesInProcess) {
        Line *line = [linesInProcess objectForKey:value];
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
}

- (void)clearAll {
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches {
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        Line *line = [linesInProcess objectForKey:key];
        
        if (line) {
            [completeLines addObject:line];
            [linesInProcess removeObjectForKey:key];
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches 
           withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.tapCount > 1) {
            [self clearAll];
            return;
        }
        
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        
        CGPoint loc = [touch locationInView:self];
        Line *newLine = [[Line alloc] init];
        newLine.begin = loc;
        newLine.end = loc;
        
        [linesInProcess setObject:newLine forKey:key];
    }
}

- (void)touchesMoved:(NSSet *)touches 
           withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        Line *line = [linesInProcess objectForKey:key];
        CGPoint loc = [touch locationInView:self];
        
        line.end = loc;
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches 
           withEvent:(UIEvent *)event {
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches 
               withEvent:(UIEvent *)event {
    [self endTouches:touches];
}

@end
