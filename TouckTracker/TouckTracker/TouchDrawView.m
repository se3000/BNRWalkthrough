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
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                        action:@selector(tap:)];
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                      action:@selector(longPress:)];
        moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        moveRecognizer.delegate = self;
        moveRecognizer.cancelsTouchesInView = NO;
        
        [self addGestureRecognizer:tapRecognizer];
        [self addGestureRecognizer:pressRecognizer];
        [self addGestureRecognizer:moveRecognizer];
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
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        CGContextMoveToPoint(context, self.selectedLine.begin.x, self.selectedLine.begin.y);
        CGContextAddLineToPoint(context, self.selectedLine.end.x, self.selectedLine.end.y);
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

- (void)tap:(UIGestureRecognizer *)recognizer {
    NSLog(@"Recognizer tap");
    
    CGPoint point = [recognizer locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    [linesInProcess removeAllObjects];
    
    if (self.selectedLine) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" 
                                                            action:@selector(deleteLine:)];

        [menu setMenuItems:[NSArray arrayWithObject:deleteItem]];
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    } else {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

- (Line *)lineAtPoint:(CGPoint)point {
    for (Line *line in completeLines) {
        CGPoint start = line.begin;
        CGPoint end = line.end;
        
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            if (hypot(x - point.x, y - point.y) < 20.0) {
                return line;
            }
        }
    }
    
    return nil;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)deleteLine:(id)sender {
    [completeLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
}

- (void)longPress:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.selectedLine = [self lineAtPoint:[recognizer locationInView:self]];
        
        if (self.selectedLine) {
            [linesInProcess removeAllObjects];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

- (void)moveLine:(UIPanGestureRecognizer *)recognizer {
    if (!self.selectedLine)
        return;
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        [self setNeedsDisplay];
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherRecognizer {
    if (recognizer == moveRecognizer)
        return YES;
    return NO;
}

@end