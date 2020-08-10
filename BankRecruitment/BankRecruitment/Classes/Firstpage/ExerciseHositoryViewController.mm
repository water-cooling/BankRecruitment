//
//  ExerciseHositoryViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExerciseHositoryViewController.h"
#import "ExerciseHositoryTableViewCell.h"
#import "ExamDetailModel.h"
#import "DailyPracticeViewController.h"
#import "PurchedModel.h"
#import "DataBaseManager.h"
#import "ExaminationTitleModel.h"

@interface ExerciseHositoryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UISegmentedControl *titleSegmentedControl;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger selectMainIndex;
@property (nonatomic, strong) NSMutableArray *intelligentList;
@property (nonatomic, strong) NSMutableArray *examList;
@end

@implementation ExerciseHositoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.intelligentList = [NSMutableArray arrayWithCapacity:9];
    self.examList = [NSMutableArray arrayWithCapacity:9];
    self.selectMainIndex = 0;
    [self drawViews];
    
    [self NetworkGetHistoryIntelligentExamList];
    [self NetworkGetExamList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    _titleSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"   智能       ",@"   试卷       "]];
    _titleSegmentedControl.tintColor = [UIColor whiteColor];
    _titleSegmentedControl.selectedSegmentIndex = 0;
    [_titleSegmentedControl addTarget:self action:@selector(titleSegmentedControlAction) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _titleSegmentedControl;
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)titleSegmentedControlAction
{
    self.selectMainIndex = _titleSegmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

#pragma -mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selectMainIndex == 0)
    {
        return self.intelligentList.count;
    }
    else
    {
        return self.examList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExerciseHositoryTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ExerciseHositoryTableViewCell, @"ExerciseHositoryTableViewCell");
    
    NSDictionary *dict = nil;
    if(self.selectMainIndex == 0)
    {
        dict = self.intelligentList[indexPath.row];
        loc_cell.ExerciseHositoryTitleLabel.text = [NSString stringWithFormat:@"%@（考点类型）：%@", dict[@"PType"], dict[@"KeyWord"]];
        loc_cell.ExerciseHositoryTimeLabel.text = [NSString stringWithFormat:@"组卷时间：%@", dict[@"PDate"]];
    }
    else
    {
        PurchedModel *model = self.examList[indexPath.row];
        loc_cell.ExerciseHositoryTitleLabel.text = model.Abstract;
        loc_cell.ExerciseHositoryTimeLabel.text = model.FeeDate;
    }
    
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dict = nil;
    if(self.selectMainIndex == 0)
    {
        dict = self.intelligentList[indexPath.row];
        
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
                [self NetworkGetHistoryPractTitleListByPID:dict[@"PID"] andTitle:dict[@"PType"]];
            }
        }
        else
        {
            [self NetworkGetHistoryPractTitleListByPID:dict[@"PID"] andTitle:dict[@"PType"]];
        }
    }
    else
    {
        PurchedModel *model = self.examList[indexPath.row];
        
        if([[DataBaseManager sharedManager] getExamOperationListByEID:model.LinkID isFromIntelligent:@"否"])
        {
            NSArray *examList = [[DataBaseManager sharedManager] getExamDetailListByEID:model.LinkID isFromIntelligent:@"否"];
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
                [self NetworkGetExamTitlesByEID:model.LinkID ExamTitle:@"试卷历史"];
            }
        }
        else
        {
            [self NetworkGetExamTitlesByEID:model.LinkID ExamTitle:@"试卷历史"];
        }
        
    }
}

#pragma -mark Network
/**
 获取历史智能
 */
- (void)NetworkGetHistoryIntelligentExamList
{
    [LLRequestClass requestGetHistoryIntelligentListSuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.intelligentList removeAllObjects];
                self.intelligentList = [NSMutableArray arrayWithArray:contentArray];
                [self.tableView reloadData];
                return;
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)NetworkGetExamList
{
    [LLRequestClass requestGetPurchListByPType:@"试卷" Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.examList = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    PurchedModel *model = [PurchedModel model];
                    [model setDataWithDic:dict];
                    if([model.LinkID isEqualToString:[LdGlobalObj sharedInstanse].firstExaminPaperEID])
                    {
                        continue;
                    }
                    
                    [self.examList addObject:model];
                }
                
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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
                [self NetworkGetIntelligentExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:title];
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
 根据试题ID获取专项练习、组卷试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetIntelligentExamDetailListByTitleList:(NSArray *)titleList ExamTitle:(NSString *)title
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
                vc.isSaveUserOperation = YES;
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.title = title;
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

@end
