//
//  RemoteMessageModel.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "RemoteMessageModel.h"

@implementation RemoteMessageModel
+ (instancetype)model
{
    __autoreleasing RemoteMessageModel *model = [[RemoteMessageModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.notify_id = dic[@"notify_id"];
    self.name = dic[@"name"];
    self.msg = dic[@"msg"];
    self.mType = dic[@"mType"];
    self.linkId = dic[@"linkId"];
}
@end
