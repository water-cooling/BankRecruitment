//
//  VideoSubViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "VideoSubViewController.h"
#import "VideoSubTableViewCell.h"
#import "VideoDetailViewController.h"
#import "VideoModel.h"
#import "VideoTableViewCell.h"

@interface VideoSubViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videolist;
@end

@implementation VideoSubViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videolist = [NSMutableArray arrayWithCapacity:9];
    self.title = self.catalogModel.Name;
    [self drawViews];
    [self NetworkGetVideoLists];
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
    
    UIView *ContactServiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 40)];
    UILabel *ContactServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 34, 10)];
    ContactServiceLabel.backgroundColor = [UIColor clearColor];
    ContactServiceLabel.textColor = [UIColor whiteColor];
    ContactServiceLabel.font = [UIFont systemFontOfSize:10];
    ContactServiceLabel.textAlignment = NSTextAlignmentCenter;
    ContactServiceLabel.text = @"客服";
    [ContactServiceView addSubview:ContactServiceLabel];
    
    UIButton *ContactServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ContactServiceButton.frame = CGRectMake(7.0f, 5.0f, 20.0f, 20.0f);
    [ContactServiceButton setImage:[UIImage imageNamed:@"zhibo_btn_zixun"] forState:UIControlStateNormal];
    [ContactServiceButton addTarget:self action:@selector(ContactServiceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [ContactServiceView addSubview:ContactServiceButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ContactServiceView];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ContactServiceButtonPressed
{
    NSString *qq = @"3004628600";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]];
    }
    else
    {
        ZB_Toast(@"尚未检测到相关客户端，咨询失败");
    }
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videolist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoSubTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, VideoSubTableViewCell, @"VideoSubTableViewCell");
//
    VideoModel *video = self.videolist[indexPath.row];
    cell.videoTitleLabel.text = video.Name;
    
//    VideoTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, VideoTableViewCell, @"VideoTableViewCell");
//    cell.videoLabel.text = video.Name;
//    cell.priceLabel.text = @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    VideoDetailViewController *vc = [[VideoDetailViewController alloc] init];
    vc.videolist = self.videolist;
    vc.videoIndex = (int)indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark Network
- (void)NetworkGetVideoLists
{
    [LLRequestClass requestGetVideoListByCatalog:self.catalogModel.cID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                for(NSDictionary *dict in contentArray)
                {
                    VideoModel *model = [VideoModel model];
                    [model setDataWithDic:dict];
                    [self.videolist addObject:model];
                }
            }
            
            [self.tableView reloadData];
            return;
        }
        
        ZB_Toast(@"没有找到视频内容哦");
    } failure:^(NSError *error) {
        
    }];
}
@end
