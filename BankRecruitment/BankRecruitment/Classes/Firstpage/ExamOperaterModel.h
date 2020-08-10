//
//  ExamOperaterModel.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamOperaterModel : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *ExamID;
@property (nonatomic, copy) NSString *Answer;
@property (nonatomic, copy) NSString *GetScore;
@property (nonatomic, copy) NSString *isOK;
@property (nonatomic, copy) NSString *TagFlag;
@property (nonatomic, copy) NSString *EID;
@property (nonatomic, copy) NSString *isFromIntelligent;
@property (nonatomic, copy) NSString *isFromOutLine;
@property (nonatomic, copy) NSString *OID;
@property (nonatomic, copy) NSString *isSelected;

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
