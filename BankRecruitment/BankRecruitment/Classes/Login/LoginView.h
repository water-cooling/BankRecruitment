//
//  LoginView.h
//  YLTX
//
//  Created by humengfan on 2020/8/11.
//  Copyright © 2020 huangpf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *btnForget;
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UIButton *btnWeChat;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@end

NS_ASSUME_NONNULL_END
