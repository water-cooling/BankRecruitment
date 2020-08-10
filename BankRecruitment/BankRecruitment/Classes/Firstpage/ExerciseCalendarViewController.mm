//
//  CourseCalendarViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExerciseCalendarViewController.h"
#import "DAYCalendarView.h"
#import "CalendarTableViewCell.h"
#import "ExaminationPaperModel.h"
#import "ExamDetailViewController.h"
#import "ExaminationTitleModel.h"
#import "ExamDetailModel.h"
#import "DailyPracticeViewController.h"
#import "DataBaseManager.h"
#import "BBAlertView.h"

@interface ExerciseCalendarViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) DAYCalendarView *calendarView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *selectedDayEventList;
@property (nonatomic, strong) NSMutableArray *totalTimeEventList;
@end

@implementation ExerciseCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedDayEventList = [NSMutableArray arrayWithCapacity:9];
    self.totalTimeEventList = [NSMutableArray arrayWithCapacity:9];
    
    [self drawViews];
//    [self drawCalendarAndTableView];
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:[NSDate date]];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
        beginDate = [beginDate dateByAddingTimeInterval:-(interval-1)*6];
    }else {
        return;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    [self NetworkGetExamDayBybegin:beginString end:endString];
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
    [self.backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
}

- (void)drawCalendarAndTableView
{
    NSMutableArray *dateList = [NSMutableArray arrayWithCapacity:9];
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    for(ExaminationPaperModel *model in self.totalTimeEventList)
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
//    if([LdGlobalObj sharedInstanse].isNightExamFlag)
//    {
//        self.calendarView.weekdayHeaderTextColor = [UIColor colorWithHex:@"#495262"];
//        self.calendarView.weekdayHeaderWeekendTextColor = [UIColor colorWithHex:@"#495262"];
//        self.calendarView.selectedIndicatorColor = kColorNavigationBar;
//        self.calendarView.todayIndicatorColor = UIColorFromHex(0x3a75cc);
//        self.calendarView.backgroundColor = [UIColor colorWithHex:@"#20282f"];
//    }else{
        self.calendarView.weekdayHeaderTextColor = [UIColor colorWithHex:@"#8792ae"];
        self.calendarView.weekdayHeaderWeekendTextColor = [UIColor colorWithHex:@"#8792ae"];
        self.calendarView.selectedIndicatorColor = kColorNavigationBar;
        self.calendarView.todayIndicatorColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        self.calendarView.backgroundColor = [UIColor whiteColor];
//    }
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
    
//    if([LdGlobalObj sharedInstanse].isNightExamFlag)
//    {
//        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
//        lineView.backgroundColor = UIColorFromHex(0x444444);
//        self.tableView.backgroundColor = [UIColor colorWithHex:@"#20282f"];
//    }
//    else
//    {
        lineView.backgroundColor = kColorLineSepBackground;
        self.tableView.backgroundColor = [UIColor colorWithHex:@"#f6fafd"];
//    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *selectDate = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", selectDate);
    [self.selectedDayEventList removeAllObjects];
    for(ExaminationPaperModel *model in self.totalTimeEventList)
    {
        if([model.BegDate isEqualToString:selectDate])
        {
            [self.selectedDayEventList addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calendarViewDidChange:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *selectDate = [formatter stringFromDate:self.calendarView.selectedDate];
    NSLog(@"%@", selectDate);
    [self.selectedDayEventList removeAllObjects];
    for(ExaminationPaperModel *model in self.totalTimeEventList)
    {
        if([model.BegDate isEqualToString:selectDate])
        {
            [self.selectedDayEventList addObject:model];
        }
    }
    [self.tableView reloadData];
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
    ExaminationPaperModel *model = self.selectedDayEventList[indexPath.row];
    loc_cell.calendarTitleLabel.text = model.Name;
    
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
    NSDate *EndDate = [dateFmt dateFromString:model.EndDate];
    NSDateFormatter* dateFmt1 = [[NSDateFormatter alloc] init];
    dateFmt1.dateFormat = @"yyyy.MM.dd";
    loc_cell.calendarTimeLabel.text = [NSString stringWithFormat:@"%@-%@",[dateFmt1 stringFromDate:BegDate], [dateFmt1 stringFromDate:EndDate]];
    
//    if([LdGlobalObj sharedInstanse].isNightExamFlag)
//    {
//        loc_cell.lineView.backgroundColor = UIColorFromHex(0x444444);
//    }
//    else
//    {
        loc_cell.lineView.backgroundColor = kColorLineSepBackground;
//    }
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ExaminationPaperModel *model = self.selectedDayEventList[indexPath.row];
    if([model.IsGet isEqualToString:@"是"])
    {
        if([[DataBaseManager sharedManager] getExamOperationListByEID:model.ID isFromIntelligent:@"否"])
        {
            NSArray *examList = [[DataBaseManager sharedManager] getExamDetailListByEID:model.ID isFromIntelligent:@"否"];
            if(examList.count > 0)
            {
                DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.title = self.title;
                vc.isSaveUserOperation = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self NetworkGetExamTitlesByEID:model.ID ExamTitle:self.title];
            }
        }
        else
        {
            [self NetworkGetExamTitlesByEID:model.ID ExamTitle:self.title];
        }
    }
    else if(model.Price.floatValue == 0)
    {
        [self NetworkSendZeroPaySuccessByLinkID:model.ID PaperName:model.Name];
    }
    else
    {
        ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
        vc.paperModel = model;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark Network
/**
 根据试卷ID获取试题的标题列表
 
 @param EID 试卷ID
 */
- (void)NetworkGetExamTitlesByEID:(NSString *)EID ExamTitle:(NSString *)title
{
    [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetExamTitleByEID:EID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *titleList = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    ExaminationTitleModel *model = [ExaminationTitleModel model];
                    [model setDataWithDic:dict];
                    [titleList addObject:model];
                }
                
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
                for(ExaminationTitleModel *model in titleList)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
                    [list addObject:dict];
                }
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:title];
                return;
            }
        }
        [SVProgressHUD dismiss];
        ZB_Toast(@"没有找到试卷");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList ExamTitle:(NSString *)title
{
    [LLRequestClass requestGetExamDetailsByTitleList:titleList Success:^(id jsonData) {
        NSDictionary *contentDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        NSString *result = contentDict[@"result"];
        if([result isEqualToString:@"success"])
        {
            NSArray *array = contentDict[@"list"];
            NSMutableArray *examList = [NSMutableArray arrayWithCapacity:9];
            for(NSDictionary *dict in array)
            {
                ExamDetailModel *model = [ExamDetailModel model];
                [model setDataWithDic:dict];
                [examList addObject:model];
            }
            
            if(examList.count > 0)
            {
                DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.title = title;
                vc.isSaveUserOperation = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [SVProgressHUD dismiss];
                ZB_Toast(@"没有找到试题");
            }
            return;
        }
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

/**
 提交支付信息  价格为零时，添加到已购买的数据库
 */
- (void)NetworkSendZeroPaySuccessByLinkID:(NSString *)LinkID PaperName:(NSString *)PaperName
{
    [LLRequestClass requestSendZeroPaySuccessByLinkID:LinkID PType:@"试卷" Abstract:PaperName Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                if([[DataBaseManager sharedManager] getExamOperationListByEID:LinkID isFromIntelligent:@"否"])
                {
                    NSArray *examList = [[DataBaseManager sharedManager] getExamDetailListByEID:LinkID isFromIntelligent:@"否"];
                    if(examList.count > 0)
                    {
                        DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.practiceList = [NSMutableArray arrayWithArray:examList];
                        vc.title = self.title;
                        vc.isSaveUserOperation = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [self NetworkGetExamTitlesByEID:LinkID ExamTitle:self.title];
                    }
                }
                else
                {
                    [self NetworkGetExamTitlesByEID:LinkID ExamTitle:self.title];
                }
                return;
            }
        }
        ZB_Toast(@"没有找到试卷");
    } failure:^(NSError *error) {
        ZB_Toast(@"失败");
    }];
}

/**

 */
- (void)NetworkGetExamDayBybegin:(NSString *)begin end:(NSString *)end
{
    [LLRequestClass requestGetExamDayBybegin:begin end:end Success:^(id jsonData) {
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
                    ExaminationPaperModel *model = [ExaminationPaperModel model];
                    [model setDataWithDic:dict];
                    [self.totalTimeEventList addObject:model];
                }
                
                [self.view removeAllSubviews];
                
                if(IOS9_OR_LATER)
                {
                    [self drawCalendarAndTableView];
                }
                
                return;
            }
        }
        [SVProgressHUD dismiss];
        ZB_Toast(@"没有找到试卷");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
        [SVProgressHUD dismiss];
    }];
}


@end
