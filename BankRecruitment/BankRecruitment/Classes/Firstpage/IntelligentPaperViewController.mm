//
//  IntelligentPaperViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "IntelligentPaperViewController.h"
#import "IntelligenceTypeHeaderView.h"
#import "CalendarTableViewCell.h"
#import "ExaminationTitleModel.h"
#import "ExamDetailModel.h"
#import "DailyPracticeViewController.h"
#import "DataBaseManager.h"

@interface IntelligentPaperViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hisList;
@property (nonatomic, strong) UIButton *startButton;
@end

@implementation IntelligentPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hisList = [NSMutableArray arrayWithCapacity:9];
    self.title = @"智能组卷";
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    [self.startButton setTitle:@"重新抽题" forState:UIControlStateNormal];
    [self NetworkGetIntelligentExamList];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-44-TabbarSafeBottomMargin) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    _startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 35)];
    _startButton.top = self.tableView.bottom + 4;
    _startButton.centerX = Screen_Width/2;
    [_startButton setBackgroundColor:kColorNavigationBar];
    [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_startButton];
    _startButton.layer.cornerRadius = 4;
    _startButton.layer.masksToBounds = YES;
    [_startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startButtonAction
{
    [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
    [self NetworkGetIntelligentExamListByContent:@""];
}

#pragma -mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"IntelligenceTypeHeaderView" owner:nil options:nil];
    if(array.count > 0)
    {
        IntelligenceTypeHeaderView *view = [array objectAtIndex:0];
        view.label1.text = @"历史组卷记录";
        view.label2.text = @"";
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, Screen_Width, 0.5)];
        lineView.backgroundColor = kColorLineSepBackground;
        [view addSubview:lineView];

        return view;
    }
    return nil;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hisList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, CalendarTableViewCell, @"CalendarTableViewCell");
    NSDictionary *dict = self.hisList[indexPath.row];
    loc_cell.calendarTitleLabel.text = dict[@"KeyWord"];
    loc_cell.calendarTimeLabel.text = dict[@"PDate"];
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.hisList[indexPath.row];
    
    if([[DataBaseManager sharedManager] getExamOperationListByEID:dict[@"PID"] isFromIntelligent:@"是"])
    {
        NSArray *examList = [[DataBaseManager sharedManager] getExamDetailListByEID:dict[@"PID"] isFromIntelligent:@"是"];
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
            [self NetworkGetHistoryPractTitleListByPID:dict[@"PID"] andTitle:self.title];
        }
    }
    else
    {
        [self NetworkGetHistoryPractTitleListByPID:dict[@"PID"] andTitle:self.title];
    }
    
}

#pragma -mark Network
/**
 */
- (void)NetworkGetIntelligentExamList
{
    [LLRequestClass requestGetHisExPractListSuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.hisList = [NSMutableArray arrayWithArray:contentArray];
                [self.tableView reloadData];
                return;
            }
        }
        ZB_Toast(@"没有找到历史记录");
    } failure:^(NSError *error) {
        ZB_Toast(@"没有找到历史记录");
    }];
}

/**
 获取专项练习、组卷的题目列表
 */
- (void)NetworkGetHistoryPractTitleListByPID:(NSString *)PID andTitle:(NSString *)title
{
    [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetHistoryPractTitleListByPID:PID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *model in contentArray)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:model[@"ID"] forKey:@"ID"];
                    [list addObject:dict];
                }
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:title isNew:NO];
                return;
            }
        }
        
        [SVProgressHUD dismiss];
        ZB_Toast(@"没有找到试题");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 新建智能组卷取题
 */
- (void)NetworkGetIntelligentExamListByContent:(NSString *)Content
{
    [LLRequestClass requestGetIntelligentExamListByContent:Content Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if([contentArray isKindOfClass:[NSDictionary class]])
        {
            [SVProgressHUD dismiss];
            ZB_Toast(@"暂时没有找到试题哦");
            return;
        }
        
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
                
                //[{"TitleID":"35"},{"TitleID":"36"},{"TitleID":"38"},{"TitleID":"39"}]
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
                for(ExaminationTitleModel *model in titleList)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
                    [list addObject:dict];
                }
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:@"智能组卷" isNew:YES];
                return;
            }
        }
        [SVProgressHUD dismiss];
        ZB_Toast(@"暂时没有找到试题哦");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        ZB_Toast(@"暂时没有找到试题哦");
    }];
}



/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList ExamTitle:(NSString *)title isNew:(BOOL)isNew
{
    [LLRequestClass requestGetIntelligentExamDetailsByTitleList:titleList Success:^(id jsonData) {
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
                vc.isMockExamType = @"智能组卷";
                vc.isSaveUserOperation = !isNew;
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


@end
