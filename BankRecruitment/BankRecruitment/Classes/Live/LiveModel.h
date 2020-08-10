//
//  LiveModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveModel : NSObject

@property (nonatomic, copy) NSString *LID;      //直播课ID
@property (nonatomic, copy) NSString *Screen;       //小屏资讯
@property (nonatomic, copy) NSString *AllScreen;     //全屏资讯
@property (nonatomic, copy) NSString *Name;    //直播课名
@property (nonatomic, copy) NSString *LCount;    //课时数
@property (nonatomic, copy) NSString *PurchCount;    //已购人数
@property (nonatomic, copy) NSString *Price;     //课程费用
@property (nonatomic, copy) NSString *BegDate;   //授课开始
@property (nonatomic, copy) NSString *EndDate;    //授课结束
@property (nonatomic, copy) NSString *BegSale;   //开售日期
@property (nonatomic, copy) NSString *EndSale;    //停售日期
@property (nonatomic, copy) NSString *IsGet;    //停售日期

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
