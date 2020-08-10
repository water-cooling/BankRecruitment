//
//  FirstpageModule.h
//  Recruitment
//
//  Created by 夏建清 on 2018/6/9.
//  Copyright © 2018年 LongLian. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface FirstpageModule : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *url_type;

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
