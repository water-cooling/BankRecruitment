//
//  NoteModel.h
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property (nonatomic, copy) NSString *ID;      //笔记ID
@property (nonatomic, copy) NSString *Date;       //笔记日期
@property (nonatomic, copy) NSString *LinkID;      //题库ID
@property (nonatomic, copy) NSString *Note;    //笔记内容

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;

@end
