//
//  VideoSelectViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "HomeVideoViewController.h"
#import "VideoSelectTableViewCell.h"
#import "VideoTypeModel.h"
#import "UIImageView+WebCache.h"
#import "VideoViewController.h"
#import "VideoCatalogModel.h"

@interface HomeVideoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation HomeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawViews];
    
    [self NetworkGetVideoTypes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"视频";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor blackColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
  
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    
    UIButton *ContactServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ContactServiceButton.frame = CGRectMake(7.0f, 5.0f, 20.0f, 20.0f);
    [ContactServiceButton setImage:[UIImage imageNamed:@"zhibo_btn_zixun"] forState:UIControlStateNormal];
    [ContactServiceButton addTarget:self action:@selector(ContactServiceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ContactServiceButton];
}

- (void)backButtonPressed{
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

- (void)refreshRemoteMessageVideoListBy:(VideoCatalogModel *)model{
    VideoViewController *vc = [[VideoViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.remoteMessageVideoModel = model;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoSelectTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, VideoSelectTableViewCell, @"VideoSelectTableViewCell");
    VideoTypeModel *model = self.typeList[indexPath.row];
    cell.videoTypeLabel.text = model.VType;
    [cell.videoTypeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp, model.picture]] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
    cell.countLabel.text = [NSString stringWithFormat:@"视频:%@", model.video_num];
    cell.chapterLabel.text = [NSString stringWithFormat:@"章节:%@", model.type_num];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    VideoViewController *vc = [[VideoViewController alloc] init];
    vc.typeModel =self.typeList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    vc.hidesBottomBarWhenPushed = YES;
}

#pragma -mark Network
- (void)NetworkGetVideoTypes
{
    self.typeList = [NSMutableArray arrayWithCapacity:9];
    [LLRequestClass requestGetVideoTypeBySuccess:^(id jsonData) {
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
                    VideoTypeModel *model = [VideoTypeModel model];
                    [model setDataWithDic:dict];
                    [self.typeList addObject:model];
                }
                
                [self.tableView reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
