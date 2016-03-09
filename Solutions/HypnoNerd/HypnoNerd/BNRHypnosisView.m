//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by 梁世平 on 16/3/6.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView()

@property (strong, nonatomic) UIColor *circleColor;

@end

@implementation BNRHypnosisView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置BNRHypnosisView对象的背景颜色为透明
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

#if 0
- (void)selectCircleColor:(id)sender
{
    char colorIndex = [sender selectedSegmentIndex];
    switch (colorIndex) {
        case 0:
            self.circleColor = [UIColor redColor];
            break;
        case 1:
            self.circleColor = [UIColor greenColor];
            break;
        case 2:
            self.circleColor = [UIColor blueColor];
            break;
            
        default:
            break;
    }
}
#endif
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    
    self.circleColor = randomColor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect bounds = self.bounds;
    
    
#if defined(VIEWS_AND_THE_VIEW_HIERARCHY)
    /**< 渐变 begin */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //保存绘图状态
    CGContextSaveGState(currentContext);
    
    //裁剪矩形区域
    UIBezierPath *myPath = [UIBezierPath bezierPath];
    
    [myPath moveToPoint:CGPointMake(bounds.origin.x+bounds.size.width/6.0, bounds.origin.y+bounds.size.height/6.0)];
    
    [myPath addLineToPoint:CGPointMake(bounds.origin.x+bounds.size.width/6.0, bounds.origin.y+bounds.size.height/6.0 * 5.0)];
    
    [myPath addLineToPoint:CGPointMake(bounds.origin.x+bounds.size.width/6.0 * 5.0, bounds.origin.y+bounds.size.height/6.0 * 5.0)];
    
    [myPath addLineToPoint:CGPointMake(bounds.origin.x+bounds.size.width/6.0 * 5.0, bounds.origin.y+bounds.size.height/6.0)];
    
    [myPath addClip];
    
    
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 204.0/255.0, 1.0, 0.5, 1.0,   // Starting color
        1.0, 1.0, 0.0, 1.0 }; // Ending color is yellow
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColorSpace, components, locations, 2);
    
    //渐变起点
    CGPoint startPoint = CGPointMake(bounds.origin.x + bounds.size.width / 2.0, bounds.origin.y + bounds.size.height / 6.0);
    //渐变终点
    CGPoint endPoint = CGPointMake(bounds.origin.x + bounds.size.width / 2.0, bounds.origin.y + bounds.size.height / 6.0 * 5);
    //做渐变
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    
    // deallocating memory
    CGGradientRelease(gradient);
    CGColorSpaceRelease(rgbColorSpace);
    
    //恢复绘图状态
    CGContextRestoreGState(currentContext);
    /**< 渐变 end */
#endif
    
    
    /**< 绘制同心圆 begin */
    
    //根据bounds计算中心点
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width/2;
    center.y = bounds.origin.y + bounds.size.height/2;
    
    //根据视图宽和高中较小值计算圆形半径
    //float radius = (MIN(bounds.size.width, bounds.size.height)/2.0);
    
    float maxRadius = hypotf(bounds.size.width, bounds.size.height) / 2.0;
    
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    //定义绘制路径
    for (float curRaduis = maxRadius; curRaduis > 0; curRaduis -= 20.0f) {
        [path moveToPoint:CGPointMake(center.x + curRaduis, center.y)];
        [path addArcWithCenter:center
                        radius:curRaduis
                    startAngle:0
                      endAngle:M_PI*2
                     clockwise:true];
    }
    
    //设置线条宽度为3
    [path setLineWidth:3];
    
    //设置绘制颜色为浅灰色
    [self.circleColor setStroke];
    
    //绘制
    [path stroke];
    /**< 绘制同心圆 end */
    
}

@end
