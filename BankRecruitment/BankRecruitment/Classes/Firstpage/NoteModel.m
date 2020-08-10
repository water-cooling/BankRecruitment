//
//  NoteModel.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel
+ (instancetype)model
{
    __autoreleasing NoteModel *model = [[NoteModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.ID = dic[@"ID"];
    self.Date = dic[@"Date"];
    self.LinkID = dic[@"LinkID"];
    self.Note = dic[@"Note"];
}

@end
