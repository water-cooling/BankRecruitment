//
//  LiveClassScheduleModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/4.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveClassScheduleModel : NSObject
@property (nonatomic, copy) NSString *AFile;      //视频文件
@property (nonatomic, copy) NSString *BegDate;    //授课开始
@property (nonatomic, copy) NSString *EndDate;    //授课结束
@property (nonatomic, copy) NSString *Intro;    //课时说明
@property (nonatomic, copy) NSString *LID;    //LID
@property (nonatomic, copy) NSString *Resume;    //老师简历
@property (nonatomic, copy) NSString *SID;     //SID
@property (nonatomic, copy) NSString *TecheAFile;   //老师照片
@property (nonatomic, copy) NSString *TecheID;    //老师ID
@property (nonatomic, copy) NSString *TecheIntro;   //老师业务
@property (nonatomic, copy) NSString *TecheName;    //老师姓名
@property (nonatomic, copy) NSString *materials;    //讲义文件

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
