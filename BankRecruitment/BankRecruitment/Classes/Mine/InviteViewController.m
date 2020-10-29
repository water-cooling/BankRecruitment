//
//  InviteViewController.m
//  Recruitment
//
//  Created by yltx on 2020/10/19.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "InviteViewController.h"
#import "RecruitMentShareViewController.h"
@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)InviteShowClick:(UIButton *)sender {
   NSString *webpageUrl = @"http://yk.yinhangzhaopin.com/bshApp/download/index.jsp";
     RecruitMentShareViewController * shareVc = [RecruitMentShareViewController new];
             shareVc.shareTitle = @"考银行就用银行易考！";
             shareVc.shareDesTitle = @"考银行就用银行易考！";
        shareVc.onlyWeChat = YES;
          shareVc.shareWebUrl = webpageUrl;
       shareVc.hidesBottomBarWhenPushed = YES;
          [self.navigationController presentViewController:shareVc animated:YES completion:nil];
}
- (IBAction)inviteListClick:(id)sender {
    
    
}
- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
