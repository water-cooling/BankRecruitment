//
//  NewsViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/30.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import "PurchedModel.h"
#import "WrongQuestionsSheetViewController.h"
#import "WrongTreeViewController.h"
#import "InformationModel.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "InformationDetailViewController.h"


@interface InformationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.list = [NSMutableArray arrayWithCapacity:9];
    
    [self drawViews];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, Screen_Height-TabbarSafeBottomMargin-StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.tableView.backgroundColor = kColorBarGrayBackground;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    [self setupTableViewRefresh];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 开始进入刷新状态
- (void)setupTableViewRefresh
{
    __weak typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
       MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
       self.tableView.mj_header = header;
       self.tableView.mj_footer = footer;
    [self headerRereshing];
}

- (void)headerRereshing
{
    [self NetworkGetNewsBy:1];
}

- (void)footerRereshing
{
    if(self.list.count%10 != 0)
    {
        ZB_Toast(@"没有更多内容了");
        [self endTableRefreshing];
        return;
    }
    
    [self NetworkGetNewsBy:(int)self.list.count/10+1];
}

- (void)endTableRefreshing
{
    [self.tableView.mj_header endRefreshing];
       
           // 拿到当前的上拉刷新控件，结束刷新状态
           [self.tableView.mj_footer endRefreshing];
  
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, InformationTableViewCell, @"InformationTableViewCell");
    InformationModel *model = self.list[indexPath.row];
    [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp, model.Screen]] placeholderImage:[UIImage imageNamed:@"Info_Default"] completed:nil];
    cell.newsTitleLabel.text = model.Name;
    cell.newsTimeLabel.text = model.CreateDate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    InformationModel *model = self.list[indexPath.row];
    
    InformationDetailViewController *vc = [[InformationDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark Network
- (void)NetworkGetNewsBy:(int)page
{
    [LLRequestClass requestGetNewsByType:self.title NPage:page Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *examList = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    InformationModel *model = [InformationModel model];
                    [model setDataWithDic:dict];
                    [examList addObject:model];
                }
                
                if(page == 1)
                {
                    [self.list removeAllObjects];
                }
                
                [self.list addObjectsFromArray:examList];
                [self.tableView reloadData];
                [self endTableRefreshing];
                [SVProgressHUD dismiss];
                return;
            }
        }
        [self endTableRefreshing];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self endTableRefreshing];
        [SVProgressHUD dismiss];
    }];
}

@end
