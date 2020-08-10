//
//  ExamDetailOptionModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/19.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamDetailOptionModel : NSObject

@property (nonatomic, copy) NSString *titleListID;      //选项ID
@property (nonatomic, copy) NSString *orderID;       //选项顺序
@property (nonatomic, copy) NSString *single;      //选项标识
@property (nonatomic, copy) NSString *SList;    //选项内容

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;

@end
