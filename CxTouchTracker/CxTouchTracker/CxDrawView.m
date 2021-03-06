//
//  CxDrawView.m
//  CxTouchTracker
//
//  Created by 成鑫 on 15/4/11.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import "CxDrawView.h"
#import "CxLine.h"

@interface CxDrawView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, weak) CxLine *selectedLine;
@property (nonatomic) int tapLine;
@property (nonatomic) int longPressLine;

@end

@implementation CxDrawView

- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    // 如果没有选中线条直接返回
    if (!self.selectedLine) {
        return;
    }
    
    // 如果UIPanGestureRecognizer处于"changed"状态
    if (gr.state == UIGestureRecognizerStateChanged) {
        // 获取手指拖移距离
        CGPoint translation = [gr translationInView:self];
        
        // 将拖移距离加到选中线条的起点和终点
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldRecognizeSimultaneouslyWithGestureRecognizer:
                          (UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

- (void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        self.longPressLine = 1;
        self.tapLine = 0;
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)deleteLine:(id)sender
{
    [self.finishedLines removeObject:self.selectedLine];
    
    [self setNeedsDisplay];
}

- (CxLine *) lineAtPoint:(CGPoint)p
{
    // 找出距离p最近的CxLine对象
    for (CxLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        // 检查线条上的点
        for (float t =0.0; t < 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    return nil;
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"已正确识别单击");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine) {
        // 使视图成为UIMenuItem动作消息目标
        [self becomeFirstResponder];
        
        self.longPressLine = 0;
        self.tapLine = 1;
        
        // 获取UIMenuController对象
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        // 创建标题为"Delete"的UIMenuItem对象
        UIMenuItem *deleteItem =
        [[UIMenuItem alloc] initWithTitle:@"Delete"
                                   action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        
        // 为UIMenuController设置显示区域，将其设置为可见
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    } else {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

- (void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"已正确识别双击");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        CxLine *line = self.linesInProgress[key];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        CxLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
} 

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // 查看触摸事件顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        CxLine *line = [[CxLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    [self setNeedsDisplay];
}

- (void)strokeLine:(CxLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect
{
    // 用黑色绘制已经完成的线条
    [[UIColor blackColor] set];
    for (CxLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    if (self.selectedLine) {
        if (self.tapLine == 1) {
            [[UIColor greenColor] set];
            [self strokeLine:self.selectedLine];
        } else if (self.longPressLine) {
            [[UIColor yellowColor] set];
            [self strokeLine:self.selectedLine];
        }
        
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        // 开启多点触摸
        self.multipleTouchEnabled = YES;
        
        // 创建手势识别对象
        UITapGestureRecognizer *doubleTapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *longRecognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(longPress:)];
        [self addGestureRecognizer:longRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
         self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
    }
    return self;
}

@end
