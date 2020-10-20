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
#import "HeadImageManager.h"

@interface AccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImage *headImg;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F3F3F3"];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
         case 1:
            return 2;
        case 2:
            return 1;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        AboutTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AboutTableViewCell, @"AboutTableViewCell");
        if(indexPath.section == 0){
            loc_cell.titleCommonLabel.text = @"头像";
            if (self.headImg) {
                loc_cell.headImg.image = self.headImg;
            }
            loc_cell.titleDesLab.hidden = YES;
            loc_cell.headImg.hidden = NO;

        }else if(indexPath.section == 1){
            loc_cell.titleDesLab.hidden = NO;
                      loc_cell.headImg.hidden = YES;
            if (indexPath.row == 0) {
                loc_cell.titleCommonLabel.text = @"昵称";
                loc_cell.titleDesLab.text = [LdGlobalObj sharedInstanse].user_name;
            }else{
                loc_cell.titleCommonLabel.text = @"手机号";

                loc_cell.titleDesLab.text = [LdGlobalObj sharedInstanse].user_mobile;
            }
        }else{
            loc_cell.titleDesLab.hidden = YES;
            loc_cell.headImg.hidden = YES;
            loc_cell.titleCommonLabel.text = @"修改密码";
        }
        return loc_cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 65;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
    view.backgroundColor = [UIColor colorWithHex:@"#F3F3F3"];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if(indexPath.section == 0){
             [HeadImageManager alertUploadHeaderImageActionSheet:self type:@"mine" imageSuccess:^(UIImage *image) {
            }];
            [HeadImageManager sharedInstance].imageHandle = ^(UIImage *image) {
                 self.headImg = image;
             };
          }else if(indexPath.section == 1){
              if (indexPath.row == 0) {
                  PersonalInformationViewController *vc = [[PersonalInformationViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
              }else{}
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
