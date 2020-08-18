//
//  AccountInfoViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/19.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AboutTableViewCell.h"
#import "LoginViewController.h"
#import "ChangePassedViewController.h"
#import "PersonalInformationViewController.h"
#import "OrderAddressTableViewCell.h"
#import "AddressModel.h"
#import "CreateAddressViewController.h"

@interface AccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
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

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark UITableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
        return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        AboutTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AboutTableViewCell, @"AboutTableViewCell");
        if(indexPath.row == 0){
            loc_cell.titleCommonLabel.text = @"修改昵称";
        }else{
            loc_cell.titleCommonLabel.text = @"修改密码";
        }
        return loc_cell;
      
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
        if(indexPath.row == 0){
            PersonalInformationViewController *vc = [[PersonalInformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ChangePassedViewController *vc = [[ChangePassedViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
   
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:NO];
}



@end
