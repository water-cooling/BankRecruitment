//
//  SignMockModel.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "SignMockModel.h"

@implementation SignMockModel
+ (instancetype)model
{
    __autoreleasing SignMockModel *model = [[SignMockModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.ID = dic[@"ID"];
    self.sDate = dic[@"sDate"];
    self.MockID = dic[@"MockID"];
    self.uid = dic[@"uid"];
    self.Province = dic[@"Province"];
    self.City = dic[@"City"];
    self.Bank = dic[@"Bank"];
    self.subBank = dic[@"subBank"];
    self.job = dic[@"job"];
}
@end
