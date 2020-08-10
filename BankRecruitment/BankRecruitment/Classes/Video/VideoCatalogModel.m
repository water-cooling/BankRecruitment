//
//  VideoCatalogModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "VideoCatalogModel.h"

@implementation VideoCatalogModel
+ (instancetype)model
{
    __autoreleasing VideoCatalogModel *model = [[VideoCatalogModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.cID = dic[@"cID"];
    self.OrdID = dic[@"OrdID"];
    self.Screen = dic[@"Screen"];
    self.AllScreen = dic[@"AllScreen"];
    self.Name = dic[@"Name"];
    self.VType = dic[@"VType"];
    self.Price = dic[@"Price"];
    self.iCount = dic[@"iCount"];
    self.IsGet = dic[@"IsGet"];
    self.isSpread = NO;
}
@end
