//
//  ResetPasswordViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSMSViewController.h"

@interface ResetPasswordViewController : UIViewController
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) GetSMSType getSMSType;
@end
