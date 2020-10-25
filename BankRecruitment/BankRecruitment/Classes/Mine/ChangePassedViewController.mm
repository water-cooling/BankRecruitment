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
    
    [self.sureBtn addTarget:self action:@selector(publishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.layer.cornerRadius = 20;
      self.sureBtn.layer.masksToBounds = YES;
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

    if(![self.NewPassedTextField.text isEqualToString:self.reTryPassedTextField.text])
    {
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"新旧密码不能一样哦" afterDelay:2.0f];
        return;
    }
    if(![self judgePassWordLegal:self.NewPassedTextField.text]){
                    ZB_Toast(@"请输入至少6-16字符，包含英文和数字");
                    return;
    }
    
    [self requestSetPasswd:self.NewPassedTextField.text];
}

#pragma mark -network
- (void)requestSetPasswd:(NSString *)pass
{
    [LLRequestClass requestResetPassWordByOldPwd:self.prePassedTextField.text NewPassword:self.NewPassedTextField.text  success:^(id jsonData) {
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

-(BOOL)judgePassWordLegal:(NSString *)str{
    
    BOOL result = false;
    if ([str length] >= 6){
        // 判断长度大于6位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:str];
    }
    return result;

}
@end
