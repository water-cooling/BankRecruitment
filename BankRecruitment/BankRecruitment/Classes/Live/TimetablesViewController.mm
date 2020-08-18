//
//  TimetablesViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/10.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "TimetablesViewController.h"
#import "LiveUserClassScheduleModel.h"
#import "CalendarTableViewCell.h"
#import "DBY1VNLiveViewController.h"
#import "DBY1VNPlaybackViewController.h"
#import "BBAlertView.h"

@interface TimetablesViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *scheduleList;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation TimetablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scheduleList = [NSMutableArray arrayWithCapacity:9];
    [self drawViews];
    
    [self NetworkGetLiveScheduleList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
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
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
    footerView.backgroundColor = kColorBarGrayBackground;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scheduleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, CalendarTableViewCell, @"CalendarTableViewCell");
    loc_cell.accessoryType = UITableViewCellAccessoryNone;
    LiveUserClassScheduleModel *model = self.scheduleList[indexPath.row];
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
    
    LiveUserClassScheduleModel *model = self.scheduleList[indexPath.row];
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
        NSString *string = [NSString stringWithFormat:@"直播还未开始,请于%@进入直播间", model.BegDate];
        ZB_Toast(string);
    }
}

#pragma -mark Network
//获取直播课课程表
- (void)NetworkGetLiveScheduleList
{
    [LLRequestClass requestGetLiveScheduleListByLID:self.LID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                for(NSDictionary *dict in contentArray)
                {
                    LiveUserClassScheduleModel *model = [LiveUserClassScheduleModel model];
                    [model setDataWithDic:dict];
                    [self.scheduleList addObject:model];
                }
            }
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
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
