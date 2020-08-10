//
//  MineViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/27.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MineViewController.h"
#import "AccountInfoTableViewCell.h"
#import "LiveWarnTableViewCell.h"
#import "AboutTableViewCell.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "AccountInfoViewController.h"
#import "CollectionQuestionViewController.h"
#import "MineMessageViewController.h"
#import "ExerciseHositoryViewController.h"
#import "NoteQuestionViewController.h"
#import "WrongQuestionsViewController.h"
#import "DataReportViewController.h"
#import "MineFunctionBtnTableViewCell.h"
#import "SpecialExercisesViewController.h"
#import "IntelligentPaperViewController.h"
#import "LianxiHisViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, MineFunctionBtnFunc>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *moduleList;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moduleList = @[@{@"title":@"智能组卷",@"path":@"nav_zhinengzujuan"},
                        @{@"title":@"专项练习",@"path":@"nav_zhinenglianxi"},
                        @{@"title":@"数据报告",@"path":@"nav_shuju"},
                        @{@"title":@"错题本",@"path":@"nav_cuotiben"},
                        @{@"title":@"练习历史",@"path":@"nav_lianxilishi"}];
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    self.title = @"我的";
}

- (void)shareToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"考银行就用银行易考！" descr:@"考银行就用银行易考！" thumImage:[UIImage imageNamed:@"shareIcon.png"]];
    //设置网页地址
    shareObject.webpageUrl = @"http://yk.yinhangzhaopin.com/bshApp/download/index.jsp";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

- (void)titleCommonSwitchAction:(UISwitch *)commonSwitch
{
    [LdGlobalObj sharedInstanse].isWarnExamFlag = commonSwitch.on;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:commonSwitch.on] forKey:@"KWarnLiveFlag"];
    [defaults synchronize];
}

- (void)MineFunctionBtnPressed:(NSInteger)index
{
    NSDictionary *dict = self.moduleList[index];
    NSString *title = dict[@"title"];
    if ([title isEqualToString:@"智能组卷"])
    {
        IntelligentPaperViewController *vc = [[IntelligentPaperViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"专项练习"])
    {
        SpecialExercisesViewController *vc = [[SpecialExercisesViewController alloc] init];
        vc.intelligentType = title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"数据报告"])
    {
        DataReportViewController *vc = [[DataReportViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"错题本"])
    {
        WrongQuestionsViewController *vc = [[WrongQuestionsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"练习历史"])
    {
        LianxiHisViewController *vc = [[LianxiHisViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"练习历史";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)hiddenSVProgressHUD
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"清理完成" duration:kHttpRequestFailedShowTime];
}

- (void)transitionVistorToNomalByPre:(NSString *)preUserID
{
    [LLRequestClass requestUpdateVisitorByVid:preUserID uid:[LdGlobalObj sharedInstanse].user_id Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"VisitorID"];
                [defaults synchronize];
                
                ZB_Toast(@"登录成功");
                return;
            }
            else
            {
                NSString *msg = [contentDict objectForKey:@"msg"];
                if(!strIsNullOrEmpty(msg))
                {
                    ZB_Toast(msg);
                    return;
                }
            }
        }
        
        ZB_Toast(@"登录失败");
    } failure:^(NSError *error) {
        ZB_Toast(@"网络连接失败");
    }];
}

- (void)stopClearCache{
    [SVProgressHUD dismissWithSuccess:@"清理完毕"];
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
    footerView.backgroundColor = kColorBarGrayBackground;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            return 90;
        }
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    else if(section == 1)
    {
        return 5;
    }
    else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            MineFunctionBtnTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MineFunctionBtnTableViewCell, @"MineFunctionBtnTableViewCell");
            
            loc_cell.functionBtnDictLists = self.moduleList;
            loc_cell.delegate = self;
            loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [loc_cell setupFunctionsPage:nil];
            return loc_cell;
        }
        else
        {
            AccountInfoTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AccountInfoTableViewCell, @"AccountInfoTableViewCell");
            if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
            {
                loc_cell.titleCommonLabel.text = @"账号信息";
            }
            else
            {
                loc_cell.titleCommonLabel.text = @"请登录/注册，以免您的信息丢失";
            }
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"home_icon_my"];
            return loc_cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            AccountInfoTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AccountInfoTableViewCell, @"AccountInfoTableViewCell");
            loc_cell.titleCommonLabel.text = @"我的消息";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"p_icon_message"];
            return loc_cell;
        }
        else if(indexPath.row == 1)
        {
            LiveWarnTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, LiveWarnTableViewCell, @"LiveWarnTableViewCell");
            cell.titleCommonSwitch.on = [LdGlobalObj sharedInstanse].isWarnExamFlag;
            [cell.titleCommonSwitch addTarget:self action:@selector(titleCommonSwitchAction:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
        else if(indexPath.row == 2)
        {
            AccountInfoTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AccountInfoTableViewCell, @"AccountInfoTableViewCell");
            loc_cell.titleCommonLabel.text = @"我的试卷";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"icon_lishijilu"];
            return loc_cell;
        }
        else if(indexPath.row == 3)
        {
            AccountInfoTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AccountInfoTableViewCell, @"AccountInfoTableViewCell");
            loc_cell.titleCommonLabel.text = @"我的收藏";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"p_icon_collect"];
            return loc_cell;
        }
        else if(indexPath.row == 4)
        {
            AccountInfoTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AccountInfoTableViewCell, @"AccountInfoTableViewCell");
            loc_cell.titleCommonLabel.text = @"我的笔记";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"icon_biji"];
            return loc_cell;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        AccountInfoTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AccountInfoTableViewCell, @"AccountInfoTableViewCell");
        
        if(indexPath.row == 0)
        {
            loc_cell.titleCommonLabel.text = @"在线客服";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"p_icon_kefu"];
        }
        else if (indexPath.row == 1)
        {
            loc_cell.titleCommonLabel.text = @"APP分享";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"p_icon_share"];
        }
        else if(indexPath.row == 2)
        {
            loc_cell.titleCommonLabel.text = @"缓存清理";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"clearCahche"];
        }
        else
        {
            loc_cell.titleCommonLabel.text = @"关于";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"p_icon_about"];
        }
        return loc_cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0)
    {
        if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
        {
            AccountInfoViewController *vc = [[AccountInfoViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            NSString *preUserID = [LdGlobalObj sharedInstanse].user_id;
            [LdGlobalObj sharedInstanse].loginVC = [[LoginViewController alloc] init];
            [LdGlobalObj sharedInstanse].loginVC.loginSuccessBlock = ^(void){
                //迁移权益
                [self transitionVistorToNomalByPre:preUserID];
            };
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LdGlobalObj sharedInstanse].loginVC] animated:YES completion:nil];
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            MineMessageViewController *vc = [[MineMessageViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 2)
        {
            ExerciseHositoryViewController *vc = [[ExerciseHositoryViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 3)
        {
            CollectionQuestionViewController *vc = [[CollectionQuestionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 4)
        {
            NoteQuestionViewController *vc = [[NoteQuestionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
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
        else if(indexPath.row == 1)
        {
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                [self shareToPlatformType:platformType];
            }];
        }
        else if(indexPath.row == 2)
        {
            [SVProgressHUD showWithStatus:@"正在清理"];
            [self performSelector:@selector(stopClearCache) withObject:nil afterDelay:1];
        }
        else if(indexPath.row == 3)
        {
            AboutViewController *vc = [[AboutViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
