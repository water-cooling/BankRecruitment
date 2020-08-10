//
//  LiveTecherModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/4.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "LiveTecherModel.h"

@implementation LiveTecherModel
+ (instancetype)model
{
    __autoreleasing LiveTecherModel *model = [[LiveTecherModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.Resume = dic[@"Resume"];
    self.TecheAFile = dic[@"TecheAFile"];
    self.TecheID = dic[@"TecheID"];
    self.TecheIntro = dic[@"TecheIntro"];
    self.TecheName = dic[@"TecheName"];
}
@end
