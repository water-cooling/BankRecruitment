//
//  MockModel.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockModel : NSObject
@property (nonatomic, copy) NSString *ID;      //大赛ID
@property (nonatomic, copy) NSString *Screen;       //小屏资讯
@property (nonatomic, copy) NSString *PCScreen;  //PC广告
@property (nonatomic, copy) NSString *AllScreen;    //全屏资讯
@property (nonatomic, copy) NSString *Name;     //大赛标题
@property (nonatomic, copy) NSString *BegDate;   //报名开始
@property (nonatomic, copy) NSString *EndDate;    //报名结束
@property (nonatomic, copy) NSString *MDate;   //模考时间
@property (nonatomic, copy) NSString *Scope;    //模考范围
@property (nonatomic, copy) NSString *LiveID;    //直播课ID
@property (nonatomic, copy) NSString *VideoID;    //视频ID
@property (nonatomic, copy) NSString *ExaminID;    //试卷ID
@property (nonatomic, copy) NSString *iCount;    //订购人数
@property (nonatomic, copy) NSString *IsGet;    //我是否订
@property (nonatomic, copy) NSString *SjIsGet;    //试卷是否买
@property (nonatomic, copy) NSString *ZbIsGet;    //直播是否买
@property (nonatomic, copy) NSString *SpIsGet;    //视频是否买
@property (nonatomic, copy) NSString *ExName;    //模拟试卷名
@property (nonatomic, copy) NSString *ExPrice;
@property (nonatomic, copy) NSString *ExBegDate;    //模拟试卷开始
@property (nonatomic, copy) NSString *ExEndDate;    //模拟试卷结束
@property (nonatomic, copy) NSString *LivName;    //直播课名
@property (nonatomic, copy) NSString *LivPirce;
@property (nonatomic, copy) NSString *LivBegDate;    //直播课开始
@property (nonatomic, copy) NSString *LivEndDate;    //直播课结束
@property (nonatomic, copy) NSString *VidName;    //视频名称
@property (nonatomic, copy) NSString *VidPirce;

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
