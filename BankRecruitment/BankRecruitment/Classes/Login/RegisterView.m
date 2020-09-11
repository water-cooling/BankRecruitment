//
//  RegisterView.m
//  YLTX
//
//  Created by humengfan on 2020/8/11.
//  Copyright © 2020 huangpf. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView

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
    [self addSubview:lineViewOne];
        lineViewOne.backgroundColor = kColorBarGrayBackground;
    
    
    UIImageView *smsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yzm"]];
           UIView * smsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,27,15)];
              smsIcon.frame = CGRectMake(0, 0, 15, 15);
              [smsView addSubview:smsIcon];
    UITextField *smsTextField = [[UITextField alloc] init];
    UIView *smsRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 26)];
    [smsRightView addSubview:self.btnValidCode];
    smsTextField.rightView = smsRightView;
    smsTextField.rightViewMode = UITextFieldViewModeAlways;
               smsTextField.backgroundColor = [UIColor whiteColor];
               NSAttributedString *smsAttrString = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:
                   @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#AAAAAA"],
                   NSFontAttributeName:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular]}];
               smsTextField.attributedPlaceholder = smsAttrString;
              smsTextField.leftViewMode = UITextFieldViewModeAlways;
           smsTextField.leftView = smsView;
               smsTextField.borderStyle = UITextBorderStyleNone;
               smsTextField.textColor = [UIColor colorWithHex:@"#333333"];
               smsTextField.keyboardType = UIKeyboardTypeNumberPad;
               self.smsTextField = smsTextField;
               [self addSubview:self.smsTextField];
           UIView *lineViewTwo = [UIView new];
           lineViewTwo.backgroundColor = kColorBarGrayBackground;
            [self addSubview:lineViewTwo];
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
        pwdTextField.secureTextEntry = YES;
        pwdTextField.rightViewMode = UITextFieldViewModeWhileEditing;
               pwdTextField.returnKeyType =  UIReturnKeySearch;
               pwdTextField.backgroundColor = [UIColor whiteColor];
               NSAttributedString *pwdattrString = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:
                   @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#AAAAAA"],
                   NSFontAttributeName:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular]}];
               pwdTextField.attributedPlaceholder = pwdattrString;
               pwdTextField.leftViewMode = UITextFieldViewModeAlways;
                pwdTextField.leftView = pwdView;
               pwdTextField.borderStyle = UITextBorderStyleNone;
               pwdTextField.textColor = [UIColor colorWithHex:@"#333333"];
               self.pwdTextField= pwdTextField;
               [self addSubview:self.pwdTextField];
        UIView *lineViewThree = [UIView new];
        lineViewThree.backgroundColor = kColorBarGrayBackground;
    [self addSubview:lineViewThree];
    
    UIImageView *pwdAgainIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"]];
                 pwdAgainIcon.frame = CGRectMake(0, 0, 15, 15);
            UIView * pwdAgainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,27,15)];
               [pwdAgainView addSubview:pwdAgainIcon];
        UITextField *pwdAgainTextField = [[UITextField alloc] init];
           UIView *RightAgainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 55, 14)];
             UIButton * eyesAgainBtn= [UIButton buttonWithType:UIButtonTypeCustom];
             [eyesAgainBtn setImage:[UIImage imageNamed:@"guanyan"] forState:UIControlStateNormal];
             [eyesAgainBtn setImage:[UIImage imageNamed:@"kaiyan"] forState:UIControlStateSelected];
             [eyesAgainBtn addTarget:self action:@selector(ShowAgainPwd:) forControlEvents:UIControlEventTouchUpInside];
             eyesAgainBtn.frame = CGRectMake(0, 0, 20, 14);
             [RightAgainView addSubview:eyesAgainBtn];
           pwdAgainTextField.rightView = RightAgainView;
           pwdAgainTextField.rightViewMode = UITextFieldViewModeWhileEditing;
            pwdAgainTextField.backgroundColor = [UIColor whiteColor];
                  NSAttributedString *pwdAginAttrString = [[NSAttributedString alloc] initWithString:@"请确认密码" attributes:
                      @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#AAAAAA"],
                      NSFontAttributeName:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular]}];
                  pwdAgainTextField.attributedPlaceholder = pwdAginAttrString;
                  pwdAgainTextField.leftViewMode = UITextFieldViewModeAlways;
                    pwdAgainTextField.secureTextEntry = YES;
                   pwdAgainTextField.leftView = pwdAgainView;
                  pwdAgainTextField.borderStyle = UITextBorderStyleNone;
                  pwdAgainTextField.textColor = [UIColor colorWithHex:@"#333333"];
                  self.pwdAgainTextField= pwdAgainTextField;
                  [self addSubview:self.pwdAgainTextField];
           UIView *lineViewFour = [UIView new];
           lineViewFour.backgroundColor = kColorBarGrayBackground;
        [self addSubview:lineViewFour];

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
    [smsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(self.phoneTextField);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(33);
               make.height.mas_equalTo(24);
        make.width.mas_equalTo(Screen_Width-64);

    }];
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.right.equalTo(self.smsTextField);
                  make.height.mas_equalTo(1);
                  make.top.equalTo(self.smsTextField.mas_bottom);
    }];
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.smsTextField);
        make.top.equalTo(self.smsTextField.mas_bottom).offset(33);
            make.height.mas_equalTo(24);
        make.width.mas_equalTo(Screen_Width-64);

        }];
    [lineViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.pwdTextField);
               make.height.mas_equalTo(1);
               make.top.equalTo(self.pwdTextField.mas_bottom);
           }];
    [pwdAgainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smsTextField);
        make.top.equalTo(self.pwdTextField.mas_bottom).offset(33);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(Screen_Width-64);

    }];
       [lineViewFour mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.left.right.equalTo(self.pwdAgainTextField);
                  make.height.mas_equalTo(1);
                  make.top.equalTo(self.pwdAgainTextField.mas_bottom);
    }];
    
    UIButton *ruleselectBtn = [[UIButton alloc] init];
    [ruleselectBtn setImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
    [ruleselectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [ruleselectBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self addSubview:ruleselectBtn];
    self.ruleselectBtn = ruleselectBtn;
    [ruleselectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineViewFour.mas_bottom).offset(15);
        make.left.equalTo(self).offset(30);
    }];
          
    UILabel *rule = [[UILabel alloc] init];
       rule.text = @"已阅读并同意";
       rule.font = [UIFont systemFontOfSize:14 ];
       [self addSubview:rule];
       [rule mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(ruleselectBtn.mas_centerY);
           make.left.equalTo(ruleselectBtn.mas_right).offset(10);
       }];
       UIButton *ruleBtn = [[UIButton alloc] init];
       [ruleBtn setTitle:@"用户注册协议" forState:UIControlStateNormal];
       [ruleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
       ruleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
       [self addSubview:ruleBtn];
        self.ruleBtn = ruleBtn;
       [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(rule.mas_right);
           make.centerY.equalTo(rule.mas_centerY);
       }];
    [self addSubview:self.btnRegist];
    [_btnRegist mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerX.equalTo(self);
              make.top.equalTo(ruleBtn.mas_bottom).offset(44);
              make.width.mas_equalTo(Screen_Width-64);
              make.height.mas_equalTo(40);
          }];
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
    if ([textField isEqual:self.pwdTextField] || [textField isEqual:self.pwdAgainTextField] ) {
            if (textField.text.length >= 31) {
                return NO;
            }
    }
    if ([textField isEqual:self.phoneTextField]){
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
-(void)ShowAgainPwd:(UIButton *)sender{
    [self.pwdAgainTextField setSecureTextEntry:sender.selected];
    sender.selected = !sender.selected;
    NSString *text = self.pwdAgainTextField.text;
    self.pwdAgainTextField.text = @"";
    self.pwdAgainTextField.text = text;
    if (self.pwdAgainTextField.secureTextEntry){
        [self.pwdAgainTextField insertText:self.pwdAgainTextField.text];
    }else
    {}
}


- (UIButton *)btnValidCode {
    if (!_btnValidCode) {
        _btnValidCode = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
        _btnValidCode.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btnValidCode setTitleColor:kColorBlackText forState:0];
        [_btnValidCode setTitle:@"发送验证码" forState:UIControlStateNormal];
        _btnValidCode.layer.borderWidth = 1;
        _btnValidCode.layer.borderColor = kColorBlackText.CGColor;
        _btnValidCode.layer.cornerRadius = 2;
        [_btnValidCode setBackgroundColor:[UIColor whiteColor]];
    }
    return _btnValidCode;
}

- (UIButton *)btnRegist {
    if (!_btnRegist) {
        _btnRegist = [[UIButton alloc] init];
        [_btnRegist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnRegist.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnRegist.layer.cornerRadius = 20;
        _btnRegist.backgroundColor = [UIColor colorWithHex:@"#558CF4"];
        [_btnRegist setTitle:@"注册" forState:UIControlStateNormal];
    }
    return _btnRegist;
}
@end
