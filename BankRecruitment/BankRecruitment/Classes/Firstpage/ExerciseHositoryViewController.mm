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
@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, assign) NSInteger selectMainIndex;
@property (nonatomic, strong) NSMutableArray *intelligentList;
@property (nonatomic, strong) NSMutableArray *examList;
@property (nonatomic, strong) UIButton *intelligentBtn;
@property (nonatomic, strong) UIButton *testPaperBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ExerciseHositoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.intelligentList = [NSMutableArray arrayWithCapacity:9];
    self.examList = [NSMutableArray arrayWithCapacity:9];
    self.selectMainIndex = 100;
    [self drawViews];
    
    [self NetworkGetHistoryIntelligentExamList];
    [self NetworkGetExamList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 6.0f, 12.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(StatusBarHeight);
        make.left.equalTo(self.view).offset(15);
    }];
    [self.view addSubview:self.intelligentBtn];
    [self.intelligentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(-47);
        make.top.equalTo(self.view).offset(StatusBarHeight);
    }];
    [self.view addSubview:self.testPaperBtn];
    [self.testPaperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.view.mas_centerX).offset(47);
          make.top.equalTo(self.view).offset(StatusBarHeight);
      }];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = KColorBlueText;
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.intelligentBtn);
        make.top.equalTo(self.intelligentBtn.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(12, 2));
    }];
        
        UIView *speatorView = [[UIView alloc]init];
        speatorView.backgroundColor = kColorBarGrayBackground;
        [self.view addSubview:speatorView];
        [speatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view).offset(StatusBarAndNavigationBarHeight);
            make.size.mas_equalTo(CGSizeMake(Screen_Width, 1));
        }];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, Screen_Height-TabbarHeight-StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
}

- (void)mainButtonAction:(UIButton *)btn{
    NSInteger index = btn.tag;
    if (btn.tag == self.selectMainIndex) {
        return;
    }
    UIButton * lastBtn = [self.view viewWithTag:self.selectMainIndex];
    lastBtn.selected = NO;
    btn.selected = YES;
    self.selectMainIndex = index;
    [UIView animateWithDuration:0.3 animations:^{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(btn.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(12, 2));
         }];
    }];
    [self.tableView reloadData];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma -mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selectMainIndex == 100)
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
    if(self.selectMainIndex == 100)
    {
        dict = self.intelligentList[indexPath.row];
        loc_cell.ExerciseHositoryTitleLabel.text = [NSString stringWithFormat:@"%@（考点类型）：%@", dict[@"PType"], dict[@"KeyWord"]];
        loc_cell.editBtn.tag = indexPath.row;
        [loc_cell.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)editAction:(UIButton *)sender{
    NSDictionary *dict = nil;
   if(self.selectMainIndex == 100)
   {
       dict = self.intelligentList[sender.tag];
       
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
       PurchedModel *model = self.examList[sender.tag];
       
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dict = nil;
    if(self.selectMainIndex == 100)
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
        }else{
             ZB_Toast(@"暂无数据");
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
        }else{
            ZB_Toast(@"暂无数据");
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

- (UIButton *)intelligentBtn {
        if (!_intelligentBtn) {
            _intelligentBtn = [[UIButton alloc] init];
            [_intelligentBtn setTitleColor:kColorBlackText forState:UIControlStateNormal];
            [_intelligentBtn setTitleColor:KColorBlueText forState:UIControlStateSelected];
            _intelligentBtn.tag = 100;
            _intelligentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            _intelligentBtn.selected = YES;
            [_intelligentBtn setTitle:@"智能" forState:UIControlStateNormal];
            [_intelligentBtn addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _intelligentBtn;
    }

- (UIButton *)testPaperBtn {
        if (!_testPaperBtn) {
            _testPaperBtn = [[UIButton alloc] init];
           [_testPaperBtn setTitleColor:kColorBlackText forState:UIControlStateNormal];
            _testPaperBtn.tag = 101;
            [_testPaperBtn setTitleColor:KColorBlueText forState:UIControlStateSelected];
            _testPaperBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [_testPaperBtn setTitle:@"试卷" forState:UIControlStateNormal];
            [_testPaperBtn addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _testPaperBtn;
    }
@end
