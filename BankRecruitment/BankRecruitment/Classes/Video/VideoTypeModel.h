//
//  VideoTypeModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoTypeModel : NSObject
@property (nonatomic, copy) NSString *VType;      //视频大类
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *type_num;
@property (nonatomic, copy) NSString *video_num;

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
