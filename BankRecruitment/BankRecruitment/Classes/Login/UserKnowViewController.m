//
//  UserKnowViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/8/9.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "UserKnowViewController.h"

@interface UserKnowViewController ()
@property (nonatomic, strong) IBOutlet UITextView *textView;
@end

@implementation UserKnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"注册须知";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.textView setContentOffset:CGPointZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
