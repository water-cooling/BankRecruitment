//
//  AddressModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/7.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, copy) NSString *uid;      //帐号ID
@property (nonatomic, copy) NSString *Name;       //收件人
@property (nonatomic, copy) NSString *Tel;     //电话
@property (nonatomic, copy) NSString *Province;    //省
@property (nonatomic, copy) NSString *City;    //市
@property (nonatomic, copy) NSString *District;    //区县
@property (nonatomic, copy) NSString *Addr;     //地址

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;

@end
