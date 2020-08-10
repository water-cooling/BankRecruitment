//
//  DataReportViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "DataReportViewController.h"
#import "AboutTableViewCell.h"
#import "PurchedModel.h"
#import "DateReportDetailViewController.h"

@interface DataReportViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation DataReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.list = [NSMutableArray arrayWithCapacity:9];
    
    [self drawViews];
    [self NetworkGetPayInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"数据报告";
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

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, AboutTableViewCell, @"AboutTableViewCell");
    PurchedModel *model = self.list[indexPath.row];
    cell.titleCommonLabel.text = model.Abstract;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PurchedModel *model = self.list[indexPath.row];
    DateReportDetailViewController *vc = [[DateReportDetailViewController alloc] init];
    vc.purchedModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark Network
- (void)NetworkGetPayInfo
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
                self.list = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    PurchedModel *model = [PurchedModel model];
                    [model setDataWithDic:dict];
                    [self.list addObject:model];
                }
                
                [self.tableView reloadData];
                return;
            }
        }
        ZB_Toast(@"数据不足，请继续多做试题");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
