//
//  RegisterViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "RegisterViewController.h"
#import "BBAlertView.h"
#import "UserKnowViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *smsTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwdTextField;
@property (nonatomic, strong) IBOutlet UITextField *rePasswdTextField;
@property (nonatomic, strong) IBOutlet UIButton *sendSMSBtn;
@property (nonatomic, strong) IBOutlet UIButton *showPasswordButton;
@property (nonatomic, strong) IBOutlet UIButton *showRePasswordButton;
@property (nonatomic, strong) IBOutlet UIButton *isKnowUserButton;
@property (nonatomic, strong) IBOutlet UIButton *UserDetailKnowButton;

@property (nonatomic, strong) NSTimer *messageTimer;
@property (nonatomic, assign) NSInteger messageTimerIndex;
@property (nonatomic, copy) NSString *smsCodeString;
@property (nonatomic, assign) BOOL isKnowUser;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"注册";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationController.navigationBarHidden = NO;
    self.sendSMSBtn.layer.cornerRadius = 4;
    self.sendSMSBtn.layer.borderColor = UIColorFromHex(0x48d2a0).CGColor;
    self.sendSMSBtn.layer.borderWidth = 1;
    self.sendSMSBtn.layer.masksToBounds = YES;
    
    self.isKnowUser = YES;
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
    if(self.messageTimer)
    {
        [self.messageTimer invalidate];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)isKnowUserAction:(id)sender
{
    self.isKnowUser = !self.isKnowUser;
    
    if(self.isKnowUser)
    {
        [self.isKnowUserButton setImage:[UIImage imageNamed:@"zhibo_buy_select_p"] forState:UIControlStateNormal];
    }
    else
    {
        [self.isKnowUserButton setImage:[UIImage imageNamed:@"zhibo_buy_select_n"] forState:UIControlStateNormal];
    }
}

- (IBAction)knowDetailAction:(id)sender
{
    UserKnowViewController *vc = [[UserKnowViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)getSMSBtnAction:(id)sender
{
    if([self.sendSMSBtn.titleLabel.text isEqualToString:@"发送验证码"])
    {
        if(strIsNullOrEmpty(self.phoneTextField.text))
        {
            ZB_Toast(@"请输入您的手机号码");
            return;
        }
        
//        if(!(isMobileTelNum(self.phoneTextField.text)||isUnionComTelNum(self.phoneTextField.text)||isTeleComTelNum(self.phoneTextField.text)))
//        {
//            ZB_Toast(@"请输入合法的手机号码");
//            return;
//        }
        
        if(self.phoneTextField.text.length != 11)
        {
            ZB_Toast(@"请输入合法的手机号码");
            return;
        }
        
        self.sendSMSBtn.userInteractionEnabled = NO;
        self.messageTimerIndex = 60;
        self.messageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(messageTimerRefreshAction) userInfo:nil repeats:YES];
        [self.messageTimer fire];
        
        [self requestSendMessage];
    }
}

- (void)messageTimerRefreshAction
{
    self.messageTimerIndex--;
    if(self.messageTimerIndex == 0)
    {
        [self.messageTimer invalidate];
        [self.sendSMSBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.sendSMSBtn.userInteractionEnabled = YES;
    }
    else
    {
        [self.sendSMSBtn setTitle:[NSString stringWithFormat:@"%ldS", (long)self.messageTimerIndex] forState:UIControlStateNormal];
    }
}

- (IBAction)registerAction:(id)sender
{
    if(strIsNullOrEmpty(self.phoneTextField.text))
    {
        ZB_Toast(@"请输入您的手机号码");
        return;
    }
    
    if(![self.smsTextField.text isEqualToString:self.smsCodeString])
    {
        ZB_Toast(@"请输入正确的短信验证码");
        return;
    }
    
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
    
    if(!self.isKnowUser)
    {
        ZB_Toast(@"请阅读并同意用户注册协议");
        return;
    }
    
    [LLRequestClass requestRegisterByPhone:self.phoneTextField.text Password:self.passwdTextField.text success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                ZB_Toast(@"注册成功");
                if(self.messageTimer)
                {
                    [self.messageTimer invalidate];
                }
                
                [LdGlobalObj sharedInstanse].user_id = contentDict[@"uid"];
                [LdGlobalObj sharedInstanse].user_mobile = self.phoneTextField.text;
                
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *userLoginDict = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneTextField.text, @"userLoginname", self.passwdTextField.text, @"userPassword", nil];
                [defaults setObject:userLoginDict forKey:@"userLoginDict"];
                [defaults synchronize];
                
                
                
                if([LdGlobalObj sharedInstanse].loginVC.loginSuccessBlock)
                {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    [LdGlobalObj sharedInstanse].loginVC.loginSuccessBlock();
                }
                else
                {
                    TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
                    [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
                    appDelegate.window.rootViewController = homePageVC;
                    [appDelegate.window makeKeyAndVisible];
                }
                
                [self NetworkPutMsgToken];
                
                return ;
            }
            else
            {
                NSString *msg = [contentDict objectForKey:@"msg"];
                if([msg containsString:@"已经被注册"])
                {
                    BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"该手机号已注册，直接去登录呗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"去登录"];
                    LL_WEAK_OBJC(self);
                    [alertView setConfirmBlock:^{
                        [weakself backButtonPressed];
                    }];
                    [alertView setCancelBlock:^{
                        
                    }];
                    [alertView show];
                }
                else
                {
                    ZB_Toast(msg);
                }
            }
        }
    } failure:^(NSError *error) {
        ZB_Toast(@"网络失败");
    }];
}
    
- (void)requestSendMessage
{
    [LLRequestClass requestSMSByPhone:self.phoneTextField.text type:@"0" success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            NSString *msg = contentDict[@"msg"];
            if([result isEqualToString:@"success"])
            {
                NSString *code = contentDict[@"code"];
                
                self.smsCodeString = code;
                BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
                return;
            }
            else
            {
                ZB_Toast(msg);
                return;
            }
        }
        
        ZB_Toast(@"发送短信失败");
    } failure:^(NSError *error) {
        ZB_Toast(@"发送短信失败");
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
