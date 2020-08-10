//
//  DataBaseManager.h
//  ZhiliGou
//
//  Created by xia jianqing on 17/2/11.
//  Copyright © 2017年 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ExamDetailModel;
@class BuyCarModel;
@class ExamOperaterModel;

@interface DataBaseManager : NSObject

+ (instancetype)sharedManager;

/**
 *  建立证券相关表
 */
- (void)createTable;

/**
 *  增加试题数据
 */
- (BOOL)addExamDetail:(ExamDetailModel *)model;

/**
 *  OID
 */
- (NSArray<ExamDetailModel *> *)getExamDetailListByOID:(NSString *)OID;

/**
 *  EID
 */
- (NSArray<ExamDetailModel *> *)getExamDetailListByEID:(NSString *)EID isFromIntelligent:(NSString *)isFromIntelligent;

- (BOOL)addUserOperate:(ExamOperaterModel *)model;

- (BOOL)updateUserOperate:(ExamOperaterModel *)model;

/**
 *  取出一道试题的操作记录
 */
- (ExamOperaterModel *)getExamOperationListByExamID:(NSString *)ExamID EID:(NSString *)EID OID:(NSString *)OID isFromOutLine:(NSString *)isFromOutLine isFromIntelligent:(NSString *)isFromIntelligent;

/**
 *  根据IOD
 */
- (ExamOperaterModel *)getExamOperationListByOID:(NSString *)OID isFromOutLine:(NSString *)isFromOutLine;

/**
 *  根据EID
 */
- (ExamOperaterModel *)getExamOperationListByEID:(NSString *)EID isFromIntelligent:(NSString *)isFromIntelligent;

- (BOOL)deleteUserOperateByExamID:(NSString *)ExamID EID:(NSString *)EID OID:(NSString *)OID isFromOutLine:(NSString *)isFromOutLine isFromIntelligent:(NSString *)isFromIntelligent;

@end
