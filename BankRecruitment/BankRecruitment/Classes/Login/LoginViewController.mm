//
//  NewLoginViewController.m
//  Recruitment
//
//  Created by yltx on 2020/8/12.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterView.h"
#import "BindPhoneViewController.h"
#import "GetSMSViewController.h"
#import "BBAlertView.h"
#import "UserKnowViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <objc/runtime.h>

@interface LoginViewController ()<ASAuthorizationControllerDelegate,ASWebAuthenticationPresentationContextProviding>
@property (nonatomic, strong) UIImageView *imgLogo;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UIButton *btnRegister;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) RegisterView *registView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString *pass;
@property (nonatomic, strong) NSTimer *messageTimer;
@property (nonatomic, assign) NSInteger messageTimerIndex;
@property (nonatomic, copy) NSString *smsCodeString;
@property (nonatomic, assign) BOOL isKnowUser;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    [self initUI];
    
    self.isLogin = YES;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self. navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self. navigationController.navigationBar setHidden:NO];
}

-(void)initUI{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
       backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    backButton.hidden = YES;
       [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
       [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(StatusBarHeight+15);
    }];
        self.typeLab = [[UILabel alloc] init];
        self.typeLab.font = [UIFont systemFontOfSize:16];
        self.typeLab.textAlignment = NSTextAlignmentCenter;
        self.typeLab.textColor = [UIColor colorWithHex:@"#333333"];
        self.typeLab.text = @"登录";
    [self.view addSubview:self.typeLab];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(StatusBarHeight+15);
    }];
        self.imgLogo = [[UIImageView alloc] init];
        self.imgLogo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:self.imgLogo];
           [_imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
               make.centerX.equalTo(self.view.mas_centerX);
               make.top.equalTo(self.typeLab.mas_bottom).offset(35.5);
               make.width.mas_equalTo(61);
               make.height.mas_equalTo(61);
    }];
    [self.view addSubview:self.btnLogin];
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(-47);
        make.top.equalTo(self.imgLogo.mas_bottom).offset(38);

    }];
    [self.view addSubview:self.btnRegister];
    [self.btnRegister mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.view.mas_centerX).offset(47);
          make.top.equalTo(self.imgLogo.mas_bottom).offset(38);
      }];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = KColorBlueText;
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btnLogin);
        make.top.equalTo(self.btnLogin.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(12, 2));
    }];
    self.loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 180+StatusBarHeight, Screen_Width, Screen_Height-StatusBarHeight-180)];
    [self.loginView.btnWeChat addTarget:self action:@selector(weChatAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.btnApple addTarget:self action:@selector(appleAuth) forControlEvents:UIControlEventTouchUpInside];

    [self.loginView.btnLogin addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.btnForget addTarget:self action:@selector(forgerPwdAction) forControlEvents:UIControlEventTouchUpInside];

    self.registView = [[RegisterView alloc]initWithFrame:CGRectMake(Screen_Width, 180+StatusBarHeight, Screen_Width, Screen_Height-180-StatusBarHeight)];
    [self.registView.btnRegist addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [self.registView.btnValidCode addTarget:self action:@selector(validcodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.registView.ruleBtn addTarget:self action:@selector(rulerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.registView.ruleselectBtn addTarget:self action:@selector(rulerSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registView];
    [self.view addSubview:self.loginView];
}

-(void)changeType:(UIButton *)sender{
    if ([sender isEqual:self.btnLogin]) {
        if (!self.isLogin) {
            self.btnLogin.selected = !self.btnLogin.selected;
            self.btnRegister.selected = !self.btnRegister.selected;
           self.typeLab.text = @"登录";
            [UIView animateWithDuration:0.2 animations:^{
               [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                               make.centerX.equalTo(self.btnLogin);
                   make.top.equalTo(self.btnLogin.mas_bottom).offset(2);
                   make.size.mas_equalTo(CGSizeMake(12, 2));

                    }];
                self.loginView.xl_x = 0;
                self.registView.xl_x = Screen_Width;

            }];
            self.isLogin = !self.isLogin;
            
        }
    }else{
      if (self.isLogin) {
                self.btnLogin.selected = !self.btnLogin.selected;
                 self.btnRegister.selected = !self.btnRegister.selected;
            self.typeLab.text = @"注册";
          [UIView animateWithDuration:0.2 animations:^{
              [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.centerX.equalTo(self.btnRegister);
                  make.top.equalTo(self.btnRegister.mas_bottom).offset(2);
                  make.size.mas_equalTo(CGSizeMake(12, 2));

              }];
                        self.loginView.xl_x = Screen_Width;
                        self.registView.xl_x = 0;
            }];
            self.isLogin = !self.isLogin;
        }
        
    }
    [self.view setNeedsLayout];

}

#pragma mark --UIuttonClick
-(void)forgerPwdAction{
    GetSMSViewController *vc = [[GetSMSViewController alloc] init];
       vc.getSMSType = FindPassWordType;
       [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)loginAction{
    if(strIsNullOrEmpty(self.loginView.phoneTextField.text)||strIsNullOrEmpty(self.loginView.pwdTextField.text))
    {
        ZB_Toast(@"请输入账号密码");
        return;
    }
    [LLRequestClass requestLoginByPhone:self.loginView.phoneTextField.text Password:self.loginView.pwdTextField.text success:^(id jsonData) {
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
                [LdGlobalObj sharedInstanse].islogin = YES;
                [LdGlobalObj sharedInstanse].istecher = [contentDict[@"istecher"] isEqualToString:@"是"] ? YES : NO ;
                [LdGlobalObj sharedInstanse].user_acc = contentDict[@"acc"];
                [LdGlobalObj sharedInstanse].user_LastSign = contentDict[@"LastSign"];
                [LdGlobalObj sharedInstanse].user_SignDays = contentDict[@"SignDays"];
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *userLoginDict = [NSDictionary dictionaryWithObjectsAndKeys:self.loginView.phoneTextField.text, @"userLoginname", self.loginView.pwdTextField.text, @"userPassword", nil];
                [defaults setObject:userLoginDict forKey:@"userLoginDict"];
                [defaults synchronize];
                   
                [self synchronizeLogin];
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
-(void)synchronizeLogin{
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
          [dict setValue:self.loginView.phoneTextField.text forKey:@"mobile"];
           [dict setValue:self.loginView.pwdTextField.text forKey:@"password"];
          NSString * sign = [[NSString stringWithFormat:@"__ACBadf%@",self.loginView.phoneTextField.text] stringByAppendingString:self.loginView.pwdTextField.text];
          [dict setValue:[sign smallMD5] forKey:@"clientSign"];
          [NewRequestClass requestLogin:dict success:^(id jsonData) {
              [LdGlobalObj sharedInstanse].sessionKey = jsonData[@"data"][@"response"][@"sessionKey"];
              [LdGlobalObj sharedInstanse].user_avatar = jsonData[@"data"][@"response"][@"avatar"];
              TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
            [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
                appDelegate.window.rootViewController = homePageVC;
                [appDelegate.window makeKeyAndVisible];
          } failure:^(NSError *error) {
              
          }];
}
/*微信登录
返回 中 如果 mobile 有值，则代表该用户 已经存在平台，直接转到首页即可
如果没有mobile 值，则转到手机绑定页面
 */
-(void)weChatAuth{
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

-(void)appleAuth API_AVAILABLE(ios(13.0)){
        if (@available(iOS 13.0, *)) {
             // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
            // 创建新的AppleID 授权请求
            ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
             // 在用户授权期间请求的联系信息
            request.requestedScopes = @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName];
            
             //需要考虑用户已经登录过，可以直接使用keychain密码来进行登录-这个很智能 (但是这个有问题)
    //        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [[ASAuthorizationPasswordProvider alloc] init];
    //        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
            
            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
             // 设置授权控制器通知授权请求的成功与失败的代理
            controller.delegate = self;
            // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
//            controller.presentationContextProvider = self;
             // 在控制器初始化期间启动授权流
            [controller performRequests];
        } else {
            NSLog(@"system is lower");
        }
}
    #pragma mark - 授权成功的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)) {
    NSString *user;
    NSString *nickName;
        if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            // 用户登录使用ASAuthorizationAppleIDCredential
            ASAuthorizationAppleIDCredential *credential = authorization.credential;
            user = credential.user;
            NSData *identityToken = credential.identityToken;
            nickName = credential.fullName.givenName;
            NSLog(@"fullName -     %@",credential.fullName);
            //授权成功后，你可以拿到苹果返回的全部数据，根据需要和后台交互。
            NSLog(@"user   -   %@  %@",user,identityToken);
            //保存apple返回的唯一标识符
            [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userIdentifier"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
            // 用户登录使用现有的密码凭证
            ASPasswordCredential *psdCredential = authorization.credential;
            // 密码凭证对象的用户标识 用户的唯一标识
            user = psdCredential.user;
            nickName = @"";
            NSString *psd = psdCredential.password;
            NSLog(@"psduser -  %@   %@",psd,user);
        } else {
           NSLog(@"授权信息不符");
        }
    [LLRequestClass requestRegisterAppleByunionid:user nickname:nickName success:^(id jsonData) {
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

    #pragma mark - 授权回调失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
        
         NSLog(@"错误信息：%@", error);
         NSString *errorMsg;
        switch (error.code) {
            case ASAuthorizationErrorCanceled:
                errorMsg = @"用户取消了授权请求";
                NSLog(@"errorMsg -   %@",errorMsg);
                break;
                
            case ASAuthorizationErrorFailed:
                errorMsg = @"授权请求失败";
                NSLog(@"errorMsg -   %@",errorMsg);
                break;
                
            case ASAuthorizationErrorInvalidResponse:
                errorMsg = @"授权请求响应无效";
                NSLog(@"errorMsg -   %@",errorMsg);
                break;
                
            case ASAuthorizationErrorNotHandled:
                errorMsg = @"未能处理授权请求";
                NSLog(@"errorMsg -   %@",errorMsg);
                break;
                
            case ASAuthorizationErrorUnknown:
                errorMsg = @"授权请求失败未知原因";
                NSLog(@"errorMsg -   %@",errorMsg);
                break;
                            
            default:
                break;
        }
    ZB_Toast(errorMsg);
}



- (void)NetworkPutMsgToken{
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
//微信登录后，绑定手机号，type=0的情况
- (void)saveAutoLoginMes{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userLoginDict = [NSDictionary dictionaryWithObjectsAndKeys:[LdGlobalObj sharedInstanse].user_mobile, @"userLoginname", self.pass, @"userPassword", nil];
    [self synchronizeLogin];
    [defaults setObject:userLoginDict forKey:@"userLoginDict"];
    [defaults synchronize];
    
    self.pass = @"";
}
-(void)backButtonPressed{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)registAction{
    if(strIsNullOrEmpty(self.registView.phoneTextField.text))
       {
           ZB_Toast(@"请输入您的手机号码");
           return;
       }
       
    if(strIsNullOrEmpty(self.registView.smsTextField.text))
    {
        ZB_Toast(@"请输入您的验证码");
        return;
    }
    
    if(![self.registView.smsTextField.text isEqualToString:self.smsCodeString])
      {
          ZB_Toast(@"请输入正确的短信验证码");
          return;
      }
      
    
    if(strIsNullOrEmpty(self.registView.pwdTextField.text))
       {
           ZB_Toast(@"请输入密码");
           return;
       }
       
    if(![self.self.registView.pwdTextField.text isEqualToString:self.self.registView.pwdAgainTextField.text])
       {
           ZB_Toast(@"密码验证不一致");
           return;
       }
       
    if(![self judgePassWordLegal:self.registView.pwdTextField.text]){
           ZB_Toast(@"请输入至少6-16字符，包含英文和数字");
           return;
       }
       
    if(!self.registView.ruleselectBtn.selected){
           ZB_Toast(@"请阅读并同意用户注册协议");
           return;
       }
       
    [LLRequestClass requestRegisterByPhone:self.registView.phoneTextField.text Password:self.registView.pwdTextField.text success:^(id jsonData) {
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
                   [LdGlobalObj sharedInstanse].user_mobile = self.registView.phoneTextField.text;
                   NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                   NSDictionary *userLoginDict = [NSDictionary dictionaryWithObjectsAndKeys:self.self.registView.phoneTextField.text, @"userLoginname", self.registView.pwdTextField.text, @"userPassword", nil];
                   [defaults setObject:userLoginDict forKey:@"userLoginDict"];
                   [defaults synchronize];
                TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
                       [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
                       appDelegate.window.rootViewController = homePageVC;
                       [appDelegate.window makeKeyAndVisible];
                   [self NetworkPutMsgToken];
               }
               else
               {
                   NSString *msg = [contentDict objectForKey:@"msg"];
                   if([msg containsString:@"已经被注册"])
                   {
                       BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"该手机号已注册，直接去登录呗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"去登录"];
                       LL_WEAK_OBJC(self);
                       [alertView setConfirmBlock:^{
                           [weakself changeType:self.btnLogin];
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
-(void)validcodeAction{
    if([self.registView.phoneTextField.text isEqualToString:@""]){
            if(strIsNullOrEmpty(self.registView.phoneTextField.text)){
                ZB_Toast(@"请输入您的手机号码");
                return;
            }
    }
    if(self.registView.phoneTextField.text.length != 11){
                ZB_Toast(@"请输入合法的手机号码");
                return;
    }
            self.registView.btnValidCode.userInteractionEnabled = NO;
            self.messageTimerIndex = 60;
            self.messageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(messageTimerRefreshAction) userInfo:nil repeats:YES];
            [self.messageTimer fire];
            [self requestSendMessage];

}

- (void)messageTimerRefreshAction{
        self.messageTimerIndex--;
        if(self.messageTimerIndex == 0)
        {
            [self.messageTimer invalidate];
            [self.registView.btnValidCode setTitle:@"发送验证码" forState:UIControlStateNormal];
            self.registView.layer.borderColor = KColorBlueText.CGColor;
            self.registView.btnValidCode.userInteractionEnabled = YES;
        }
        else{
            self.registView.layer.borderColor = kColorBlackText.CGColor;
            [self.registView.btnValidCode setTitle:[NSString stringWithFormat:@"%ldS", (long)self.messageTimerIndex] forState:UIControlStateNormal];
        }
    }

- (void)requestSendMessage{
    [LLRequestClass requestSMSByPhone:self.registView.phoneTextField.text type:@"0" success:^(id jsonData) {
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

-(void)rulerSelectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}
-(void)rulerAction{
    UserKnowViewController *vc = [[UserKnowViewController alloc] init];
       [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)btnLogin {
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc] init];
        [_btnLogin setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
        [_btnLogin setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateSelected];
        _btnLogin.selected = YES;
        _btnLogin.titleLabel.font = [UIFont systemFontOfSize:17];
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [_btnLogin addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}

- (UIButton *)btnRegister {
    if (!_btnRegister) {
        _btnRegister = [[UIButton alloc] init];
        [_btnRegister setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
        [_btnRegister setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateSelected];
        _btnRegister.titleLabel.font = [UIFont systemFontOfSize:17];
        [_btnRegister setTitle:@"注册" forState:UIControlStateNormal];
        [_btnRegister addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRegister;
}

@end
