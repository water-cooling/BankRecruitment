//
//  DateReportDetailViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "DateReportDetailViewController.h"

@interface DateReportDetailViewController ()
@property (nonatomic, strong) NSDictionary *detailDict;

@property (nonatomic, strong) IBOutlet UILabel *getScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *topScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *correctRateLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerCorrectNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerWrongNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerTimeLabel;
@end

@implementation DateReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.detailDict = [NSDictionary dictionary];
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.purchedModel.Abstract;
    [self NetworkGetPayInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark Network
- (void)NetworkGetPayInfo
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetDataReportByEID:self.purchedModel.LinkID Success:^(id jsonData) {
        [SVProgressHUD dismiss];
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.detailDict = [NSDictionary dictionaryWithDictionary:contentDict];
                
                float CorrectNum = ((NSNumber *)self.detailDict[@"OkCount"]).floatValue;
                float TitleCount = ((NSNumber *)self.detailDict[@"TitleCount"]).floatValue;
                self.getScoreLabel.text = self.detailDict[@"MyScore"];
                self.totalScoreLabel.text = self.detailDict[@"AllScore"];
                self.topScoreLabel.text = self.detailDict[@"MaxScore"];
                self.answerNumLabel.text = self.detailDict[@"AnswerCount"];
                self.correctRateLabel.text = [NSString stringWithFormat:@"%.2f", CorrectNum/TitleCount*100];
                self.answerCorrectNumLabel.text = self.detailDict[@"OkCount"];
                self.answerWrongNumLabel.text = self.detailDict[@"ErrCount"];
                NSString* AllTime = self.detailDict[@"AllTime"];
                int allSecondTime = AllTime.intValue;
                int hour = allSecondTime/3600;
                int min = (allSecondTime%3600)/60;
                int second = allSecondTime%60;
                NSMutableString *timeString = [NSMutableString stringWithFormat:@"%d秒", second];
                if(hour>0)
                {
                    [timeString insertString:[NSString stringWithFormat:@"%d时%d分", hour, min] atIndex:0];
                }
                else if(min>0)
                {
                    [timeString insertString:[NSString stringWithFormat:@"%d分", min] atIndex:0];
                }
                self.answerTimeLabel.text = timeString;
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}


@end
