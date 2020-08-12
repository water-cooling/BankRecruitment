//
//  BindPhoneViewController.m
//  Recruitment
//
//  Created by 夏建清 on 2018/5/29.
//  Copyright © 2018年 LongLian. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "GetSMSViewController.h"

@interface BindPhoneViewController ()

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"银行易考";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bindAction:(id)sender{
    GetSMSViewController *vc = [[GetSMSViewController alloc] init];
    vc.getSMSType = BindPhoneNumType;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
