//
//  FirstAdModel.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/5/9.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "FirstAdModel.h"

@implementation FirstAdModel
+ (instancetype)model
{
    __autoreleasing FirstAdModel *model = [[FirstAdModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.path = dic[@"path"];
    self.img = dic[@"img"];
    self.title = dic[@"title"];
}
@end
