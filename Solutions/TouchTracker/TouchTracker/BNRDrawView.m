//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by 梁世平 on 16/3/20.
//  Copyright © 2016年 shiping. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPanGestureRecognizer *moveRecognizer;
@property (strong, nonatomic) NSMutableDictionary *linesInProgress;
@property (strong, nonatomic) NSMutableArray *finishedLines;
@property (weak, nonatomic) BNRLine *selectedLine;

@end

@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishedLines = [[NSMutableArray alloc] init];
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        //增加手势识别
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;//在识别出手势之前避免向UIView发送touchesBegin:withEvent:消息
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
        
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
        swipeRecognizer.numberOfTouchesRequired = 2;
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:swipeRecognizer];
        
    }
    
    return self;
}

- (void)strokeLine: (BNRLine *)line
{
    CGPoint velocity = [self.moveRecognizer velocityInView:self];
    //NSLog(@" This is the velocity %@", NSStringFromCGPoint(velocity));
    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
    //NSLog(@" This is the magnitute %f", magnitude);
    
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = magnitude / 100;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint: line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void) strokeCompletedLine: (BNRLine *) line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)deleteLine:(id)sender
{
    [self.finishedLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
}

- (BNRLine *)lineAtPoint: (CGPoint)p
{
    for(BNRLine *l in self.finishedLines)
    {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        for(float t = 0.0f; t < 1.0; t += 0.5)
        {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            if(hypot(x - p.x, y - p.y) < 20.0)
            {
                return l;
            }
        }
    }
    
    return nil;
}


#pragma mark - DrawRect
- (void)drawRect:(CGRect)rect
{
    // 用黑色线条绘制已经完成的线条
    [[UIColor blackColor] set];
    for (BNRLine *line in self.finishedLines)
    {
        [self strokeCompletedLine:line];
    }
    
    // 用红色线条绘制正在画的线条
    [[UIColor redColor] set];
    for(NSValue *key in self.linesInProgress)
    {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
}

#pragma mark - touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches)
    {
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}


#pragma mark - Gesture
- (void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized Double Tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)Tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognize tap");
    
    //选中线条为绿色
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    //显示UIMenuController
    if(self.selectedLine)
    {
        [self becomeFirstResponder];
        
        //获取UIMenuController实例
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        //创建个标题为"Delete"的UIMenuItem实例
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        
        //设置UIMenuController显示区域，并设置可见
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else
    {
        //没选中线条则隐藏UIMenuController对象
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

- (void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    }else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    
    [self setNeedsDisplay];
    
}

- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    if (!self.moveRecognizer) {
        return;
    }
    
    if (gr.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gr translationInView:self];
        
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

- (void)swipeUp:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized swipe up");
}

#pragma mark - UIRecognizer  Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[UIMenuController sharedMenuController] isMenuVisible])
    {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        self.selectedLine = nil;
    }
    
    return YES;
}

#pragma mark - UIResponder
//UIMenuController显示条件：该对象UIView必须是当前UIWindow对象的第一响应对象
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
