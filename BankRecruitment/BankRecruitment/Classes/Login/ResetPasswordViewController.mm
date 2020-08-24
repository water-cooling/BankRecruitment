//
//  ResetPasswordViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UITextField *passwdTextField;
@property (nonatomic, strong) IBOutlet UITextField *rePasswdTextField;
@property (nonatomic, strong) IBOutlet UIButton *showPasswordButton;
@property (nonatomic, strong) IBOutlet UIButton *showRePasswordButton;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(self.getSMSType == FindPassWordType){
        self.title = @"找回密码";
    }else if (self.getSMSType == BindPhoneNumType){
        self.title = @"设置密码";
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)passwordShow
{
    self.passwdTextField.secureTextEntry = !self.passwdTextField.secureTextEntry;
    self.rePasswdTextField.secureTextEntry = !self.rePasswdTextField.secureTextEntry;
    if(self.passwdTextField.secureTextEntry)
    {
        [self.showPasswordButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
        [self.showRePasswordButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    }
    else
    {
        [self.showPasswordButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
        [self.showRePasswordButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
    }
}

- (IBAction)repasswordShow
{
    self.passwdTextField.secureTextEntry = !self.passwdTextField.secureTextEntry;
    self.rePasswdTextField.secureTextEntry = !self.rePasswdTextField.secureTextEntry;
    if(self.passwdTextField.secureTextEntry)
    {
        [self.showPasswordButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
        [self.showRePasswordButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    }
    else
    {
        [self.showPasswordButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
        [self.showRePasswordButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
    }
}

- (IBAction)doneAction:(id)sender
{
    if(strIsNullOrEmpty(self.passwdTextField.text))
    {
        ZB_Toast(@"请输入密码");
        return;
    }
    
    if(![self.passwdTextField.text isEqualToString:self.rePasswdTextField.text])
    {
        ZB_Toast(@"密码验证不一致");
        return;
    }
    
    if(self.passwdTextField.text.length < 6 || self.passwdTextField.text.length > 16)
    {
        ZB_Toast(@"密码格式非法");
        return;
    }
    
    [self requestResetPasword];
}

- (void)requestResetPasword
{
    [LLRequestClass requestFindPasswordByPhone:self.phone Password:self.passwdTextField.text success:^(id jsonData) {
        
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                if(self.getSMSType == FindPassWordType){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else if (self.getSMSType == BindPhoneNumType){
                    
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    NSDictionary *userLoginDict = [NSDictionary dictionaryWithObjectsAndKeys:self.phone, @"userLoginname", self.passwdTextField.text, @"userPassword", nil];
                    [defaults setObject:userLoginDict forKey:@"userLoginDict"];
                    [defaults synchronize];                  
                        TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
                        [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
                        appDelegate.window.rootViewController = homePageVC;
                        [appDelegate.window makeKeyAndVisible];
                    
                    [self NetworkPutMsgToken];
                }
                return;
            }
            else
            {
                NSString *msg = [contentDict objectForKey:@"msg"];
                ZB_Toast(msg);
            }
        }
        
        ZB_Toast(@"设置密码失败");
    } failure:^(NSError *error) {
        ZB_Toast(@"设置密码失败");
    }];
}

- (void)NetworkPutMsgToken
{
    [LLRequestClass requestdoPutMsgTokenBytoken:[LdGlobalObj sharedInstanse].deviceToken Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSLog(@"deviceToken Update success");
            }
        }
    } failure:^(NSError *error) {
        ZB_Toast(@"注册Token失败");
    }];
}

@end
