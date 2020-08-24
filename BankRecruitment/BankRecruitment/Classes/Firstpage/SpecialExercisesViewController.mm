//
//  SpecialExercisesViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/16.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "SpecialExercisesViewController.h"
#import "IntelligenceTypeHeaderView.h"
#import "IntelligenceTypeTableViewCell.h"
#import "ExaminationTitleModel.h"
#import "DailyPracticeViewController.h"
#import "ExamDetailModel.h"

@interface SpecialExercisesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *typeList;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIButton *startButton;
@end

@implementation SpecialExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.typeList = [NSMutableArray arrayWithCapacity:9];
    self.selectIndex = 0;
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.intelligentType;
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    
    if([self.intelligentType isEqualToString:@"智能组卷"])
    {
        [self.startButton setTitle:@"开始模考" forState:UIControlStateNormal];
    }
    else if([self.intelligentType isEqualToString:@"专项练习"])
    {
        [self.startButton setTitle:@"开始练习" forState:UIControlStateNormal];
    }
    [self NetworkGetType];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-44-TabbarSafeBottomMargin) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorBarGrayBackground;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    _startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 35)];
    _startButton.top = self.tableView.bottom + 4;
    _startButton.centerX = Screen_Width/2;
    [_startButton setBackgroundColor:KColorBlueText];
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
    NSDictionary *dict = self.typeList[self.selectIndex];
    if([self.intelligentType isEqualToString:@"智能组卷"])
    {
        [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
        [self NetworkGetIntelligentExamListByContent:dict[@"Name"]];
    }
    else if([self.intelligentType isEqualToString:@"专项练习"])
    {
        [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
        [self NetworkGetPractIntelligentExerciseListByQPoint:dict[@"Name"]];
    }
}

#pragma -mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
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
        if([self.intelligentType isEqualToString:@"智能组卷"])
        {
            view.label1.text = @"请选择智能组卷的考试类型";
            view.label2.text = @"并点击《开始考试》，进行考试";
        }
        else if([self.intelligentType isEqualToString:@"专项练习"])
        {
            view.label1.text = @"请选择专项练习的考点";
            view.label2.text = @"并点击《开始考试》，进行练习";
        }
        return view;
    }
    return nil;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntelligenceTypeTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, IntelligenceTypeTableViewCell, @"IntelligenceTypeTableViewCell");
    if(indexPath.row == self.selectIndex)
    {
        loc_cell.selectedImageView1.image = [UIImage imageNamed:@"choose"];
    }
    else
    {
        loc_cell.selectedImageView1.image = [UIImage imageNamed:@"椭圆"];
    }
    
    NSDictionary *dict = self.typeList[indexPath.row];
    loc_cell.IntelligenceTypeLabel.text = dict[@"Name"];
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
}

#pragma -mark Network
- (void)NetworkGetType
{
    NSString *type = @"";
    if([self.intelligentType isEqualToString:@"智能组卷"])
    {
        type = @"考试内容";
    }
    else if([self.intelligentType isEqualToString:@"专项练习"])
    {
        type = @"考点";
    }
    
    [LLRequestClass requestGetTypeByIType:type success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.typeList = [NSMutableArray arrayWithArray:contentArray];
                [self.tableView reloadData];
                return;
            }
        }
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

/**
 新建专项练习取题
 */
- (void)NetworkGetPractIntelligentExerciseListByQPoint:(NSString *)QPoint
{
    [LLRequestClass requestGetPractIntelligentExerciseListByQPoint:QPoint Success:^(id jsonData) {
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
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:QPoint];
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
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:@"智能组卷"];
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
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList ExamTitle:(NSString *)title
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
                vc.isMockExamType = @"专项练习";
                vc.isSaveUserOperation = NO;
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
