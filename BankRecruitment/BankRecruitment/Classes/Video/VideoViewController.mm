//
//  VideoViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/27.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoTableViewCell.h"
#import "VideoSelectViewController.h"
#import "VideoSubViewController.h"
#import "VideoTypeModel.h"
#import "VideoCatalogModel.h"
#import "BBAlertView.h"
#import "QuestionReportTableViewCell.h"
#import "VideoModel.h"
#import "VideoDetailViewController.h"

@interface VideoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *videoTypeList;
@property (nonatomic, strong) NSMutableArray *videoMainList;
@property (nonatomic, assign) NSInteger selectedTypeIndex;
@property (nonatomic, strong) NSMutableDictionary *mainIDAndSubValueDict;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedTypeIndex = 0;
    self.videoMainList = [NSMutableArray arrayWithCapacity:9];
    self.mainIDAndSubValueDict = [NSMutableDictionary dictionaryWithCapacity:9];
    
    [self drawViews];
    [self refreshCurrentVideoList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    
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

- (void)refreshCurrentVideoList
{
    if(self.typeModel){
        self.title = self.typeModel.VType;
        [self NetworkGetVideoMainListByType:self.typeModel.VType];
    }else if(self.remoteMessageVideoModel.VType){
        self.title = self.remoteMessageVideoModel.VType;
        [self.videoMainList removeAllObjects];
        [self.videoMainList addObject:self.remoteMessageVideoModel];
        [self.tableView reloadData];
    }
}

- (void)refreshRemoteMessageVideoList
{
    if(self.remoteMessageVideoModel){
        NSInteger selectIndex = 9999;
        for(NSInteger index=0; index< self.videoMainList.count; index++){
            VideoCatalogModel *model = self.videoMainList[index];
            if([model.cID isEqualToString:self.remoteMessageVideoModel.cID]){
                selectIndex = index;
                break;
            }
        }
        
        if(selectIndex == 9999){
            return;
        }
        
        float price = self.remoteMessageVideoModel.Price.floatValue;
        if([self.remoteMessageVideoModel.IsGet isEqualToString:@"是"] || (price == 0))
        {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = selectIndex*10000;
            [self outLineCellAction:btn];
            
            if(![self.remoteMessageVideoModel.IsGet isEqualToString:@"是"])
            {
                [self NetworkSendZeroPaySuccessByLinkID:self.remoteMessageVideoModel.cID Abstract:self.remoteMessageVideoModel.Name];
            }
        }
        else
        {
            if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
            {
                [[LdGlobalObj sharedInstanse] payActionByType:@"视频" payID:self.remoteMessageVideoModel.cID];
                [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
                    ZB_Toast(@"购买成功");
                    [self refreshCurrentVideoList];
                    
                    UIButton *btn = [[UIButton alloc] init];
                    btn.tag = selectIndex*10000;
                    [self outLineCellAction:btn];
                };
            }
            else
            {
                BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"直接购买，会为当前设备购买视频；您可以去我的页面先注册再购买" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"游客身份购买"];
                LL_WEAK_OBJC(self);
                [alertView setConfirmBlock:^{
                    [[LdGlobalObj sharedInstanse] payActionByType:@"视频" payID:self.remoteMessageVideoModel.cID];
                    [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
                        ZB_Toast(@"购买成功");
                        [weakself refreshCurrentVideoList];
                        
                        UIButton *btn = [[UIButton alloc] init];
                        btn.tag = selectIndex*10000;
                        [self outLineCellAction:btn];
                    };
                }];
                [alertView show];
            }
        }
    }
}

- (void)gotoVideoSub:(NSNumber *)index
{
    VideoSubViewController *vc = [[VideoSubViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.catalogModel = self.videoMainList[index.integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)getRowOfOutLinesByModel:(VideoCatalogModel *)model
{
    NSInteger index = 1;
    if(model.isSpread)
    {
        NSArray *array = [self.mainIDAndSubValueDict objectForKey:model.cID];
        if(array){
            index+=array.count;
        }
    }
    
    return index;
}

- (void)outLineCellAction:(UIButton *)button
{
    VideoCatalogModel *model = self.videoMainList[button.tag/10000];
    NSArray *subArray = [self.mainIDAndSubValueDict objectForKey:model.cID];
    if(!subArray){
        [self NetworkGetSubVideoListsBy:model];
    }else{
        model.isSpread = !model.isSpread;
        [self.tableView reloadData];
    }
}

#pragma -mark UITableView delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.videoMainList.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    VideoCatalogModel *model = self.videoMainList[indexPath.row];
//    VideoTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, VideoTableViewCell, @"VideoTableViewCell");
//    cell.videoLabel.text = model.Name;
//    float price = model.Price.floatValue;
//    if([model.IsGet isEqualToString:@"是"])
//    {
//        cell.priceLabel.text = @"";
//    }
//    else if((price != 0)&&([model.IsGet isEqualToString:@"否"]))
//    {
//        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.Price.floatValue];
//    }
//    else
//    {
//        cell.priceLabel.text = @"";
//    }
//
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.videoMainList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = [self getRowOfOutLinesByModel:self.videoMainList[section]];
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCatalogModel *mainModel = self.videoMainList[indexPath.section];
    NSArray *subArray = [self.mainIDAndSubValueDict objectForKey:mainModel.cID];
    VideoModel *subModel = nil;
    if(indexPath.row != 0){
        subModel = subArray[indexPath.row-1];
    }
    
    QuestionReportTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, QuestionReportTableViewCell, @"QuestionReportTableViewCell");
    [loc_cell.actionBtn setImage:nil forState:UIControlStateNormal];
    if(indexPath.row == 0){
        loc_cell.questionTitleLabel.text = mainModel.Name;
        loc_cell.actionBtn.tag = indexPath.section*10000;
        [loc_cell.actionBtn addTarget:self action:@selector(outLineCellAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        loc_cell.questionTitleLabel.text = subModel.Name;
    }
    loc_cell.questionExamButton.hidden = YES;
    loc_cell.upLineView.hidden = NO;
    loc_cell.downLineView.hidden = NO;
    loc_cell.BottomLine.hidden = YES;
    if(indexPath.row == 0)
    {
        loc_cell.upLineView.hidden = YES;
    }
    if(indexPath.row == ([tableView numberOfRowsInSection:indexPath.section]-1))
    {
        loc_cell.BottomLine.hidden = NO;
        loc_cell.downLineView.hidden = YES;
    }
    
    if(indexPath.row == 0)
    {
        if(mainModel.isSpread)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_minus"] forState:UIControlStateNormal];
        }
        else
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_add"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_circle_blue"] forState:UIControlStateNormal];
    }
    
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    VideoCatalogModel *mainModel = self.videoMainList[indexPath.section];
    NSArray *subArray = [self.mainIDAndSubValueDict objectForKey:mainModel.cID];
    VideoModel *subModel = nil;
    if(indexPath.row != 0){
        subModel = subArray[indexPath.row-1];
    }
    
    if(indexPath.row == 0){
        float price = mainModel.Price.floatValue;
        if([mainModel.IsGet isEqualToString:@"是"] || (price == 0))
        {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = indexPath.section*10000;
            [self outLineCellAction:btn];
            
            if(![mainModel.IsGet isEqualToString:@"是"])
            {
                [self NetworkSendZeroPaySuccessByLinkID:mainModel.cID Abstract:mainModel.Name];
            }
        }
        else
        {
            if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
            {
                [[LdGlobalObj sharedInstanse] payActionByType:@"视频" payID:mainModel.cID];
                [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
                    ZB_Toast(@"购买成功");
                    [self refreshCurrentVideoList];
                    
                    UIButton *btn = [[UIButton alloc] init];
                    btn.tag = indexPath.section*10000;
                    [self outLineCellAction:btn];
                };
            }
            else
            {
                BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"直接购买，会为当前设备购买视频；您可以去我的页面先注册再购买" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"游客身份购买"];
                LL_WEAK_OBJC(self);
                [alertView setConfirmBlock:^{
                    [[LdGlobalObj sharedInstanse] payActionByType:@"视频" payID:mainModel.cID];
                    [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
                        ZB_Toast(@"购买成功");
                        [weakself refreshCurrentVideoList];
                        
                        UIButton *btn = [[UIButton alloc] init];
                        btn.tag = indexPath.section*10000;
                        [self outLineCellAction:btn];
                    };
                }];
                [alertView show];
            }
        }
    }else{
        VideoDetailViewController *vc = [[VideoDetailViewController alloc] init];
        vc.videolist = subArray;
        vc.videoIndex = (int)indexPath.row-1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark Network
- (void)NetworkGetVideoMainListByType:(NSString *)type
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetVideoCatalogListByType:type Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.videoMainList removeAllObjects];
                for(NSDictionary *dict in contentArray)
                {
                    VideoCatalogModel *model = [VideoCatalogModel model];
                    [model setDataWithDic:dict];
                    [self.videoMainList addObject:model];
                }
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                return;
            }
        }
        [self.videoMainList removeAllObjects];
        [self.tableView reloadData];
        ZB_Toast(@"当前类型没有找到视频内容哦");
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [self.videoMainList removeAllObjects];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

- (void)NetworkGetSubVideoListsBy:(VideoCatalogModel *)catalogModel
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetVideoListByCatalog:catalogModel.cID Success:^(id jsonData) {
        [SVProgressHUD dismiss];
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *videoList = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    VideoModel *model = [VideoModel model];
                    [model setDataWithDic:dict];
                    [videoList addObject:model];
                }
                
                [self.mainIDAndSubValueDict setObject:videoList forKey:catalogModel.cID];
            }
            
            catalogModel.isSpread = !catalogModel.isSpread;
            [self.tableView reloadData];
            return;
        }
        
        ZB_Toast(@"没有找到视频内容哦");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 提交支付信息  价格为零时，添加到已购买的数据库
 */
- (void)NetworkSendZeroPaySuccessByLinkID:(NSString *)LinkID Abstract:(NSString *)Abstract
{
    [LLRequestClass requestSendZeroPaySuccessByLinkID:LinkID PType:@"视频" Abstract:Abstract Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self refreshCurrentVideoList];
                return;
            }
        }
    } failure:^(NSError *error) {
    }];
}

@end
