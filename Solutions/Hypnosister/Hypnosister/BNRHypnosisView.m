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
    
    
#if !defined(VIEWS_AND_THE_VIEW_HIERARCHY)
    /**< 渐变 begin */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //保存绘图状态
    CGContextSaveGState(currentContext);
    
    //裁剪三角区域
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
    
    
    
    
    
    //图片加载
    
    //保存绘图状态
    CGContextSaveGState(currentContext);
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    float rightX = bounds.size.width / 2 - (logoImage.size.width / 4);
    float righty = bounds.size.height / 2 - (logoImage.size.height / 4);
    
    CGRect logoRect = CGRectMake(rightX,
                                 righty,
                                 logoImage.size.width / 2,
                                 logoImage.size.height / 2);
    //设置阴影
    CGContextSetShadow(currentContext, CGSizeMake(4,10), 3);
    
    //图片绘制
    [logoImage drawInRect:logoRect];
    
    //恢复绘图状态
    CGContextRestoreGState(currentContext);
    
#endif
    
    
    
    CGFloat width = 200.0;
    CGPoint stPoint1 = CGPointMake(bounds.origin.x + bounds.size.width/2.0 - width,
                                   bounds.origin.y + bounds.size.height/2.0 - width);
    
    CGPoint stPoint2 = CGPointMake(bounds.origin.x + bounds.size.width/2.0 - width,
                                   bounds.origin.y + bounds.size.height / 2.0 + width);
    
    CGPoint stPoint3 = CGPointMake(bounds.origin.x + bounds.size.width/2.0 + width,
                                   bounds.origin.y + bounds.size.height/2.0 + width);
    
    CGPoint stPoint4 = CGPointMake(bounds.origin.x + bounds.size.width/2.0 + width,
                                   bounds.origin.y + bounds.size.height/2.0 - width);
    
    UIBezierPath *pbPath = [UIBezierPath bezierPath];
    
    [pbPath moveToPoint:stPoint1];
    [pbPath addQuadCurveToPoint:stPoint3 controlPoint:stPoint2];
    
    [pbPath moveToPoint:stPoint1];
    [pbPath addQuadCurveToPoint:stPoint3 controlPoint:stPoint4];
    
    [pbPath moveToPoint:stPoint2];
    [pbPath addQuadCurveToPoint:stPoint4 controlPoint:stPoint1];
    
    [pbPath moveToPoint:stPoint2];
    [pbPath addQuadCurveToPoint:stPoint4 controlPoint:stPoint3];
    
#if 0
    [pbPath moveToPoint:stPoint1];
    [pbPath addCurveToPoint:stPoint3
              controlPoint1:stPoint2
              controlPoint2:stPoint4];
    
    [pbPath moveToPoint:stPoint1];
    [pbPath addCurveToPoint:stPoint3
              controlPoint1:stPoint4
              controlPoint2:stPoint2];
    
    [pbPath moveToPoint:stPoint2];
    [pbPath addCurveToPoint:stPoint4
              controlPoint1:stPoint3
              controlPoint2:stPoint1];
    
    [pbPath moveToPoint:stPoint2];
    [pbPath addCurveToPoint:stPoint4
              controlPoint1:stPoint1
              controlPoint2:stPoint3];
#endif
    
    [[UIColor blueColor] setStroke];
    
    pbPath.lineWidth = 2;
    
    [pbPath strokeWithBlendMode:kCGBlendModeNormal alpha:0.5];
    
}

@end
