//
//  SignMockModel.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignMockModel : NSObject
@property (nonatomic, copy) NSString *ID;      //报名ID
@property (nonatomic, copy) NSString *sDate;       //报名时间
@property (nonatomic, copy) NSString *MockID;  //模考ID
@property (nonatomic, copy) NSString *uid;    //帐号ID
@property (nonatomic, copy) NSString *Province;     //省
@property (nonatomic, copy) NSString *City;   //市
@property (nonatomic, copy) NSString *Bank;    //银行分类
@property (nonatomic, copy) NSString *subBank;   //分行
@property (nonatomic, copy) NSString *job;    //报考职位

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
