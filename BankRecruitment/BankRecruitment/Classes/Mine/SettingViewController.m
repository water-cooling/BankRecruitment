//
//  SettingViewController.m
//  Recruitment
//
//  Created by yltx on 2020/8/13.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountInfoTableViewCell.h"
#import "AccountInfoViewController.h"
#import "AboutViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  UITableView*tableView;
@property (nonatomic, strong)UIButton *btnLogOut;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(136);
    }];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.view addSubview:self.btnLogOut];
    [self.btnLogOut addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom).offset(83.5);
           make.width.mas_equalTo(Screen_Width-64);
           make.height.mas_equalTo(40);
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * loc_cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!loc_cell) {
        loc_cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
               if(indexPath.row == 0){
                loc_cell.textLabel.text = @"账号信息";
            }else if(indexPath.row == 1){
                loc_cell.textLabel.text = @"缓存数据";
            }else {
                loc_cell.textLabel.text = @"关于我们";
            }
    return loc_cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AccountInfoViewController *vc = [[AccountInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
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
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userLoginDict"];
    [defaults removeObjectForKey:@"VisitorID"];
    [defaults synchronize];
    
    [LdGlobalObj sharedInstanse].user_id = @"0";
    [LdGlobalObj sharedInstanse].user_mobile = @"";
    [LdGlobalObj sharedInstanse].user_name = @"";
    [LdGlobalObj sharedInstanse].tech_id = @"";
    [LdGlobalObj sharedInstanse].islive = NO;
    [LdGlobalObj sharedInstanse].istecher = NO;
    [LdGlobalObj sharedInstanse].user_acc = @"";
    [LdGlobalObj sharedInstanse].user_LastSign = @"";
    [LdGlobalObj sharedInstanse].user_SignDays = @"";

    [LdGlobalObj sharedInstanse].loginVC = [[LoginViewController alloc] init];
    [LdGlobalObj sharedInstanse].loginVC.loginSuccessBlock = ^(void){};
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LdGlobalObj sharedInstanse].loginVC] animated:YES completion:nil];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.5];
}
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (UITableView *)tableView{
    if ( !_tableView ){
        _tableView                 = [[UITableView alloc] init];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.scrollEnabled   = NO;
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
