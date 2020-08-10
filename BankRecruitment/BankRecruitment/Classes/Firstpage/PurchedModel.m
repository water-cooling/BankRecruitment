//
//  PurchedModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "PurchedModel.h"

@implementation PurchedModel
+ (instancetype)model
{
    __autoreleasing PurchedModel *model = [[PurchedModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.pID = dic[@"pID"];
    self.PType = dic[@"PType"];
    self.uid = dic[@"uid"];
    self.FeeDate = dic[@"FeeDate"];
    self.LinkID = dic[@"LinkID"];
    self.Fee = dic[@"Fee"];
    self.Abstract = dic[@"Abstract"];
    self.Intro = dic[@"Intro"];
    self.PState = dic[@"PState"];
}
@end
