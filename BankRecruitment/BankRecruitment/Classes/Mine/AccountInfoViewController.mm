//
//  AccountInfoViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/19.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AboutTableViewCell.h"
#import "QuitLoginTableViewCell.h"
#import "LoginViewController.h"
#import "ChangePassedViewController.h"
#import "PersonalInformationViewController.h"
#import "OrderAddressTableViewCell.h"
#import "AddressModel.h"
#import "CreateAddressViewController.h"

@interface AccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AddressModel *addressModel;
@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self NetworkGetAddress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"账号信息";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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
        return 70;
    }
    else
    {
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        OrderAddressTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, OrderAddressTableViewCell, @"OrderAddressTableViewCell");
        if(!self.addressModel)
        {
            cell.nameLabel.hidden = YES;
            cell.phoneLabel.hidden = YES;
            cell.addressLabel.hidden = YES;
            cell.createAddressLabel.hidden = NO;
        }
        else
        {
            cell.nameLabel.hidden = NO;
            cell.phoneLabel.hidden = NO;
            cell.addressLabel.hidden = NO;
            cell.createAddressLabel.hidden = YES;
            cell.nameLabel.text = self.addressModel.Name;
            cell.phoneLabel.text = self.addressModel.Tel;
            cell.addressLabel.text = self.addressModel.Addr;
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        AboutTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AboutTableViewCell, @"AboutTableViewCell");
        if(indexPath.row == 0)
        {
            loc_cell.titleCommonLabel.text = @"修改昵称";
        }
        else
        {
            loc_cell.titleCommonLabel.text = @"修改密码";
        }
        return loc_cell;
    }
    else
    {
            QuitLoginTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, QuitLoginTableViewCell, @"QuitLoginTableViewCell");
            return loc_cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 0)
    {
        CreateAddressViewController *vc = [[CreateAddressViewController alloc] init];
        vc.addressModel = self.addressModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            PersonalInformationViewController *vc = [[PersonalInformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            ChangePassedViewController *vc = [[ChangePassedViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(indexPath.section == 2)
    {
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
        return;
    }
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)NetworkGetAddress
{
    [LLRequestClass requestGetAddressBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.addressModel = [AddressModel model];
                [self.addressModel setDataWithDic:contentDict];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
