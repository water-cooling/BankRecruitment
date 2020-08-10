//
//  LoginViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoginSuccessBlock)();

@interface LoginViewController : UIViewController
@property (nonatomic, copy) LoginSuccessBlock loginSuccessBlock;

- (void)saveAutoLoginMes;
@end
