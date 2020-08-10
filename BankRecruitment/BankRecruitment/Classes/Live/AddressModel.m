//
//  AddressModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/7.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+ (instancetype)model
{
    __autoreleasing AddressModel *model = [[AddressModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.uid = dic[@"uid"];
    self.Name = dic[@"Name"];
    self.Tel = dic[@"Tel"];
    self.Province = dic[@"Province"];
    self.City = dic[@"City"];
    self.District = dic[@"District"];
    self.Addr = dic[@"Addr"];
}

@end
