//
//  LoginView.m
//  YLTX
//
//  Created by humengfan on 2020/8/11.
//  Copyright © 2020 huangpf. All rights reserved.
//

#import "LoginView.h"


@implementation LoginView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
    UIImageView *iphoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sjh"]];
    UIView * iphoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,27,15)];
       iphoneIcon.frame = CGRectMake(0, 0, 15, 15);
       [iphoneView addSubview:iphoneIcon];
    UITextField *phoneTextField = [[UITextField alloc] init];
        phoneTextField.returnKeyType =  UIReturnKeySearch;
        phoneTextField.backgroundColor = [UIColor whiteColor];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:
            @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#AAAAAA"],
            NSFontAttributeName:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular]}];
        phoneTextField.attributedPlaceholder = attrString;
       phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.leftView = iphoneView;
        phoneTextField.borderStyle = UITextBorderStyleNone;
        phoneTextField.textColor = [UIColor colorWithHex:@"#333333"];
        phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneTextField = phoneTextField;
        [self addSubview:self.phoneTextField];
    UIView *lineViewOne = [UIView new];
    lineViewOne.backgroundColor = kColorBarGrayBackground;
    [self addSubview:lineViewOne];
    //密码
    UIImageView *pwdIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"]];
          pwdIcon.frame = CGRectMake(0, 0, 15, 15);
     UIView * pwdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,27,15)];
        [pwdView addSubview:pwdIcon];
       UITextField *pwdTextField = [[UITextField alloc] init];
    UIView *RightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 55, 14)];
      UIButton * eyesBtn= [UIButton buttonWithType:UIButtonTypeCustom];
      [eyesBtn setImage:[UIImage imageNamed:@"guanyan"] forState:UIControlStateNormal];
      [eyesBtn setImage:[UIImage imageNamed:@"kaiyan"] forState:UIControlStateSelected];
      [eyesBtn addTarget:self action:@selector(ShowPwd:) forControlEvents:UIControlEventTouchUpInside];
      eyesBtn.frame = CGRectMake(0, 0, 20, 14);
      [RightView addSubview:eyesBtn];
    pwdTextField.rightView = RightView;
    
    pwdTextField.rightViewMode = UITextFieldViewModeWhileEditing;
           pwdTextField.backgroundColor = [UIColor whiteColor];
           NSAttributedString *pwdattrString = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:
               @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#AAAAAA"],
               NSFontAttributeName:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular]}];
           pwdTextField.attributedPlaceholder = pwdattrString;
           pwdTextField.leftViewMode = UITextFieldViewModeAlways;
            pwdTextField.leftView = pwdView;
        pwdTextField.secureTextEntry = YES;
           pwdTextField.borderStyle = UITextBorderStyleNone;
           pwdTextField.textColor = [UIColor colorWithHex:@"#333333"];
           self.pwdTextField= pwdTextField;
           [self addSubview:self.pwdTextField];
    UIView *lineViewTwo = [UIView new];
    lineViewTwo.backgroundColor = kColorBarGrayBackground;
    [self addSubview:lineViewTwo];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(32);
        make.top.equalTo(self).offset(38);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(Screen_Width-64);

    }];
    [lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(phoneTextField);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.phoneTextField.mas_bottom);
    }];
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTextField);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(33);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(Screen_Width-64);

    }];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.equalTo(pwdTextField);
           make.height.mas_equalTo(1);
           make.top.equalTo(self.pwdTextField.mas_bottom);
       }];
    
    [self addSubview:self.btnForget];
    [self.btnForget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineViewTwo);
        make.top.equalTo(lineViewTwo).offset(13);
    }];
    [self addSubview:self.btnLogin];
       [_btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(self);
           make.top.equalTo(_btnForget.mas_bottom).offset(33.5);
           make.width.mas_equalTo(Screen_Width-64);
           make.height.mas_equalTo(40);
       }];
        UILabel *moreLab = [[UILabel alloc] init];
           moreLab.font = [UIFont systemFontOfSize:12];
           moreLab.textAlignment = NSTextAlignmentLeft;
            moreLab.hidden = YES;
           moreLab.textColor = [UIColor colorWithHex:@"#999999"];
           moreLab.text = @"更多登录方式";
           [self addSubview:moreLab];
       [moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(self);
           make.height.mas_equalTo(12);
           make.top.equalTo(self.btnLogin.mas_bottom).offset(45.5);
       }];
    [self addSubview:self.btnWeChat];
       [_btnWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(self).offset(-60);
           make.top.equalTo(moreLab.mas_bottom).offset(25);
           make.width.mas_equalTo(40);
           make.height.mas_equalTo(40);
       }];
    self.btnWeChat.imageView.layer.cornerRadius = 20;
    self.btnWeChat.imageView.layer.masksToBounds = YES;
    self.btnWeChat.layer.borderWidth = 0.5;
    self.btnWeChat.hidden = YES;

    self.btnWeChat.layer.borderColor = [UIColor colorWithHex:@"#51C300"].CGColor;
    
    [self addSubview:self.btnApple];
    [self.btnApple mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(60);
              make.top.equalTo(moreLab.mas_bottom).offset(25);
              make.width.mas_equalTo(40);
              make.height.mas_equalTo(40);
        }];
        self.btnApple.hidden = YES;
        self.btnApple.imageView.layer.cornerRadius = 20;
       self.btnApple.imageView.layer.masksToBounds = YES;
//    if([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]){
//         self.btnWeChat.hidden = NO;
//        self.btnApple.hidden = NO;
//        moreLab.hidden = NO;
//     }else{
//         self.btnWeChat.hidden = YES;
//         self.btnApple.hidden = YES;
//         moreLab.hidden = YES;
//     }
//    if (@available(iOS 13.0, *)) {
//       self.btnApple.hidden = NO;
//    }else{
//        self.btnApple.hidden = YES;
//    }
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     NSDictionary *loginDict = [defaults objectForKey:@"userLoginDict"];
     if(loginDict){
         self.phoneTextField.text = loginDict[@"userLoginname"];
     }

    
}

#pragma mark --textFielddelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.pwdTextField) {
    if (textField.secureTextEntry){
        [textField insertText:self.pwdTextField.text];
        }
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //    NSLog(@"%ld",textField.tag);
    if (string == nil || string.length == 0) {
        return YES;
    }

    if ([textField isEqual:self.pwdTextField]) {
            if (textField.text.length >= 31) {
                return NO;
            }
        } else {
            if (textField.text.length >= 11) {
                return NO;
            }
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(void)ShowPwd:(UIButton *)sender{
    [self.pwdTextField setSecureTextEntry:sender.selected];
    sender.selected = !sender.selected;
    NSString *text = self.pwdTextField.text;
    self.pwdTextField.text = @"";
    self.pwdTextField.text = text;
    if (self.pwdTextField.secureTextEntry){
        [self.pwdTextField insertText:self.pwdTextField.text];
    }else
    {}
    
}
- (UIButton *)btnForget {
    if (!_btnForget) {
        _btnForget = [[UIButton alloc] init];
        [_btnForget setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_btnForget setTitleColor:[UIColor colorWithHex:@"#558CF4"] forState:0];
        _btnForget.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _btnForget;
}
- (UIButton *)btnLogin {
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc] init];
        [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnLogin.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnLogin.layer.cornerRadius = 20;
        _btnLogin.backgroundColor = [UIColor colorWithHex:@"#558CF4"];
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    }
    return _btnLogin;
}
- (UIButton *)btnWeChat {
    if (!_btnWeChat) {
        _btnWeChat = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnWeChat setBackgroundImage:[UIImage imageNamed:@"weixinlogin"] forState:UIControlStateNormal];
    }
    return _btnWeChat;
}
- (UIButton *)btnApple {
    if (!_btnApple) {
        _btnApple = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnApple setBackgroundImage:[UIImage imageNamed:@"AppleAuth"] forState:UIControlStateNormal];
    }
    return _btnApple;
}
@end
