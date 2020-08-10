//
//  ExamDetailModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/19.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 题目ID   ：ID
 试卷ID   : EID
 提纲ID   ：OID
 题目序号 : OrdID
 题库ID   : TitleID
 分数     ：Score
 答题时间 ：ATime
 结果     :Answer
 是否答对 :isOK
 得分     :GetScore
 答题时长 :UserTime
 

 */

@interface ExamDetailModel : NSObject

@property (nonatomic, copy) NSString *isFromIntelligent;
@property (nonatomic, copy) NSString *isFromOutLine;
@property (nonatomic, copy) NSString *ID;      //题目ID
@property (nonatomic, copy) NSString *EID;      //试卷ID
@property (nonatomic, copy) NSString *OID;      //提纲ID
@property (nonatomic, copy) NSString *ordID;      //题目序号
@property (nonatomic, copy) NSString *titleID;      //题库ID
@property (nonatomic, copy) NSString *score;      //分数
@property (nonatomic, copy) NSString *ATime;      //答题时间
@property (nonatomic, copy) NSString *answer;      //结果
@property (nonatomic, copy) NSString *isOK;      //是否答对
@property (nonatomic, copy) NSString *getScore;      //得分
@property (nonatomic, copy) NSString *userTime;      //答题时长
@property (nonatomic, copy) NSString *bank;       //关联银行
@property (nonatomic, copy) NSString *TYear;      //年份
@property (nonatomic, copy) NSString *QType;    //题型
@property (nonatomic, copy) NSString *content;    //考试内容
@property (nonatomic, copy) NSString *QPoint;     //考点
@property (nonatomic, copy) NSString *isBank;   //银行强关联
@property (nonatomic, copy) NSString *title;    //题目内容
@property (nonatomic, copy) NSString *ID_Ord1;   //资料题干号
@property (nonatomic, copy) NSString *CCount;    //小题数
@property (nonatomic, copy) NSString *ord;    //小题序号
@property (nonatomic, copy) NSString *CDate;    //变更日期
@property (nonatomic, copy) NSString *solution;    //标准答案
@property (nonatomic, copy) NSString *analysis;    //分析
@property (nonatomic, copy) NSString *material;    //资料题干
@property (nonatomic, copy) NSString *totalCount;    //全站多少人做
@property (nonatomic, copy) NSString *rightCount;    //全站做对数
@property (nonatomic, copy) NSString *errCount;    //全站做错数
@property (nonatomic, copy) NSString *badAnswer;    //最易错答案
@property (nonatomic, copy) NSMutableArray *list_TitleList;    //选项列表

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;

@end
