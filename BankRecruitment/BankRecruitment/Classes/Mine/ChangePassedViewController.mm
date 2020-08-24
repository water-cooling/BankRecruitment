//
//  ChangePassedViewController.m
//  Bzisland
//
//  Created by xiajianqing  on 15/4/11.
//  Copyright (c) 2015年 cstor. All rights reserved.
//

#import "ChangePassedViewController.h"
#import "LdCommon.h"
#import "LoginViewController.h"

@implementation ChangePassedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改密码";
    
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 30.0f);
    [publishButton setTitle:@"完成" forState:UIControlStateNormal];
    publishButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [publishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    publishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [publishButton addTarget:self action:@selector(publishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)publishButtonPressed
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userLoginDict = [defaults objectForKey:@"userLoginDict"];
    NSString *passwd = [userLoginDict objectForKey:@"userPassword"];
    
    if(strIsNullOrEmpty(self.prePassedTextField.text)||strIsNullOrEmpty(self.NewPassedTextField.text)||strIsNullOrEmpty(self.reTryPassedTextField.text))
    {
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"请输入原始密码和新密码" afterDelay:2.0f];
        return;
    }
    
    if(![passwd isEqualToString:self.prePassedTextField.text])
    {
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"原始密码错误" afterDelay:2.0f];
        return;
    }
    
    if(![self.NewPassedTextField.text isEqualToString:self.reTryPassedTextField.text])
    {
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"新旧密码不能一样哦" afterDelay:2.0f];
        return;
    }
    
    [self requestSetPasswd:self.NewPassedTextField.text];
}

#pragma mark -network
- (void)requestSetPasswd:(NSString *)pass
{
    [LLRequestClass requestResetPassWordByPassword:pass success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                ZB_Toast(@"修改成功");
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *userLoginDict = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"userLoginDict"]];
                [userLoginDict setObject:self.NewPassedTextField.text forKey:@"userPassword"];
                [defaults setObject:userLoginDict forKey:@"userLoginDict"];
                [defaults synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
