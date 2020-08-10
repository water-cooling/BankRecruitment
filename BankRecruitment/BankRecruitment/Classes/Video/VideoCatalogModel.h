//
//  VideoCatalogModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCatalogModel : NSObject
@property (nonatomic, copy) NSString *cID;      //视频目录
@property (nonatomic, copy) NSString *OrdID;    //序号
@property (nonatomic, copy) NSString *Screen;      //小屏资讯
@property (nonatomic, copy) NSString *AllScreen;      //全屏资讯
@property (nonatomic, copy) NSString *Name;      //视频标题
@property (nonatomic, copy) NSString *VType;      //视频大类
@property (nonatomic, copy) NSString *Price;      //价格
@property (nonatomic, copy) NSString *iCount;      //订购人数
@property (nonatomic, copy) NSString *IsGet;      //我是否订

@property (nonatomic, assign) BOOL isSpread;

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
