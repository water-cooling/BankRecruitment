//
//  MockExamContestViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/1.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MockExamContestViewController.h"
#import "MockExamTableViewCell.h"
#import "MockExamLearnTableViewCell.h"
#import "MockExamTitleTableViewCell.h"
#import "CourseDetailViewController.h"
#import "MockModel.h"
#import "SignMockModel.h"
#import "MockExamDetailViewController.h"

@interface MockExamContestViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *mockList;

@end

@implementation MockExamContestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mockList = [NSMutableArray arrayWithCapacity:9];
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self NetworkGetAllMockList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"模考大赛";
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

- (void)buyButtonAction:(UIButton *)button
{
    CourseDetailViewController *vc = [[CourseDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 50;
    }
    else
    {
        return 30;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mockList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MockModel *model = self.mockList[indexPath.section];
    
    if(indexPath.row == 0)
    {
        MockExamTitleTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MockExamTitleTableViewCell, @"MockExamTitleTableViewCell");
        loc_cell.examTitleLabel.text = model.Name;
        loc_cell.examNumberLabel.text = [NSString stringWithFormat:@"%@人报名", model.iCount];
        return loc_cell;
    }
    else
    {
        MockExamTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MockExamTableViewCell, @"MockExamTableViewCell");
        loc_cell.timeTitleLabel.text = @"活动时间";
        NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
        dateFmt.dateFormat = @"yyyy-MM-dd";
        NSDateFormatter* dateFmt1 = [[NSDateFormatter alloc] init];
        dateFmt1.dateFormat = @"yyyy.MM.dd";
        NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
        NSDate *EndDate = [dateFmt dateFromString:model.EndDate];
        loc_cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@", [dateFmt1 stringFromDate:BegDate], [dateFmt1 stringFromDate:EndDate]];
        return loc_cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MockModel *model = self.mockList[indexPath.section];
    MockExamDetailViewController *vc = [[MockExamDetailViewController alloc] init];
    vc.mockModelID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark Network
- (void)NetworkGetAllMockList
{
    [LLRequestClass requestdoGetAllMockBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.mockList removeAllObjects];
                for(NSDictionary *dict in contentArray)
                {
                    MockModel *model = [MockModel model];
                    [model setDataWithDic:dict];
                    [self.mockList addObject:model];
                }
                
                if(self.mockList.count == 0)
                {
                    ZB_Toast(@"暂无内容");
                }

                [self.tableView reloadData];
                return;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
