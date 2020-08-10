//
//  ZhaopinViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ZhaopinViewController.h"
#import "ZhaopinTableViewCell.h"
#import "MJRefresh.h"
#import "RemoteMessageModel.h"
#import "WebViewController.h"

@interface ZhaopinViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ZhaopinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
    [self setupTableViewRefresh];
    [self NetworkGetMyMessageByNPage:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"招聘";
    
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

#pragma mark 开始进入刷新状态
- (void)setupTableViewRefresh
{
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf footerRereshing];
    }];
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf headerRereshing];
    }];
    
    [self headerRereshing];
    self.tableView.footer.hidden = NO;
}

- (void)headerRereshing
{
    [self NetworkGetMyMessageByNPage:1];
}

- (void)footerRereshing
{
    if(self.list.count%10 != 0)
    {
        ZB_Toast(@"没有更多内容了");
        [self endTableRefreshing];
        return;
    }
    
    [self NetworkGetMyMessageByNPage:(int)self.list.count/10+1];
}

- (void)endTableRefreshing
{
    if(self.tableView.header.isRefreshing)
    {
        [self.tableView.header endRefreshing];
    }
    
    if(self.tableView.footer.isRefreshing)
    {
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
    }
    
    if(self.list.count%20 == 0)
    {
        self.tableView.footer.loadMoreButton.hidden = NO;
    }
    else
    {
        self.tableView.footer.loadMoreButton.hidden = YES;
    }
    
    if(self.list.count == 0)
    {
        self.tableView.footer.loadMoreButton.hidden = YES;
    }
}

#pragma -mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZhaopinTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ZhaopinTableViewCell, @"ZhaopinTableViewCell");
    NSDictionary *dict = self.list[indexPath.row];
    loc_cell.ZhaopinTitleLabel.text = dict[@"title"];
    loc_cell.ZhaopinTimeLabel.text = dict[@"senddate"];
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.list[indexPath.row];
    
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlString = dict[@"linkurl"];
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"招聘详情";
}

#pragma -mark Network
- (void)NetworkGetMyMessageByNPage:(int)NPage
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetZhaopinByNPage:NPage tCount:10 Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                if(NPage == 1)
                {
                    self.list = [NSMutableArray arrayWithArray:contentArray];
                }
                else
                {
                    [self.list addObjectsFromArray:contentArray];
                }
                [self.tableView reloadData];
            }
        }
        [SVProgressHUD dismiss];
        [self endTableRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
        [self endTableRefreshing];
    }];
}

@end
