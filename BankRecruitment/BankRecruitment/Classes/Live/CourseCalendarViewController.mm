//
//  CourseCalendarViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "CourseCalendarViewController.h"
#import "DAYCalendarView.h"
#import "CalendarTableViewCell.h"
#import "LiveUserClassScheduleModel.h"
#import "DBY1VNLiveViewController.h"
#import "DBY1VNPlaybackViewController.h"
#import "BBAlertView.h"

@interface CourseCalendarViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) DAYCalendarView *calendarView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *totalTimeEventList;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *selectedDayEventList;
@end

@implementation CourseCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"课程日历";
    self.totalTimeEventList = [NSMutableArray arrayWithCapacity:9];
    self.selectedDayEventList = [NSMutableArray arrayWithCapacity:9];
    [self drawViews];
    [self NetworkGetLiveScheduleList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
    }
    else
    {
        [self.backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    }
}

- (void)drawCalendarAndTableView
{
    NSMutableArray *dateList = [NSMutableArray arrayWithCapacity:9];
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    for(LiveUserClassScheduleModel *model in self.totalTimeEventList)
    {
        NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
        if(BegDate)
        {
            [dateList addObject:BegDate];
        }
    }
    
    self.calendarView = [[DAYCalendarView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, Screen_Width)];
    self.calendarView.boldPrimaryComponentText = NO;
    self.calendarView.allEventDateList = dateList;
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        self.calendarView.weekdayHeaderTextColor = [UIColor colorWithHex:@"#495262"];
        self.calendarView.weekdayHeaderWeekendTextColor = [UIColor colorWithHex:@"#495262"];
        self.calendarView.selectedIndicatorColor = kColorNavigationBar;
        self.calendarView.todayIndicatorColor = UIColorFromHex(0x3a75cc);
        self.calendarView.backgroundColor = [UIColor colorWithHex:@"#20282f"];
    }else{
        self.calendarView.weekdayHeaderTextColor = [UIColor colorWithHex:@"#8792ae"];
        self.calendarView.weekdayHeaderWeekendTextColor = [UIColor colorWithHex:@"#8792ae"];
        self.calendarView.selectedIndicatorColor = kColorNavigationBar;
        self.calendarView.todayIndicatorColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        self.calendarView.backgroundColor = [UIColor whiteColor];
    }
    [self.calendarView makeUIElements];
    [self.view addSubview:self.calendarView];
    [self.calendarView addTarget:self action:@selector(calendarViewDidChange:) forControlEvents:UIControlEventValueChanged];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.calendarView.bottom-0.5, Screen_Width, 0.5)];
    [self.view addSubview:lineView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.calendarView.bottom, Screen_Width, Screen_Height-self.calendarView.height-StatusBarAndNavigationBarHeight-TabbarSafeBottomMargin) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        lineView.backgroundColor = UIColorFromHex(0x444444);
        self.tableView.backgroundColor = [UIColor colorWithHex:@"#20282f"];
    }
    else
    {
        [self.backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
        lineView.backgroundColor = kColorLineSepBackground;
        self.tableView.backgroundColor = [UIColor colorWithHex:@"#f6fafd"];
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calendarViewDidChange:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *dateString = [formatter stringFromDate:self.calendarView.selectedDate];
    NSLog(@"%@", dateString);
    
    [self.selectedDayEventList removeAllObjects];
    for(LiveUserClassScheduleModel *model in self.totalTimeEventList)
    {
        if([[model.BegDate componentsSeparatedByString:@" "].firstObject isEqualToString:dateString])
        {
            [self.selectedDayEventList addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (void)gotoLiveClassByUrl:(NSString *)roomID AndName:(NSString *)name;
{
    DBY1VNLiveViewController* testVC = [[DBY1VNLiveViewController alloc] init];
    testVC.title = name;//
    testVC.appkey = @"4f9739ab849c46cda986f665a903ff40";//    appkey
    testVC.partnerID = @"20170419161441324358";//   partnerID
    testVC.roomID = roomID;//roomID
    testVC.userID = [LdGlobalObj sharedInstanse].user_id;//       ID
    testVC.nickName = [LdGlobalObj sharedInstanse].user_name;//
    testVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:testVC sender :nil];
}

- (void)gotoHositoryClassByUrl:(NSString *)roomID AndName:(NSString *)name;
{
    DBY1VNPlaybackViewController* testVC = [[DBY1VNPlaybackViewController alloc] init];
    testVC.title = name;//
    testVC.appkey = @"4f9739ab849c46cda986f665a903ff40";//    appkey
    testVC.partnerID = @"20170419161441324358";//   partnerID
    testVC.roomID = roomID;//roomID
    testVC.uid = [LdGlobalObj sharedInstanse].user_id;//       ID
    testVC.nickName = [LdGlobalObj sharedInstanse].user_name;//
    testVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:testVC sender :nil];
}

#pragma -mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedDayEventList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, CalendarTableViewCell, @"CalendarTableViewCell");
    loc_cell.accessoryType = UITableViewCellAccessoryNone;
    LiveUserClassScheduleModel *model = self.selectedDayEventList[indexPath.row];
    loc_cell.calendarTitleLabel.text = model.Intro;
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDateFormatter* dateFmt1 = [[NSDateFormatter alloc] init];
    dateFmt1.dateFormat = @"HH:mm";
//    NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
    NSDate *EndDate = [dateFmt dateFromString:model.EndDate];
    loc_cell.calendarTimeLabel.text = [NSString stringWithFormat:@"%@-%@",model.BegDate, [dateFmt1 stringFromDate:EndDate]];
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        loc_cell.lineView.backgroundColor = UIColorFromHex(0x444444);
    }
    else
    {
        loc_cell.lineView.backgroundColor = kColorLineSepBackground;
    }
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LiveUserClassScheduleModel *model = self.selectedDayEventList[indexPath.row];
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
    NSDate *EndDate = [dateFmt dateFromString:model.EndDate];
    NSDate *currentDate = [NSDate date];
    if([currentDate earlierDate:BegDate]==BegDate&&[currentDate laterDate:EndDate]==EndDate)
    {
        if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
        {
            [self gotoLiveClassByUrl:model.AFile AndName:model.Intro];
            [self NetworkUploadLiveScheduleLogBySID:model.SID];
        }
        else
        {
            BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"请登录后再进入直播间，否则可能会播放失败" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"游客身份进入"];
            LL_WEAK_OBJC(self);
            [alertView setConfirmBlock:^{
                [weakself gotoLiveClassByUrl:model.AFile AndName:model.Intro];
                [weakself NetworkUploadLiveScheduleLogBySID:model.SID];
            }];
            [alertView show];
        }
    }
    else if([EndDate laterDate:currentDate] == currentDate)
    {
        if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
        {
            [self gotoHositoryClassByUrl:model.AFile AndName:model.Intro];
            [self NetworkUploadLiveScheduleLogBySID:model.SID];
        }
        else
        {
            BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"请登录后再进入回放，否则可能会播放失败" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"游客身份进入"];
            LL_WEAK_OBJC(self);
            [alertView setConfirmBlock:^{
                [weakself gotoHositoryClassByUrl:model.AFile AndName:model.Intro];
                [weakself NetworkUploadLiveScheduleLogBySID:model.SID];
            }];
            [alertView show];
        }
    }
    else
    {
        ZB_Toast(@"直播还未开始哦");
    }
}

#pragma -mark Network
//获取直播课课程表
- (void)NetworkGetLiveScheduleList
{
    [LLRequestClass requestGetUserLiveScheduleListBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.totalTimeEventList removeAllObjects];
                for(NSDictionary *dict in contentArray)
                {
                    LiveUserClassScheduleModel *model = [LiveUserClassScheduleModel model];
                    [model setDataWithDic:dict];
                    [self.totalTimeEventList addObject:model];
                }
            }
        }
        
        if(IOS9_OR_LATER)
        {
            [self drawCalendarAndTableView];
        }
        
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

- (void)NetworkUploadLiveScheduleLogBySID:(NSString *)SID
{
    [LLRequestClass requestUploadLiveScheduleLogBySID:SID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                
            }
        }
        
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

@end
