//
//  RegisterView.h
//  YLTX
//
//  Created by humengfan on 2020/8/11.
//  Copyright © 2020 huangpf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *btnRegist;
@property (nonatomic, strong) UIButton *btnValidCode;
@property (nonatomic, strong) UIButton *ruleselectBtn;
@property (nonatomic, strong) UIButton *ruleBtn;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *smsTextField;
@property (nonatomic, strong) UITextField *pwdAgainTextField;
@end

NS_ASSUME_NONNULL_END
