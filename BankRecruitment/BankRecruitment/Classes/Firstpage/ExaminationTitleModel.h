//
//  ExaminationQuestionModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExaminationTitleModel : NSObject
@property (nonatomic, copy) NSString *EID;      //试卷ID
@property (nonatomic, copy) NSString *ID;       //题目ID
@property (nonatomic, copy) NSString *OID;      //提纲ID
@property (nonatomic, copy) NSString *OrdID;    //题目序号
@property (nonatomic, copy) NSString *TitleID;    //题库ID
@property (nonatomic, copy) NSString *Score;     //分数
@property (nonatomic, copy) NSString *ATime;   //答题时间
@property (nonatomic, copy) NSString *Answer;    //结果
@property (nonatomic, copy) NSString *isOK;   //是否答对
@property (nonatomic, copy) NSString *GetScore;    //得分
@property (nonatomic, copy) NSString *UserTime;    //答题时长

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
