//
//  MineMessageViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/5.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MineMessageViewController.h"
#import "MineMessageTableViewCell.h"
#import "MJRefresh.h"
#import "RemoteMessageModel.h"

@interface MineMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation MineMessageViewController

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
    self.title = @"我的消息";
    
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
    if(self.list.count%20 != 0)
    {
        ZB_Toast(@"没有更多内容了");
        [self endTableRefreshing];
        return;
    }
    
    [self NetworkGetMyMessageByNPage:(int)self.list.count/20+1];
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
    NSDictionary *dict = self.list[indexPath.row];
    CGSize size = [LdGlobalObj sizeWithString:dict[@"Msg"] font:[UIFont systemFontOfSize:13] width:Screen_Width-30];
    return size.height + 72;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineMessageTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MineMessageTableViewCell, @"MineMessageTableViewCell");
    NSDictionary *dict = self.list[indexPath.row];
    loc_cell.layer.cornerRadius = 4;
    loc_cell.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor colorWithHex:@"#3C3C3C"]);
    loc_cell.layer.shadowRadius = -M_PI_2;
    loc_cell.layer.shadowOffset = CGSizeMake(2.5, 0);
    loc_cell.messageTitleLabel.text = dict[@"Name"];
    loc_cell.messageDetailLabel.text = dict[@"Msg"];
    loc_cell.messageTimeLabel.text = dict[@"BegTime"];
    [loc_cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    loc_cell.moreBtn.tag = indexPath.row;
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.list[indexPath.row];
    RemoteMessageModel *model = [RemoteMessageModel model];
    model.msg = dict[@"Msg"];
    model.msgUrl = dict[@"MsgURL"];
    model.mType = dict[@"mType"];
    model.name = dict[@"Name"];
    model.linkId = dict[@"LinkID"];
    model.notify_id = dict[@"ID"];
    [[LdGlobalObj sharedInstanse] processRemoteMessage:model];
}
-(void)moreClick:(UIButton *)sender{
    NSDictionary *dict = self.list[sender.tag];
       RemoteMessageModel *model = [RemoteMessageModel model];
       model.msg = dict[@"Msg"];
       model.msgUrl = dict[@"MsgURL"];
       model.mType = dict[@"mType"];
       model.name = dict[@"Name"];
       model.linkId = dict[@"LinkID"];
       model.notify_id = dict[@"ID"];
       [[LdGlobalObj sharedInstanse] processRemoteMessage:model];
}

#pragma -mark Network
- (void)NetworkGetMyMessageByNPage:(int)NPage
{
    [LLRequestClass requestGetMyMessageByNPage:NPage tCount:20 Success:^(id jsonData) {
        NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  //json数据当中没有 \n \r \t 等制表符，当后台给出有问题时，我们需要对json数据过滤
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSData *utf8Data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSArray *contentArray = [NSJSONSerialization JSONObjectWithData:utf8Data options:0 error:&error];
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
        [self endTableRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self endTableRefreshing];
    }];
}

@end
