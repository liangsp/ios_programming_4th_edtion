//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by 梁世平 on 16/3/7.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@end

@implementation BNRHypnosisViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Hypontize";
        UIImage *image = [UIImage imageNamed:@"Hypno"];
        self.tabBarItem.image = image;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc] init];
    self.view  = backgroundView;
    
    CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
    self.textField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"Hypnotize me";
    self.textField.returnKeyType = UIReturnKeyDone;
    
    self.textField.delegate = self;
    
    [backgroundView addSubview:self.textField];
    
    
    NSLog(@"BNRHypnosisViewController loadView!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"BNRHypnosisViewController viewDidLoad!");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
    
#if 0
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:@[@"Red", @"Green", @"Blue"]];
    
    sc.frame = CGRectMake(self.view.bounds.origin.x + 85,
                          self.view.bounds.origin.y + 550,
                          200,
                          30);
    
    sc.tintColor = [UIColor blackColor];
    
    [sc addTarget:self.view
           action:@selector(selectCircleColor:)
 forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:sc];
#endif
    NSLog(@"BNRHypnosisViewController viewWillAppear!");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textField resignFirstResponder];
    
    NSLog(@"BNRHypnosisViewController viewWillDisappear!");
}

- (void)drawHypnoticMessage:(NSString *)message
{
    for (unsigned index = 0; index < 20; ++index) {
        UILabel * messageLabel = [[UILabel alloc] init];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.text = message;
        
        [messageLabel sizeToFit];
        
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        
        int x = arc4random() % width;
        int y = arc4random() % height;
        
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        [self.view addSubview:messageLabel];
        
        //运动效果，需在真实设备上运行
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    
    [self drawHypnoticMessage:textField.text];
    
    textField.text = @"";
    [self.textField resignFirstResponder];
    
    return YES;
}
@end
