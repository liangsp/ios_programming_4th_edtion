//
//  BNRQuizViewController.m
//  Quiz
//
//  Created by 梁世平 on 16/3/5.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRQuizViewController.h"

@interface BNRQuizViewController ()

@property(nonatomic) int m_nCurQuestionIndex;

@property(nonatomic, copy) NSArray *m_pQuestions;
@property(nonatomic, copy) NSArray *m_pAnswers;

@property(nonatomic, weak) IBOutlet UILabel *m_pQuestionLabel;
@property(nonatomic, weak) IBOutlet UILabel *m_pAnswerLabel;

@end

@implementation BNRQuizViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    // 调用父类实现的初始化方法
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_pQuestions = @[@"From what is cognac made?",
                              @"What is 7+7=?",
                              @"What is the capital of Vermont?"];
        
        self.m_pAnswers = @[@"Grapes",
                            @"14",
                            @"Montpelier"];
        
        self.tabBarItem.title = @"Quiz";
        self.tabBarItem.image = [UIImage imageNamed:@"Quiz"];
    }
    
    // 返回新对象的地址
    return self;
}

- (IBAction)showQuestion:(id)sender
{
    self.m_nCurQuestionIndex++;
    
    if (self.m_nCurQuestionIndex == [self.m_pQuestions count]) {
        self.m_nCurQuestionIndex = 0;
    }
    
    NSString *question = self.m_pQuestions[self.m_nCurQuestionIndex];
    
    self.m_pQuestionLabel.text = question;
    
    self.m_pAnswerLabel.text = @"???";
}

- (IBAction)showAnswer:(id)sender
{
    NSString *answer = self.m_pAnswers[self.m_nCurQuestionIndex];
    
    self.m_pAnswerLabel.text = answer;
}

@end
