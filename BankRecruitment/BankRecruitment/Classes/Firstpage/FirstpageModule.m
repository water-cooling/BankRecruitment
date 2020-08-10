//
//  FirstpageModule.m
//  Recruitment
//
//  Created by 夏建清 on 2018/6/9.
//  Copyright © 2018年 LongLian. All rights reserved.
//

#import "FirstpageModule.h"

@implementation FirstpageModule
+ (instancetype)model
{
    __autoreleasing FirstpageModule *model = [[FirstpageModule alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.ID = dic[@"id"];
    self.img = dic[@"img"];
    self.path = dic[@"path"];
    self.title = dic[@"title"];
    self.url = dic[@"url"];
    self.url_type = dic[@"url_type"];
}
@end
