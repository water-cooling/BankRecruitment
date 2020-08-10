//
//  OutlineModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutlineModel : NSObject

@property (nonatomic, assign) BOOL isSpread;   //是否展开
@property (nonatomic, assign) int ceng;   //第几层
@property (nonatomic, copy) NSString *EID;      //试卷ID
@property (nonatomic, copy) NSString *ID;       //提纲ID
@property (nonatomic, copy) NSString *SuperID;  //上级提纲ID
@property (nonatomic, copy) NSString *OrdID;    //序号
@property (nonatomic, copy) NSString *Name;     //单元名称
@property (nonatomic, copy) NSString *TCount;   //总题数
@property (nonatomic, copy) NSString *TTime;    //单元用时
@property (nonatomic, copy) NSString *IsOver;   //提前结束
@property (nonatomic, copy) NSString *OType;    //类别
@property (nonatomic, copy) NSString *doCount;    //我做的题数
@property (nonatomic, copy) NSString *okCount;    //做对的题数
@property (nonatomic, copy) NSString *errCount;    //做错的题数
@property (nonatomic, copy) NSString *noCount;    //没做的题数
@property (nonatomic, strong) NSMutableArray *list_outlineinfo;    //子集

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;

@end
