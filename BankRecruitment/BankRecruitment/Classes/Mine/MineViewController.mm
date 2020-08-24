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
#import "SettingViewController.h"
#import "AddressListViewController.h"
@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, MineFunctionBtnFunc>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offsetTop;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offsetTop.constant = -StatusBarHeight;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)shareToPlatformType
{
    //设置网页地址
    NSString *webpageUrl = @"http://yk.yinhangzhaopin.com/bshApp/download/index.jsp";

  RecruitMentShareViewController * shareVc = [RecruitMentShareViewController new];
          shareVc.shareTitle = @"考银行就用银行易考！";
          shareVc.shareDesTitle = @"考银行就用银行易考！";
       shareVc.shareWebUrl = webpageUrl;
    shareVc.hidesBottomBarWhenPushed = YES;
       [self.navigationController presentViewController:shareVc animated:YES completion:nil];
}

- (void)titleCommonSwitchAction:(UISwitch *)commonSwitch
{
    [LdGlobalObj sharedInstanse].isWarnExamFlag = commonSwitch.on;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:commonSwitch.on] forKey:@"KWarnLiveFlag"];
    [defaults synchronize];
}

- (void)MineFunctionBtnPressed:(NSInteger)index{
    if (index == 0){
        IntelligentPaperViewController *vc = [[IntelligentPaperViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
        SpecialExercisesViewController *vc = [[SpecialExercisesViewController alloc] init];
        vc.intelligentType = @"专项练习";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 2)
    {
        DataReportViewController *vc = [[DataReportViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 3)
    {
        WrongQuestionsViewController *vc = [[WrongQuestionsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 4)
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        if(indexPath.row == 0){
            return 220+(IS_iPhoneX ? 24:0);
    }
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
            MineFunctionBtnTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MineFunctionBtnTableViewCell, @"MineFunctionBtnTableViewCell");
            loc_cell.delegate = self;
        [loc_cell.settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
        [loc_cell.messageBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];

            loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            return loc_cell;
    }else {
       
            AccountInfoTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AccountInfoTableViewCell, @"AccountInfoTableViewCell");
       if(indexPath.row == 1){
            loc_cell.titleCommonLabel.text = @"直播课提醒";
            loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"zbtx-icon"];
       }else if(indexPath.row == 2){
                loc_cell.titleCommonLabel.text = @"我的试卷";
                loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"wdsj-icon"];
            }else if(indexPath.row == 3){
                loc_cell.titleCommonLabel.text = @"我的收藏";
                loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"sc-icon"];
            }else if(indexPath.row == 4){
                loc_cell.titleCommonLabel.text = @"我的笔记";
                loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"bj-icon"];
            }else if (indexPath.row == 5){
                loc_cell.titleCommonLabel.text = @"APP分享";
                loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"share-icon"];
            }else if (indexPath.row == 6){
                loc_cell.titleCommonLabel.text = @"收货地址";
                           loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"shdz-icon"];
            }else{
                loc_cell.titleCommonLabel.text = @"在线客服";
                loc_cell.titleCommonImageView.image = [UIImage imageNamed:@"zhibo_btn_zixun"];
            }
           return loc_cell;
    }
        return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
        if(indexPath.row == 1)
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
        }else if(indexPath.row == 5){
                [self shareToPlatformType];
        }else if(indexPath.row == 6){
            AddressListViewController *vc = [[AddressListViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 7){
           NSString *qq = @"3004628600";
           if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]]) {
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]];
           }
        }
}

-(void)settingClick{
    SettingViewController * settingVC = [[SettingViewController alloc]init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)messageClick{
    MineMessageViewController *vc = [[MineMessageViewController alloc] init];
               vc.hidesBottomBarWhenPushed = YES;
               [self.navigationController pushViewController:vc animated:YES];
    
}
@end
