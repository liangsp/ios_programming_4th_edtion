//
//  BNRReminderViewController.m
//  HypnoNerd
//
//  Created by 梁世平 on 16/3/7.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRReminderViewController.h"

@interface BNRReminderViewController ()

@property(nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRReminderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Reminder";
        UIImage *image = [UIImage imageNamed:@"Time"];
        self.tabBarItem.image = image;
    }
    return self;
}

- (IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a Reminder for %@",date);
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-mm-dd HH:mm:ss +0800"];
    //NSLog(@"Setting a Reminder for %@", [dateFormatter stringFromDate:date]);
    //NSDate *firedate = [[NSDate alloc] initWithTimeIntervalSinceNow:10];
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Hypnotize me!";
    note.fireDate = date;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"BNRReminderViewController viewDidLoad!");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
    
    //NSLog(@"BNRReminderViewController viewWillAppear!");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //NSLog(@"BNRReminderViewController viewWillDisappear!");
}


@end
