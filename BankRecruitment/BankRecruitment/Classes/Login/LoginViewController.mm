//
//  LoginViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "GetSMSViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "BindPhoneViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton *showPasswordButton;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIButton *weixinLoginButton;
@property (nonatomic, strong) IBOutlet UILabel *moreLoginLabel;

@property (nonatomic, copy) NSString *pass;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    
    self.weixinLoginButton.layer.cornerRadius = 22;
    self.weixinLoginButton.layer.masksToBounds = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]){
        self.weixinLoginButton.hidden = NO;
        self.moreLoginLabel.hidden = NO;
    }else{
        self.weixinLoginButton.hidden = YES;
        self.moreLoginLabel.hidden = YES;
    }
    
    if(!self.loginSuccessBlock)
    {
        self.backButton.hidden = YES;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginDict = [defaults objectForKey:@"userLoginDict"];
    if(loginDict)
    {
        self.nameTextField.text = loginDict[@"userLoginname"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*微信登录
返回 中 如果 mobile 有值，则代表该用户 已经存在平台，直接转到首页即可
如果没有mobile 值，则转到手机绑定页面
 */
- (IBAction)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            ZB_Toast(@"登录失败");
            NSLog(@"%@", error);
        } else {
            UMSocialUserInfoResponse *resp = result;

            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            NSDictionary *dict = (NSDictionary *)resp.originalResponse;
            [LLRequestClass requestRegisterWXByunionid:dict[@"unionid"] nickname:dict[@"nickname"] success:^(id jsonData) {
                NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                NSLog(@"%@", contentArray);
                if(contentArray.count > 0)
                {
                    NSDictionary *contentDict = contentArray.firstObject;
                    NSString *result = [contentDict objectForKey:@"result"];
                    if([result isEqualToString:@"success"]){
                        [LdGlobalObj sharedInstanse].user_id = contentDict[@"uid"];
                        [LdGlobalObj sharedInstanse].user_mobile = contentDict[@"mobile"];
                        [LdGlobalObj sharedInstanse].user_name = contentDict[@"pet"];
                        [LdGlobalObj sharedInstanse].tech_id = contentDict[@"tech"];
                        [LdGlobalObj sharedInstanse].islive = [contentDict[@"islive"] isEqualToString:@"是"] ? YES : NO ;
                        [LdGlobalObj sharedInstanse].istecher = [contentDict[@"istecher"] isEqualToString:@"是"] ? YES : NO ;
                        [LdGlobalObj sharedInstanse].user_acc = contentDict[@"acc"];
                        [LdGlobalObj sharedInstanse].user_LastSign = contentDict[@"LastSign"];
                        [LdGlobalObj sharedInstanse].user_SignDays = contentDict[@"SignDays"];
                        
                        self.pass = contentDict[@"pass"];
                        
                        //如果没有mobile值，则转到手机绑定页面
                        if(strIsNullOrEmpty(contentDict[@"mobile"])){
                            BindPhoneViewController *vc = [[BindPhoneViewController alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            [self saveAutoLoginMes];
                            
                            if(self.loginSuccessBlock)
                            {
                                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                self.loginSuccessBlock();
                            }
                            else
                            {
                                TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
                                [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
                                appDelegate.window.rootViewController = homePageVC;
                                [appDelegate.window makeKeyAndVisible];
                            }
                            
                            [self NetworkPutMsgToken];
                        }
                    }else{
                        ZB_Toast(@"微信授权登录失败");
                    }
                }
            } failure:^(NSError *error) {
                ZB_Toast(@"登录失败");
            }];
        }
    }];
}

//微信登录后，绑定手机号，type=0的情况
- (void)saveAutoLoginMes{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userLoginDict = [NSDictionary dictionaryWithObjectsAndKeys:[LdGlobalObj sharedInstanse].user_mobile, @"userLoginname", self.pass, @"userPassword", nil];
    [defaults setObject:userLoginDict forKey:@"userLoginDict"];
    [defaults synchronize];
    
    self.pass = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backAction:(id)sender
{
    if([[LdGlobalObj sharedInstanse].user_id isEqualToString:@"0"])
    {
        [self visitorLoginAction:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)passwordShow
{
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    if(self.passwordTextField.secureTextEntry)
    {
        [self.showPasswordButton setImage:[UIImage imageNamed:@"eye_white_close"] forState:UIControlStateNormal];
    }
    else
    {
        [self.showPasswordButton setImage:[UIImage imageNamed:@"eye_white_open"] forState:UIControlStateNormal];
    }
}

- (IBAction)visitorLoginAction:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *vid = [defaults objectForKey:@"VisitorID"];
    if(!strIsNullOrEmpty(vid))
    {
        [LdGlobalObj sharedInstanse].user_id = vid;
        if(self.loginSuccessBlock)
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
            [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
            appDelegate.window.rootViewController = homePageVC;
            [appDelegate.window makeKeyAndVisible];
        }
        
        [self NetworkPutMsgToken];
        return;
    }
    
    [LLRequestClass requestGetVisitorSuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [LdGlobalObj sharedInstanse].user_id = contentDict[@"vid"];
                
                [defaults setObject:contentDict[@"vid"] forKey:@"VisitorID"];
                [defaults synchronize];
                
                if(self.loginSuccessBlock)
                {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    self.loginSuccessBlock();
                }
                else
                {
                    TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
                    [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
                    appDelegate.window.rootViewController = homePageVC;
                    [appDelegate.window makeKeyAndVisible];
                }
                
                [self NetworkPutMsgToken];
                return;
            }
            else
            {
                NSString *msg = [contentDict objectForKey:@"msg"];
                if(!strIsNullOrEmpty(msg))
                {
                    ZB_Toast(msg);
                    return;
                }
            }
        }
        
        ZB_Toast(@"登录失败");
    } failure:^(NSError *error) {
        ZB_Toast(@"网络连接失败");
    }];
}

- (IBAction)loginAction:(id)sender
{
    if(strIsNullOrEmpty(self.nameTextField.text)||strIsNullOrEmpty(self.passwordTextField.text))
    {
        ZB_Toast(@"请输入账号密码");
        return;
    }
    
    [LLRequestClass requestLoginByPhone:self.nameTextField.text Password:self.passwordTextField.text success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [LdGlobalObj sharedInstanse].user_id = contentDict[@"uid"];
                [LdGlobalObj sharedInstanse].user_mobile = contentDict[@"mobile"];
                [LdGlobalObj sharedInstanse].user_name = contentDict[@"pet"];
                [LdGlobalObj sharedInstanse].tech_id = contentDict[@"tech"];
                [LdGlobalObj sharedInstanse].islive = [contentDict[@"islive"] isEqualToString:@"是"] ? YES : NO ;
                [LdGlobalObj sharedInstanse].istecher = [contentDict[@"istecher"] isEqualToString:@"是"] ? YES : NO ;
                [LdGlobalObj sharedInstanse].user_acc = contentDict[@"acc"];
                [LdGlobalObj sharedInstanse].user_LastSign = contentDict[@"LastSign"];
                [LdGlobalObj sharedInstanse].user_SignDays = contentDict[@"SignDays"];
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *userLoginDict = [NSDictionary dictionaryWithObjectsAndKeys:self.nameTextField.text, @"userLoginname", self.passwordTextField.text, @"userPassword", nil];
                [defaults setObject:userLoginDict forKey:@"userLoginDict"];
                [defaults synchronize];
                
                if(self.loginSuccessBlock)
                {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    self.loginSuccessBlock();
                }
                else
                {
                    TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
                    [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
                    appDelegate.window.rootViewController = homePageVC;
                    [appDelegate.window makeKeyAndVisible];
                }
                
                [self NetworkPutMsgToken];
                return;
            }
            else
            {
                NSString *msg = [contentDict objectForKey:@"msg"];
                if(!strIsNullOrEmpty(msg))
                {
                    ZB_Toast(msg);
                    return;
                }
            }
        }
        
        ZB_Toast(@"账号或密码错误");
    } failure:^(NSError *error) {
        ZB_Toast(@"登录失败");
    }];
}

- (IBAction)registerAction:(id)sender
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)forgetPassword:(id)sender
{
    GetSMSViewController *vc = [[GetSMSViewController alloc] init];
    vc.getSMSType = FindPassWordType;
    [self.navigationController pushViewController:vc animated:YES];
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
