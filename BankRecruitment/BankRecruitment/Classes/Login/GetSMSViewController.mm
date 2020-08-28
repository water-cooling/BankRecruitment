//
//  GetSMSViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "GetSMSViewController.h"
#import "ResetPasswordViewController.h"
#import "BBAlertView.h"

@interface GetSMSViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *smsTextField;
@property (nonatomic, strong) IBOutlet UIButton *sendSMSBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) NSTimer *messageTimer;
@property (nonatomic, assign) NSInteger messageTimerIndex;
@property (nonatomic, copy) NSString *smsCodeString;
@end

@implementation GetSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 20;
    self.phoneTextField.delegate = self;
    self.smsTextField.delegate = self;
    self.sendSMSBtn.layer.borderColor = KColorBlueText.CGColor;
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
          backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
          [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
          [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:backButton];
       [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.view).offset(12);
           make.top.equalTo(self.view).offset(StatusBarHeight+15);
       }];
          UILabel * typeLab = [[UILabel alloc] init];
           typeLab.font = [UIFont systemFontOfSize:16];
           typeLab.textAlignment = NSTextAlignmentCenter;
           typeLab.textColor = [UIColor colorWithHex:@"#333333"];
           typeLab.text = @"登录";
    if(self.getSMSType == FindPassWordType){
        typeLab.text = @"忘记密码";
    }else if (self.getSMSType == BindPhoneNumType){
       typeLab.text= @"绑定手机号";
    }
       [self.view addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(self.view);
           make.height.mas_equalTo(12);
           make.top.equalTo(self.view).offset(StatusBarHeight+15);
    }];
    self.smsCodeString = @"99995698e";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    NSLog(@"改变");
    //手机号码校验
        if (self.phoneTextField.text.length > 0 && self.smsTextField.text.length > 0) {
            self.submitBtn.enabled = YES;
            self.submitBtn.backgroundColor = [UIColor colorWithHex:@"#558CF4"];
        } else {
            self.submitBtn.enabled = NO;
            self.submitBtn.backgroundColor = [UIColor colorWithHex:@"#DCDCDC"];
        }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)backButtonPressed{
    if(self.messageTimer){
        [self.messageTimer invalidate];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getSMSBtnAction:(id)sender
{
    if([self.sendSMSBtn.titleLabel.text isEqualToString:@"发送验证码"])
    {
        if(strIsNullOrEmpty(self.phoneTextField.text))
        {
            [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码" duration:2.0f];
            return;
        }
        
//        if(!(isMobileTelNum(self.phoneTextField.text)||isUnionComTelNum(self.phoneTextField.text)||isTeleComTelNum(self.phoneTextField.text)))
//        {
//            [SVProgressHUD showErrorWithStatus:@"请输入合法的手机号码" duration:2.0f];
//            return;
//        }
        
        if(self.phoneTextField.text.length != 11)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入合法的手机号码" duration:2.0f];
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

- (IBAction)doneAction:(id)sender
{
    if(![self.smsTextField.text isEqualToString:self.smsCodeString])
    {
        ZB_Toast(@"请输入正确的短信验证码");
        return;
    }
    
    if(self.getSMSType == BindPhoneNumType){
        [self NetworkCheckWxRegisterPhone];
    }else{
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] init];
        vc.phone = self.phoneTextField.text;
        vc.getSMSType = self.getSMSType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestSendMessage
{
    NSString *type = @"";
    if(self.getSMSType == FindPassWordType){
        type = @"1";
    }else if(self.getSMSType == BindPhoneNumType){
        type = @"3";
    }
    [LLRequestClass requestSMSByPhone:self.phoneTextField.text type:type success:^(id jsonData) {
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

/*
 Type:0 无需设置密码
 此手机号 已存在平台，此时只需绑定 unionid
 
 Type:1 需要设置面
 此手机号码 不存在平台，需要设置密码
 */
- (void)NetworkCheckWxRegisterPhone{
    [LLRequestClass requestCheckWXBymobile:self.phoneTextField.text uid:[LdGlobalObj sharedInstanse].user_id success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            NSString *msg = [contentDict objectForKey:@"msg"];
            ZB_Toast(msg);
            if([result isEqualToString:@"success"])
            {
                NSString *type = [contentDict objectForKey:@"type"];
                [LdGlobalObj sharedInstanse].user_mobile = self.phoneTextField.text;
                if([type isEqualToString:@"0"]){
                [self NetworkPutMsgToken];

                    [[LdGlobalObj sharedInstanse].loginVC saveAutoLoginMes];
                    
                    //进入主页
                   
                    
                }else if ([type isEqualToString:@"1"]){
                    ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] init];
                    vc.phone = self.phoneTextField.text;
                    vc.getSMSType = self.getSMSType;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    } failure:^(NSError *error) {
        ZB_Toast(@"绑定手机号失败");
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
        if(self.getSMSType == FindPassWordType){
                [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
                [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
                appDelegate.window.rootViewController = homePageVC;
                [appDelegate.window makeKeyAndVisible];
                           
                       }
        
        
    } failure:^(NSError *error) {
        ZB_Toast(@"注册Token失败");
    }];
}

@end
