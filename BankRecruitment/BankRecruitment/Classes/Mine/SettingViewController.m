//
//  SettingViewController.m
//  Recruitment
//
//  Created by yltx on 2020/8/13.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountInfoTableViewCell.h"
#import "AboutViewController.h"
#import "PrivacyViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  UITableView*tableView;
@property (nonatomic, strong)UIButton *btnLogOut;
@property (nonatomic, strong)NSString *app_Version;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"设置";
    self.view.backgroundColor= [UIColor whiteColor];
NSDictionary*infoDictionary = [[NSBundle mainBundle] infoDictionary];
self.app_Version= [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.view addSubview:self.btnLogOut];
    [self.btnLogOut addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
           make.width.mas_equalTo(Screen_Width-64);
           make.height.mas_equalTo(40);
       }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnLogOut.mas_top);
    }];
}
- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --TableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * loc_cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!loc_cell) {
        loc_cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
       if (indexPath.row == 0) {
        loc_cell.textLabel.text = @"隐私协议";
       }else if(indexPath.row == 1){
           loc_cell.textLabel.text = @"缓存清理";
                
            }else if(indexPath.row == 2){
              loc_cell.textLabel.text = @"关于我们";
            }else{
                loc_cell.textLabel.text = @"版本号";
                loc_cell.detailTextLabel.text = self.app_Version;
                
            }
    loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    loc_cell.textLabel.font = [UIFont systemFontOfSize:14];
    loc_cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return loc_cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PrivacyViewController * privacyVc = [PrivacyViewController new];
        privacyVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:privacyVc animated:YES];
    }else if (indexPath.row == 1) {
        [SVProgressHUD showWithStatus:@"正在清理"];
        [self performSelector:@selector(stopClearCache) withObject:nil afterDelay:1];
    }else{
        AboutViewController *vc = [[AboutViewController alloc] init];
                          vc.hidesBottomBarWhenPushed = YES;
                          [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)stopClearCache{
    [SVProgressHUD dismissWithSuccess:@"清理完毕"];
}

-(void)loginOutClick{
    
    UIAlertController * alerView = [UIAlertController alertControllerWithTitle:@"" message:@"确定退出吗" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *aler = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
                 [self cleanUserInfo];
              }];
              
              [alerView addAction:aler];

             UIAlertAction *  cancel  = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                  
              }];
              
              [alerView addAction:cancel];
      
    [self.navigationController presentViewController:alerView animated:YES completion:nil];
}
-(void)cleanUserInfo{
    [NewRequestClass requestLogOut:nil success:^(id jsonData) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userLoginDict"];
        [defaults removeObjectForKey:@"VisitorID"];
        [defaults synchronize];
        [LdGlobalObj sharedInstanse].user_id = @"0";
        [LdGlobalObj sharedInstanse].user_mobile = @"";
        [LdGlobalObj sharedInstanse].user_name = @"";
        [LdGlobalObj sharedInstanse].user_avatar = @"";
        [LdGlobalObj sharedInstanse].tech_id = @"";
        [LdGlobalObj sharedInstanse].islive = NO;
        [LdGlobalObj sharedInstanse].islogin = NO;
        [LdGlobalObj sharedInstanse].istecher = NO;
        [LdGlobalObj sharedInstanse].user_acc = @"";
        [LdGlobalObj sharedInstanse].user_LastSign = @"";
        [LdGlobalObj sharedInstanse].user_SignDays = @"";
        [LdGlobalObj deleteUserHeadImg];
        self.tabBarController.selectedIndex = 0;
        LoginViewController *homePageVC = [[LoginViewController alloc] init];
           [LdGlobalObj sharedInstanse].loginVC = homePageVC;
           homePageVC.modalPresentationStyle = UIModalPresentationFullScreen;
        appDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homePageVC];
        [appDelegate.window makeKeyAndVisible];
    } failure:^(NSError *error) {
        ZB_Toast(@"退出登录shibai");
    }];
    
    
}
- (void)popViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UITableView *)tableView{
    if ( !_tableView ){
        _tableView                 = [[UITableView alloc] init];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.scrollEnabled   = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)btnLogOut {
    if (!_btnLogOut) {
        _btnLogOut = [[UIButton alloc] init];
        [_btnLogOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnLogOut.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnLogOut.layer.cornerRadius = 20;
        _btnLogOut.backgroundColor = KColorBlueText;
        [_btnLogOut setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    return _btnLogOut;
}

@end
