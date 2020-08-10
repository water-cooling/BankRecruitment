//
//  ExaminationPaperModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExaminationPaperModel.h"

@implementation ExaminationPaperModel
+ (instancetype)model
{
    __autoreleasing ExaminationPaperModel *model = [[ExaminationPaperModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.TypeInfo = dic[@"TypeInfo"];
    self.AllScreen = dic[@"AllScreen"];
    self.Bank = dic[@"Bank"];
    self.BegDate = dic[@"BegDate"];
    self.EndDate = dic[@"EndDate"];
    self.ID = dic[@"ID"];
    self.IsGet = dic[@"IsGet"];
    self.Name = dic[@"Name"];
    self.PCScreen = dic[@"PCScreen"];
    self.Price = dic[@"Price"];
    self.Screen = dic[@"Screen"];
    self.TYear = dic[@"TYear"];
    self.iCount = dic[@"iCount"];
}
@end
