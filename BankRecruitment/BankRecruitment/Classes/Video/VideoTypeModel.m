//
//  VideoTypeModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "VideoTypeModel.h"

@implementation VideoTypeModel

+ (instancetype)model
{
    __autoreleasing VideoTypeModel *model = [[VideoTypeModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.VType = dic[@"VType"];
    self.picture = dic[@"picture"];
    self.type_num = dic[@"type_num"];
    self.video_num = dic[@"video_num"];
}

@end
