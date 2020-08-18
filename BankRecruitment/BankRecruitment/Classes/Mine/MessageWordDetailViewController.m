//
//  MessageWordDetailViewController.m
//  Recruitment
//
//  Created by 夏建清 on 2018/5/31.
//  Copyright © 2018年 LongLian. All rights reserved.
//

#import "MessageWordDetailViewController.h"

@interface MessageWordDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation MessageWordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息详情";
    // Do any additional setup after loading the view from its nib.
    self.appTitleLab.text = self.model.name;
    self.textView.text = self.model.msg;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
