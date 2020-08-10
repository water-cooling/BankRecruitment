//
//  VideoModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

+ (instancetype)model
{
    __autoreleasing VideoModel *model = [[VideoModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.cID = dic[@"cID"];
    self.ID = dic[@"ID"];
    self.OrdID = dic[@"OrdID"];
    self.Name = dic[@"Name"];
    self.Points = dic[@"Points"];
    self.AFile = dic[@"AFile"];
    self.EID = dic[@"EID"];
    self.VTime = dic[@"VTime"];
}

@end
