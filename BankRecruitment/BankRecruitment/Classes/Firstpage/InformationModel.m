//
//  InformationModel.m
//  Recruitment
//
//  Created by 夏建清 on 2018/6/9.
//  Copyright © 2018年 LongLian. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel
+ (instancetype)model
{
    __autoreleasing InformationModel *model = [[InformationModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.ID = dic[@"ID"];
    self.TypeName = dic[@"TypeName"];
    self.Name = dic[@"Name"];
    self.Screen = dic[@"Screen"];
    self.PCScreen = dic[@"PCScreen"];
    self.Info = dic[@"Info"];
    self.CreateDate = dic[@"CreateDate"];
}

@end
