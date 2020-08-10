//
//  FirstAdModel.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/5/9.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstAdModel : NSObject
@property (nonatomic, copy) NSString *img;      //广告文件
@property (nonatomic, copy) NSString *path;       //信息ID
@property (nonatomic, copy) NSString *title;      //广告类型

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
