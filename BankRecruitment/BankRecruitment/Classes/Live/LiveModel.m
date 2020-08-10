//
//  LiveModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "LiveModel.h"

@implementation LiveModel

+ (instancetype)model
{
    __autoreleasing LiveModel *model = [[LiveModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.LID = dic[@"LID"];
    self.Screen = dic[@"Screen"];
    self.AllScreen = dic[@"AllScreen"];
    self.Name = dic[@"Name"];
    self.PurchCount = dic[@"PurchCount"];
    self.LCount = dic[@"LCount"];
    self.Price = dic[@"Price"];
    self.BegDate = dic[@"BegDate"];
    self.EndDate = dic[@"EndDate"];
    self.BegSale = dic[@"BegSale"];
    self.EndSale = dic[@"EndSale"];
    self.IsGet = dic[@"IsGet"];
}

@end
