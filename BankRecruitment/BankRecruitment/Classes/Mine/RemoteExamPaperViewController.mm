//
//  RemoteExamPaperViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/4.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "RemoteExamPaperViewController.h"
#import "ExamDetailModel.h"
#import "ExaminationTitleModel.h"
#import "DailyPracticeViewController.h"
#import "ExaminationPaperModel.h"
#import "ExaminationPaperWithoutTableViewCell.h"
#import "ExaminationPaperTableViewCell.h"
#import "ExamDetailViewController.h"
#import "DataBaseManager.h"
#import "BBAlertView.h"

@interface RemoteExamPaperViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *examList;
@end

@implementation RemoteExamPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"推送试卷";
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;    
    self.examList = [NSMutableArray arrayWithCapacity:9];
    [self.examList addObject:self.paperModel];
    [self.tableView reloadData];
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

#pragma -mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExaminationPaperModel *model = self.examList[indexPath.row];
    if(![model.IsGet isEqualToString:@"是"]&&(model.Price.floatValue != 0))
    {
        return 118;
    }
    else
    {
        return 79;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.examList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExaminationPaperModel *model = self.examList[indexPath.row];
    if(![model.IsGet isEqualToString:@"是"]&&(model.Price.floatValue != 0))
    {
        ExaminationPaperTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ExaminationPaperTableViewCell, @"ExaminationPaperTableViewCell");
        loc_cell.ExaminationPaperTitleLabel.text = model.Name;
        float price = model.Price.floatValue;
        if((price == 0)||([model.IsGet isEqualToString:@"是"]))
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
    else
    {
        ExaminationPaperWithoutTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ExaminationPaperWithoutTableViewCell, @"ExaminationPaperWithoutTableViewCell");
        loc_cell.ExaminationPaperTitleLabel.text = model.Name;
        
        NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
        dateFmt.dateFormat = @"yyyy-MM-dd";
        NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
        NSDate *EndDate = [dateFmt dateFromString:model.EndDate];
        NSDateFormatter* dateFmt1 = [[NSDateFormatter alloc] init];
        dateFmt1.dateFormat = @"yyyy.MM.dd";
        loc_cell.ExaminationPaperClassPlanLabel.text = [NSString stringWithFormat:@"课程安排：%@-%@",[dateFmt1 stringFromDate:BegDate], [dateFmt1 stringFromDate:EndDate]];
        return loc_cell;
    }
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
                vc.title = self.title;
                vc.isSaveUserOperation = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self NetworkGetExamTitlesByEID:model.ID ExamTitle:self.title];                    }
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
                        [self NetworkGetExamTitlesByEID:LinkID ExamTitle:self.title];                    }
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
@end
