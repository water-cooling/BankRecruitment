//
//  PurchedModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchedModel : NSObject
@property (nonatomic, copy) NSString *pID;      //支付ID
@property (nonatomic, copy) NSString *PType;       //支付类别
@property (nonatomic, copy) NSString *uid;  //帐号ID
@property (nonatomic, copy) NSString *FeeDate;    //订单日期
@property (nonatomic, copy) NSString *LinkID;     //关联ID
@property (nonatomic, copy) NSString *Fee;   //支付费用
@property (nonatomic, copy) NSString *Abstract;    //订单摘要
@property (nonatomic, copy) NSString *Intro;   //支付说明
@property (nonatomic, copy) NSString *PState;    //支付状态

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
