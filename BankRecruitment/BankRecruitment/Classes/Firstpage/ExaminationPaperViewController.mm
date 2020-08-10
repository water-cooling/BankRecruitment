//
//  ExaminationPaperViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExaminationPaperViewController.h"
#import "ExamDetailModel.h"
#import "ExaminationTitleModel.h"
#import "DailyPracticeViewController.h"
#import "ExaminationPaperModel.h"
#import "ExaminationPaperTableViewCell.h"
#import "ExamDetailViewController.h"
#import "ExerciseCalendarViewController.h"
#import "DataBaseManager.h"
#import "EveryDayTableViewCell.h"
#import "BBAlertView.h"

@interface ExaminationPaperViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *examList;
@end

@implementation ExaminationPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.examinationPaperType == ExaminationPaperDailyPracticeType){
        self.title = @"每日一练";
        
        UIButton *dailyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dailyButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
        [dailyButton setImage:[UIImage imageNamed:@"day_btn_history"] forState:UIControlStateNormal];
        [dailyButton addTarget:self action:@selector(dailyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [dailyButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dailyButton];
        
    }else if (self.examinationPaperType == ExaminationPaperOldExamType){
        self.title = @"历年真题";
    }else if (self.examinationPaperType == ExaminationPaperExclusivePaperType){
        self.title = @"独家密卷";
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    
    self.examList = [NSMutableArray arrayWithCapacity:9];
    [self NetworkGetExaminByType:self.title andSelectedIndexPath:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-TabbarSafeBottomMargin) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorBarGrayBackground;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dailyButtonPressed
{
    ExerciseCalendarViewController *vc = [[ExerciseCalendarViewController alloc] init];
    vc.title = self.title;
//    vc.totalTimeEventList = [NSMutableArray arrayWithArray:self.examList];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.examinationPaperType == ExaminationPaperDailyPracticeType){
        return 50;
    }
    return 118;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.examList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.examinationPaperType == ExaminationPaperDailyPracticeType){
        EveryDayTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, EveryDayTableViewCell, @"EveryDayTableViewCell");
        ExaminationPaperModel *model = self.examList[indexPath.row];
        loc_cell.EveryDayLabel.text = model.Name;
        return loc_cell;
    }
    
    ExaminationPaperTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ExaminationPaperTableViewCell, @"ExaminationPaperTableViewCell");
    ExaminationPaperModel *model = self.examList[indexPath.row];
    
    loc_cell.ExaminationPaperTitleLabel.text = model.Name;
    float price = model.Price.floatValue;
    if([model.IsGet isEqualToString:@"是"]||price == 0)
    {
        loc_cell.ExaminationPaperPriceLabel.text = @"";
    }
    else
    {
        loc_cell.ExaminationPaperPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    }
    
    loc_cell.ExaminationPaperBuyNumberLabel.text = [NSString stringWithFormat:@"参与人数 %@",model.iCount];

    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
    NSDate *EndDate = [dateFmt dateFromString:model.EndDate];
    NSDateFormatter* dateFmt1 = [[NSDateFormatter alloc] init];
    dateFmt1.dateFormat = @"yyyy.MM.dd";
    loc_cell.ExaminationPaperClassPlanLabel.text = [NSString stringWithFormat:@"课程安排：%@-%@",[dateFmt1 stringFromDate:BegDate], [dateFmt1 stringFromDate:EndDate]];
    int endNumber = dateNumberFromDateToToday(model.EndDate);
    if(endNumber>0)
    {
        loc_cell.ExaminationPaperLimitTimeLabel.text = [NSString stringWithFormat:@"可参与练习时间还有%d天",endNumber];
    }
    else
    {
        loc_cell.ExaminationPaperLimitTimeLabel.text = @"已停止";
    }
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ExaminationPaperModel *model = self.examList[indexPath.row];
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
                vc.title = model.Name;
                vc.isSaveUserOperation = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self NetworkGetExamTitlesByEID:model.ID ExamTitle:model.Name];
            }
        }
        else
        {
            [self NetworkGetExamTitlesByEID:model.ID ExamTitle:model.Name];
        }
    }
    else
    {
        if(model.Price.floatValue == 0)
        {
            [self NetworkGetExamTitlesByEID:model.ID ExamTitle:model.Name];
            [self NetworkSendZeroPaySuccessByLinkID:model.ID Abstract:model.Name];
            return;
        }
        
        
        ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
        vc.paperModel = model;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark Network
/**
 功能按钮获取试题  历年真题、独家密卷、每日一练
 */
- (void)NetworkGetExaminByType:(NSString *)type andSelectedIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestdoGetExaminByTypeInfo:type Success:^(id jsonData) {
        [SVProgressHUD dismiss];
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.examList removeAllObjects];
                for(NSDictionary *dict in contentArray)
                {
                    ExaminationPaperModel *model = [ExaminationPaperModel model];
                    [model setDataWithDic:dict];
                    [self.examList addObject:model];
                }
                
                if(self.examList.count == 0)
                {
                    if(self.examinationPaperType == ExaminationPaperDailyPracticeType)
                    {
                        BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"没有找到试卷，您可以点击右上角按钮，选择历史每日一练来练习" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else
                    {
                        ZB_Toast(@"没有找到试卷");
                    }
                }
                
                [self.tableView reloadData];
                
                //登录之后继续模拟点击列表
                if(indexPath)
                {
                    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
                }
                return;
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

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
- (void)NetworkSendZeroPaySuccessByLinkID:(NSString *)LinkID Abstract:(NSString *)Abstract
{
    [LLRequestClass requestSendZeroPaySuccessByLinkID:LinkID PType:@"试卷" Abstract:Abstract Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                return;
            }
        }
        
        ZB_Toast(@"购买失败");
    } failure:^(NSError *error) {
        ZB_Toast(@"失败");
    }];
}

@end
