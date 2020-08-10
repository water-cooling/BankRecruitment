//
//  VideoModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
@property (nonatomic, copy) NSString *cID;      //视频目录
@property (nonatomic, copy) NSString *ID;    //视频ID
@property (nonatomic, copy) NSString *OrdID;    //序号
@property (nonatomic, copy) NSString *Name;      //视频标题
@property (nonatomic, copy) NSString *Points;      //知识要点
@property (nonatomic, copy) NSString *AFile;      //视频文件
@property (nonatomic, copy) NSString *EID;      //练习试题
@property (nonatomic, copy) NSString *VTime;      //时长

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
