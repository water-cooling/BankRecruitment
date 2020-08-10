//
//  GetSMSViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GetSMSType) {
    FindPassWordType = 0,
    BindPhoneNumType = 3
};

@interface GetSMSViewController : UIViewController
@property (nonatomic, assign) GetSMSType getSMSType;
@end
