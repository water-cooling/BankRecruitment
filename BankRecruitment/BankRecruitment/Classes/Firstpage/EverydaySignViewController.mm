//
//  EverydaySignViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "EverydaySignViewController.h"
#import "ExaminationPaperViewController.h"
#import "SignCalendarViewController.h"

@interface EverydaySignViewController ()
@property (nonatomic, strong) IBOutlet UIButton *signButton;
@property (nonatomic, strong) IBOutlet UILabel *signDaysLabel;
@end

@implementation EverydaySignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"每日一练 天天签到";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *dailyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dailyButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    [dailyButton setImage:[UIImage imageNamed:@"day_btn_history"] forState:UIControlStateNormal];
    [dailyButton addTarget:self action:@selector(dailyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [dailyButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dailyButton];
    
    self.signDaysLabel.text = [NSString stringWithFormat:@"累计签到%@天", [LdGlobalObj sharedInstanse].user_SignDays];
    if(isSignAppToday([LdGlobalObj sharedInstanse].user_LastSign))
    {
        [self.signButton setImage:[UIImage imageNamed:@"btn_yiqiandao"] forState:UIControlStateNormal];
        self.signButton.userInteractionEnabled = NO;
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dailyButtonPressed
{
    SignCalendarViewController *vc = [[SignCalendarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signButtonAction:(id)sender
{
    [self NetworkAppEveryDaySign];
}

- (IBAction)DailyPracticeButtonAction:(id)sender
{
    ExaminationPaperViewController *vc = [[ExaminationPaperViewController alloc] init];
    vc.examinationPaperType = ExaminationPaperDailyPracticeType;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 每日签到
 */
- (void)NetworkAppEveryDaySign
{
    //判断今天是否已签到
    if(isSignAppToday([LdGlobalObj sharedInstanse].user_LastSign))
    {
        return;
    }
    
    [LLRequestClass requestSignAppSuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        
        if([contentArray isKindOfClass:[NSDictionary class]])
        {
            ZB_Toast(@"签到失败");
            return;
        }
        
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                ZB_Toast(@"已签到");
                [LdGlobalObj sharedInstanse].user_acc = contentDict[@"acc"];
                [LdGlobalObj sharedInstanse].user_LastSign = contentDict[@"LastSign"];
                [LdGlobalObj sharedInstanse].user_SignDays = contentDict[@"SignDays"];
                
                [self.signButton setImage:[UIImage imageNamed:@"btn_yiqiandao"] forState:UIControlStateNormal];
                self.signButton.userInteractionEnabled = NO;
                self.signDaysLabel.text = [NSString stringWithFormat:@"累计签到%@天", [LdGlobalObj sharedInstanse].user_SignDays];
                return;
            }
        }
        ZB_Toast(@"签到失败");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

@end
