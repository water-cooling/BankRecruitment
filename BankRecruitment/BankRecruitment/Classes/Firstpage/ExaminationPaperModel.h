//
//  ExaminationPaperModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExaminationPaperModel : NSObject
@property (nonatomic, copy) NSString *TypeInfo;      //试卷分类
@property (nonatomic, copy) NSString *AllScreen;       //全屏资讯
@property (nonatomic, copy) NSString *Bank;  //关联银行
@property (nonatomic, copy) NSString *BegDate;    //开始开放
@property (nonatomic, copy) NSString *EndDate;     //结束开放
@property (nonatomic, copy) NSString *ID;   //试卷ID
@property (nonatomic, copy) NSString *IsGet;    //我是否订  //是、否/空
@property (nonatomic, copy) NSString *Name;   //试卷主题
@property (nonatomic, copy) NSString *PCScreen;    //PC广告
@property (nonatomic, copy) NSString *Price;    //单价
@property (nonatomic, copy) NSString *Screen;    //小屏资讯
@property (nonatomic, copy) NSString *TYear;    //年份
@property (nonatomic, copy) NSString *iCount;    //订购人数

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
