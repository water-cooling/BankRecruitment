//
//  SignCalendarViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/30.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "SignCalendarViewController.h"
#import "DAYCalendarView.h"

@interface SignCalendarViewController ()
@property (nonatomic, strong) DAYCalendarView* calendarView;
@end

@implementation SignCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
    
    [self NetworkAppEveryDaySign];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"签到记录";
    
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

/**
 签到记录
 */
- (void)NetworkAppEveryDaySign
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetSignAppListSuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        [SVProgressHUD dismiss];
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *dateList = [NSMutableArray arrayWithCapacity:9];
                NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
                dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
                for(NSDictionary *modelDict in contentArray)
                {
                    NSDate *BegDate = [dateFmt dateFromString:modelDict[@"SDate"]];
                    if(BegDate)
                    {
                        [dateList addObject:BegDate];
                    }
                }
                
                if(IOS9_OR_LATER)
                {
                    self.calendarView = [[DAYCalendarView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, Screen_Width)];
                    self.calendarView.boldPrimaryComponentText = NO;
                    self.calendarView.allEventDateList = dateList;
                    self.calendarView.weekdayHeaderTextColor = [UIColor colorWithHex:@"#8792ae"];
                    self.calendarView.weekdayHeaderWeekendTextColor = [UIColor colorWithHex:@"#8792ae"];
                    self.calendarView.selectedIndicatorColor = kColorNavigationBar;
                    self.calendarView.todayIndicatorColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
                    self.calendarView.backgroundColor = [UIColor whiteColor];
                    [self.calendarView makeUIElements];
                    
                    [self.view addSubview:self.calendarView];
                }
                return;
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

@end
