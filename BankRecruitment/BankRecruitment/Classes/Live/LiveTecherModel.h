//
//  LiveTecherModel.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/4.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveTecherModel : NSObject
@property (nonatomic, copy) NSString *Resume;      //简历
@property (nonatomic, copy) NSString *TecheAFile;       //照片文件
@property (nonatomic, copy) NSString *TecheID;     //老师ID
@property (nonatomic, copy) NSString *TecheIntro;    //业务介绍
@property (nonatomic, copy) NSString *TecheName;    //姓名

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
