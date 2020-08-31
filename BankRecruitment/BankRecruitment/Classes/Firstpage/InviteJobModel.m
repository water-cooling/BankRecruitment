//
//  InviteJobModel.m
//  Recruitment
//
//  Created by humengfan on 2020/8/30.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "InviteJobModel.h"

@implementation InviteJobModel
- (void)setDataWithDic:(NSDictionary *)dic {
    self.title = dic[@"title"];
    self.h5Url = dic[@"h5Url"];
}
@end
