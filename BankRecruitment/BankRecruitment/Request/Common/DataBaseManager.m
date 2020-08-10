//
//  DataBaseManager.m
//  ZhiliGou
//
//  Created by xia jianqing on 17/2/11.
//  Copyright © 2017年 ZTE. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDB.h"
#import "ExamDetailModel.h"
#import "ExamDetailOptionModel.h"
#import "ExamOperaterModel.h"

@interface DataBaseManager ()

@property (nonatomic, strong) FMDatabase* db;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation DataBaseManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[DataBaseManager alloc] init];
        [instance createTable];
    });
    
    return instance;
}

//获得数据库在沙盒中的路径
- (NSString *)cb_getDBPath
{
    NSString *docPaths = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPaths stringByAppendingPathComponent:@"BankRecruitment.sqlite"];
    return dbPath;
}

/**
 *  建表
 */
- (void)createTable {
    NSString *dbPath = [self cb_getDBPath];
    self.db = [FMDatabase databaseWithPath:dbPath];
    
    if ([self.db open]) {
        NSString *ExamDetailTable = [NSString stringWithFormat:
                                             @"create table if not exists ExamDetailTable\n"
                                             "(pid INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                                             "isFromIntelligent text,\n"
                                             "isFromOutLine text,\n"
                                             "ID text,\n"
                                             "EID text,\n"
                                             "OID text,\n"
                                             "ordID text,\n"
                                             "titleID text,\n"
                                             "score text,\n"
                                             "ATime text,\n"
                                             "answer text,\n"
                                             "isOK text,\n"
                                             "getScore text,\n"
                                             "userTime text,\n"
                                             "bank text,\n"
                                             "TYear text,\n"
                                             "QType text,\n"
                                             "content text,\n"
                                             "QPoint text,\n"
                                             "isBank text,\n"
                                             "title text,\n"
                                             "ID_Ord1 text,\n"
                                             "CCount text,\n"
                                             "ord text,\n"
                                             "CDate text,\n"
                                             "solution text,\n"
                                             "analysis text,\n"
                                             "material text,\n"
                                             "totalCount text,\n"
                                             "rightCount text,\n"
                                             "errCount text,\n"
                                             "badAnswer text)\n"
                                             ];
        BOOL resStockInfo = [self.db executeUpdate:ExamDetailTable];
        if (!resStockInfo) {
            NSLog(@"error when creating ExamDetailTable table");
        } else {
            NSLog(@"success to creating ExamDetailTable table");
        }
        
        NSString *ExamDetailOptionTable = [NSString stringWithFormat:
                                     @"create table if not exists ExamDetailOptionTable\n"
                                     "(pid INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                                     "titleListID text,\n"
                                     "orderID text,\n"
                                     "single text,\n"
                                     "SList text,\n"
                                     "ExamID text)\n"
                                     ];
        resStockInfo = [self.db executeUpdate:ExamDetailOptionTable];
        if (!resStockInfo) {
            NSLog(@"error when creating ExamDetailOptionTable table");
        } else {
            NSLog(@"success to creating ExamDetailOptionTable table");
        }
        
        NSString *UserExamOperationTable = [NSString stringWithFormat:
                                           @"create table if not exists UserExamOperationTable\n"
                                           "(pid INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                                            "user_id text,\n"
                                            "ExamID text,\n"
                                            "Answer text,\n"
                                            "GetScore text,\n"
                                            "isOK text,\n"
                                            "TagFlag text,\n"
                                            "EID text,\n"
                                            "isFromIntelligent text,\n"//是否是从智能练习／智能组卷进来的
                                            "isFromOutLine text,\n"//是否是从首页提纲进来的
                                            "OID text,\n"
                                            "isSelected text)\n"
                                           ];
        resStockInfo = [self.db executeUpdate:UserExamOperationTable];
        if (!resStockInfo) {
            NSLog(@"error when creating UserExamOperationTable table");
        } else {
            NSLog(@"success to creating UserExamOperationTable table");
        }
    }
}

/**
 *  增加试题数据
 */
- (BOOL)addExamDetail:(ExamDetailModel *)model {
    BOOL isSuccess = NO;
    if ([self.db open]) {
       NSArray *modelList = [self getExamDetailListByID:model.ID isFromIntelligent:model.isFromIntelligent OID:model.OID isFromOutLine:model.isFromOutLine];
        if(modelList.count > 0)
        {
            return NO;
        }
        NSString *sql =[NSString stringWithFormat:@"INSERT INTO ExamDetailTable(isFromIntelligent,isFromOutLine,ID,EID,OID,ordID,titleID,score,ATime,answer,isOK,getScore,userTime,bank,TYear,QType,content,QPoint,isBank,title,ID_Ord1,CCount,ord,CDate,solution,analysis,material,totalCount,rightCount,errCount,badAnswer) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", model.isFromIntelligent, model.isFromOutLine, model.ID, model.EID, model.OID, model.ordID, model.titleID, model.score, model.ATime, [model.answer stringByReplacingOccurrencesOfString:@"'" withString:@"''"], model.isOK, model.getScore, model.userTime, model.bank, model.TYear, model.QType, [model.content stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [model.QPoint stringByReplacingOccurrencesOfString:@"'" withString:@"''"], model.isBank, [model.title stringByReplacingOccurrencesOfString:@"'" withString:@"''"], model.ID_Ord1, model.CCount, model.ord, model.CDate, [model.solution stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [model.analysis stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [model.material stringByReplacingOccurrencesOfString:@"'" withString:@"''"], model.totalCount, model.rightCount, model.errCount, model.badAnswer];
        isSuccess = [self.db executeUpdate:sql];
        if(!isSuccess)
        {
            NSLog(@"error when INSERT INTO ExamDetailTable");
            return NO;
        }
        
        for(ExamDetailOptionModel *optionModel in model.list_TitleList)
        {
            NSString *sql =[NSString stringWithFormat:@"INSERT INTO ExamDetailOptionTable(titleListID,orderID,single,SList,ExamID) values ('%@','%@','%@','%@','%@')", optionModel.titleListID,optionModel.orderID,optionModel.single,[optionModel.SList stringByReplacingOccurrencesOfString:@"'" withString:@"''"],model.ID];
            isSuccess = [self.db executeUpdate:sql];
            if(!isSuccess)
            {
                NSLog(@"error when INSERT INTO ExamDetailOptionTable");
            }
        }
    }
    return isSuccess;
}

/**
 *  OID
 */
- (NSArray<ExamDetailModel *> *)getExamDetailListByID:(NSString *)ID isFromIntelligent:(NSString *)isFromIntelligent OID:(NSString *)OID isFromOutLine:(NSString *)isFromOutLine{
    NSMutableArray *array = [NSMutableArray array];
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from ExamDetailTable where ID= '%@' and isFromIntelligent = '%@' and OID = '%@' and isFromOutLine = '%@'", ID, isFromIntelligent, OID, isFromOutLine];
        FMResultSet *rs =[self.db executeQuery:sql];
//        if(!rs.columnNameToIndexMap)
//        {
//            return nil;
//        }
        while ([rs next]) {
            ExamDetailModel *model = [ExamDetailModel model];
            model.isFromIntelligent = [rs stringForColumn:@"isFromIntelligent"];
            model.isFromOutLine = [rs stringForColumn:@"isFromOutLine"];
            model.ID = [rs stringForColumn:@"ID"];
            model.EID     = [rs stringForColumn:@"EID"];
            model.OID     = [rs stringForColumn:@"OID"];
            model.ordID    = [rs stringForColumn:@"ordID"];
            model.titleID        = [rs stringForColumn:@"titleID"];
            model.score        = [rs stringForColumn:@"score"];
            model.ATime        = [rs stringForColumn:@"ATime"];
            model.answer        = [rs stringForColumn:@"answer"];
            model.isOK        = [rs stringForColumn:@"isOK"];
            model.getScore        = [rs stringForColumn:@"getScore"];
            model.userTime        = [rs stringForColumn:@"userTime"];
            model.bank        = [rs stringForColumn:@"bank"];
            model.TYear        = [rs stringForColumn:@"TYear"];
            model.QType        = [rs stringForColumn:@"QType"];
            model.content        = [rs stringForColumn:@"content"];
            model.QPoint        = [rs stringForColumn:@"QPoint"];
            model.isBank        = [rs stringForColumn:@"isBank"];
            model.title        = [rs stringForColumn:@"title"];
            model.ID_Ord1        = [rs stringForColumn:@"ID_Ord1"];
            model.CCount        = [rs stringForColumn:@"CCount"];
            model.ord        = [rs stringForColumn:@"ord"];
            model.CDate        = [rs stringForColumn:@"CDate"];
            model.solution        = [rs stringForColumn:@"solution"];
            model.analysis        = [rs stringForColumn:@"analysis"];
            model.material        = [rs stringForColumn:@"material"];
            model.totalCount        = [rs stringForColumn:@"totalCount"];
            model.rightCount        = [rs stringForColumn:@"rightCount"];
            model.errCount        = [rs stringForColumn:@"errCount"];
            model.badAnswer        = [rs stringForColumn:@"badAnswer"];
            
            NSMutableArray *optionArray = [NSMutableArray array];
            NSString *optionSql = [NSString stringWithFormat:@"select * from ExamDetailOptionTable where ExamID= '%@'", model.ID];
            FMResultSet *rs =[self.db executeQuery:optionSql];
            while ([rs next]) {
                ExamDetailOptionModel *optionModel = [ExamDetailOptionModel model];
                optionModel.titleListID = [rs stringForColumn:@"titleListID"];
                optionModel.orderID     = [rs stringForColumn:@"orderID"];
                optionModel.single     = [rs stringForColumn:@"single"];
                optionModel.SList    = [rs stringForColumn:@"SList"];
                [optionArray addObject:optionModel];
            }
            
            model.list_TitleList = optionArray;
            [array addObject:model];
        }
    }
    
    return array;
}

/**
 *  OID
 */
- (NSArray<ExamDetailModel *> *)getExamDetailListByOID:(NSString *)OID {
    
    NSMutableArray *array = [NSMutableArray array];
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from ExamDetailTable where OID= '%@' and isFromOutLine = '%@'", OID, @"是"];
        FMResultSet *rs =[self.db executeQuery:sql];
        while ([rs next]) {
            ExamDetailModel *model = [ExamDetailModel model];
            model.isFromIntelligent = [rs stringForColumn:@"isFromIntelligent"];
            model.isFromOutLine = [rs stringForColumn:@"isFromOutLine"];
            model.ID = [rs stringForColumn:@"ID"];
            model.EID     = [rs stringForColumn:@"EID"];
            model.OID     = [rs stringForColumn:@"OID"];
            model.ordID    = [rs stringForColumn:@"ordID"];
            model.titleID        = [rs stringForColumn:@"titleID"];
            model.score        = [rs stringForColumn:@"score"];
            model.ATime        = [rs stringForColumn:@"ATime"];
            model.answer        = [rs stringForColumn:@"answer"];
            model.isOK        = [rs stringForColumn:@"isOK"];
            model.getScore        = [rs stringForColumn:@"getScore"];
            model.userTime        = [rs stringForColumn:@"userTime"];
            model.bank        = [rs stringForColumn:@"bank"];
            model.TYear        = [rs stringForColumn:@"TYear"];
            model.QType        = [rs stringForColumn:@"QType"];
            model.content        = [rs stringForColumn:@"content"];
            model.QPoint        = [rs stringForColumn:@"QPoint"];
            model.isBank        = [rs stringForColumn:@"isBank"];
            model.title        = [rs stringForColumn:@"title"];
            model.ID_Ord1        = [rs stringForColumn:@"ID_Ord1"];
            model.CCount        = [rs stringForColumn:@"CCount"];
            model.ord        = [rs stringForColumn:@"ord"];
            model.CDate        = [rs stringForColumn:@"CDate"];
            model.solution        = [rs stringForColumn:@"solution"];
            model.analysis        = [rs stringForColumn:@"analysis"];
            model.material        = [rs stringForColumn:@"material"];
            model.totalCount        = [rs stringForColumn:@"totalCount"];
            model.rightCount        = [rs stringForColumn:@"rightCount"];
            model.errCount        = [rs stringForColumn:@"errCount"];
            model.badAnswer        = [rs stringForColumn:@"badAnswer"];
            
            NSMutableArray *optionArray = [NSMutableArray array];
            NSString *optionSql = [NSString stringWithFormat:@"select * from ExamDetailOptionTable where ExamID= '%@'", model.ID];
            FMResultSet *rs =[self.db executeQuery:optionSql];
            while ([rs next]) {
                ExamDetailOptionModel *optionModel = [ExamDetailOptionModel model];
                optionModel.titleListID = [rs stringForColumn:@"titleListID"];
                optionModel.orderID     = [rs stringForColumn:@"orderID"];
                optionModel.single     = [rs stringForColumn:@"single"];
                optionModel.SList    = [rs stringForColumn:@"SList"];
                [optionArray addObject:optionModel];
            }
            
            model.list_TitleList = optionArray;
            [array addObject:model];
        }
    }
    
    return array;
}

/**
 *  EID
 */
- (NSArray<ExamDetailModel *> *)getExamDetailListByEID:(NSString *)EID isFromIntelligent:(NSString *)isFromIntelligent {
    
    NSMutableArray *array = [NSMutableArray array];
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from ExamDetailTable where EID= '%@' and isFromOutLine = '%@' and isFromIntelligent = '%@'", EID, @"否", isFromIntelligent];
        FMResultSet *rs =[self.db executeQuery:sql];
        while ([rs next]) {
            ExamDetailModel *model = [ExamDetailModel model];
            model.isFromIntelligent = [rs stringForColumn:@"isFromIntelligent"];
            model.isFromOutLine = [rs stringForColumn:@"isFromOutLine"];
            model.ID = [rs stringForColumn:@"ID"];
            model.EID     = [rs stringForColumn:@"EID"];
            model.OID     = [rs stringForColumn:@"OID"];
            model.ordID    = [rs stringForColumn:@"ordID"];
            model.titleID        = [rs stringForColumn:@"titleID"];
            model.score        = [rs stringForColumn:@"score"];
            model.ATime        = [rs stringForColumn:@"ATime"];
            model.answer        = [rs stringForColumn:@"answer"];
            model.isOK        = [rs stringForColumn:@"isOK"];
            model.getScore        = [rs stringForColumn:@"getScore"];
            model.userTime        = [rs stringForColumn:@"userTime"];
            model.bank        = [rs stringForColumn:@"bank"];
            model.TYear        = [rs stringForColumn:@"TYear"];
            model.QType        = [rs stringForColumn:@"QType"];
            model.content        = [rs stringForColumn:@"content"];
            model.QPoint        = [rs stringForColumn:@"QPoint"];
            model.isBank        = [rs stringForColumn:@"isBank"];
            model.title        = [rs stringForColumn:@"title"];
            model.ID_Ord1        = [rs stringForColumn:@"ID_Ord1"];
            model.CCount        = [rs stringForColumn:@"CCount"];
            model.ord        = [rs stringForColumn:@"ord"];
            model.CDate        = [rs stringForColumn:@"CDate"];
            model.solution        = [rs stringForColumn:@"solution"];
            model.analysis        = [rs stringForColumn:@"analysis"];
            model.material        = [rs stringForColumn:@"material"];
            model.totalCount        = [rs stringForColumn:@"totalCount"];
            model.rightCount        = [rs stringForColumn:@"rightCount"];
            model.errCount        = [rs stringForColumn:@"errCount"];
            model.badAnswer        = [rs stringForColumn:@"badAnswer"];
            
            NSMutableArray *optionArray = [NSMutableArray array];
            NSString *optionSql = [NSString stringWithFormat:@"select * from ExamDetailOptionTable where ExamID= '%@'", model.ID];
            FMResultSet *rs =[self.db executeQuery:optionSql];
            while ([rs next]) {
                ExamDetailOptionModel *optionModel = [ExamDetailOptionModel model];
                optionModel.titleListID = [rs stringForColumn:@"titleListID"];
                optionModel.orderID     = [rs stringForColumn:@"orderID"];
                optionModel.single     = [rs stringForColumn:@"single"];
                optionModel.SList    = [rs stringForColumn:@"SList"];
                [optionArray addObject:optionModel];
            }
            
            model.list_TitleList = optionArray;
            [array addObject:model];
        }
    }
    
    return array;
}

- (BOOL)addUserOperate:(ExamOperaterModel *)model
{
    BOOL isSuccess = NO;
    if ([self.db open]) {
        if([self getExamOperationListByExamID:model.ExamID EID:model.EID OID:model.OID isFromOutLine:model.isFromOutLine isFromIntelligent:model.isFromIntelligent])
        {
            return [self updateUserOperate:model];
        }
        
        NSString *sql =[NSString stringWithFormat:@"INSERT INTO UserExamOperationTable(user_id,ExamID,Answer,GetScore,isOK,TagFlag,EID,isFromIntelligent,isFromOutLine,OID, isSelected) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", [LdGlobalObj sharedInstanse].user_id, model.ExamID, model.Answer, model.GetScore, model.isOK, model.TagFlag, model.EID, model.isFromIntelligent, model.isFromOutLine, model.OID, model.isSelected];
        isSuccess = [self.db executeUpdate:sql];
        if(!isSuccess)
        {
            NSLog(@"error when INSERT INTO UserExamOperationTable");
            return NO;
        }
    }
    return isSuccess;
}

- (BOOL)updateUserOperate:(ExamOperaterModel *)model
{
    BOOL isSuccess = NO;
    if ([self.db open]) {
        NSString *sql =[NSString stringWithFormat:@"UPDATE UserExamOperationTable SET Answer = '%@',GetScore  = '%@', isOK  = '%@', TagFlag='%@',EID='%@',isFromIntelligent = '%@',isFromOutLine = '%@',OID = '%@',isSelected = '%@' WHERE user_id = '%@' and ExamID = '%@'", model.Answer, model.GetScore, model.isOK, model.TagFlag, model.EID, model.isFromIntelligent, model.isFromOutLine, model.OID, model.isSelected, [LdGlobalObj sharedInstanse].user_id, model.ExamID];
        isSuccess = [self.db executeUpdate:sql];
        if(!isSuccess)
        {
            NSLog(@"error when UPDATE UserExamOperationTable");
            return isSuccess;
        }
    }
    return isSuccess;
}

- (BOOL)deleteUserOperateByExamID:(NSString *)ExamID EID:(NSString *)EID OID:(NSString *)OID isFromOutLine:(NSString *)isFromOutLine isFromIntelligent:(NSString *)isFromIntelligent
{
    BOOL isSuccess = NO;
    if ([self.db open]) {
        NSString* sql = @"DELETE FROM UserExamOperationTable where ExamID = ? and EID = ? and OID = ? and isFromOutLine = ? and isFromIntelligent = ? and user_id = ?";
        isSuccess=[self.db executeUpdate:sql, ExamID, EID, OID, isFromOutLine, isFromIntelligent, [LdGlobalObj sharedInstanse].user_id];
        
        if(!isSuccess)
        {
            NSLog(@"error when DELETE FROM UserExamOperationTable");
            return isSuccess;
        }
    }
    return isSuccess;
}

/**
 *  取出一道试题的操作记录
 */
- (ExamOperaterModel *)getExamOperationListByExamID:(NSString *)ExamID EID:(NSString *)EID OID:(NSString *)OID isFromOutLine:(NSString *)isFromOutLine isFromIntelligent:(NSString *)isFromIntelligent {
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from UserExamOperationTable where ExamID ='%@' and EID ='%@' and OID ='%@' and isFromOutLine ='%@' and isFromIntelligent ='%@' and user_id = '%@'", ExamID, EID, OID, isFromOutLine, isFromIntelligent, [LdGlobalObj sharedInstanse].user_id];
        FMResultSet *rs =[self.db executeQuery:sql];
        while ([rs next]) {
            ExamOperaterModel *model = [ExamOperaterModel model];
            model.user_id = [rs stringForColumn:@"user_id"];
            model.ExamID     = [rs stringForColumn:@"ExamID"];
            model.Answer     = [rs stringForColumn:@"Answer"];
            model.GetScore     = [rs stringForColumn:@"GetScore"];
            model.isOK     = [rs stringForColumn:@"isOK"];
            model.TagFlag    = [rs stringForColumn:@"TagFlag"];
            model.EID        = [rs stringForColumn:@"EID"];
            model.isFromIntelligent        = [rs stringForColumn:@"isFromIntelligent"];
            model.isFromOutLine        = [rs stringForColumn:@"isFromOutLine"];
            model.OID        = [rs stringForColumn:@"OID"];
            model.isSelected        = [rs stringForColumn:@"isSelected"];
            return model;
        }
    }
    
    return nil;
}

/**
 *  根据OID
 */
- (ExamOperaterModel *)getExamOperationListByOID:(NSString *)OID isFromOutLine:(NSString *)isFromOutLine {
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from UserExamOperationTable where OID ='%@' and isFromOutLine ='%@' and user_id = '%@'", OID, isFromOutLine, [LdGlobalObj sharedInstanse].user_id];
        FMResultSet *rs =[self.db executeQuery:sql];
        while ([rs next]) {
            ExamOperaterModel *model = [ExamOperaterModel model];
            model.user_id = [rs stringForColumn:@"user_id"];
            model.ExamID     = [rs stringForColumn:@"ExamID"];
            model.Answer     = [rs stringForColumn:@"Answer"];
            model.GetScore     = [rs stringForColumn:@"GetScore"];
            model.isOK     = [rs stringForColumn:@"isOK"];
            model.TagFlag    = [rs stringForColumn:@"TagFlag"];
            model.EID        = [rs stringForColumn:@"EID"];
            model.isFromIntelligent        = [rs stringForColumn:@"isFromIntelligent"];
            model.isFromOutLine        = [rs stringForColumn:@"isFromOutLine"];
            model.OID        = [rs stringForColumn:@"OID"];
            model.isSelected        = [rs stringForColumn:@"isSelected"];
            return model;
        }
    }
    
    return nil;
}

/**
 *  根据EID
 */
- (ExamOperaterModel *)getExamOperationListByEID:(NSString *)EID isFromIntelligent:(NSString *)isFromIntelligent {
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from UserExamOperationTable where EID ='%@' and isFromIntelligent ='%@' and user_id = '%@' and isFromOutLine ='%@'", EID, isFromIntelligent, [LdGlobalObj sharedInstanse].user_id, @"否"];
        FMResultSet *rs =[self.db executeQuery:sql];
        while ([rs next]) {
            ExamOperaterModel *model = [ExamOperaterModel model];
            model.user_id = [rs stringForColumn:@"user_id"];
            model.ExamID     = [rs stringForColumn:@"ExamID"];
            model.Answer     = [rs stringForColumn:@"Answer"];
            model.GetScore     = [rs stringForColumn:@"GetScore"];
            model.isOK     = [rs stringForColumn:@"isOK"];
            model.TagFlag    = [rs stringForColumn:@"TagFlag"];
            model.EID        = [rs stringForColumn:@"EID"];
            model.isFromIntelligent        = [rs stringForColumn:@"isFromIntelligent"];
            model.isFromOutLine        = [rs stringForColumn:@"isFromOutLine"];
            model.OID        = [rs stringForColumn:@"OID"];
            model.isSelected        = [rs stringForColumn:@"isSelected"];
            return model;
        }
    }
    
    return nil;
}

///**
// *  减少数据
// */
//- (BOOL)reduceBuyCarInfo:(BuyCarModel *)model {
//    
//    BOOL isSuccess = NO;
//    NSArray *array = [self getBuyCarListByProductID:model.fpk_id];
//    if(array.count != 0)
//    {
//        if ([self.db open]) {
//            
//            BuyCarModel *preModel = array[0];
//            
//            if(preModel.fnb_num == 1)
//            {
//                isSuccess = [self deleteBuyCarInfoById:preModel.fpk_id];
//            }
//            else
//            {
//                NSString *sql = [NSString stringWithFormat:@"UPDATE BuyCarTable SET fnb_num = %d WHERE fpk_id = '%@' and user_id = '%@'", preModel.fnb_num-1, model.fpk_id, [LdGlobalObj sharedInstanse].user_id];
//                isSuccess = [self.db executeUpdate:sql];
//            }
//            
//        }
//        return isSuccess;
//    }
//    
//    return NO;
//}
//
//
//
///**
// *  删除
// */
//- (BOOL)deleteBuyCarInfoById:(NSString *)fpk_id {
//    
//    BOOL isSuccess = NO;
//    if ([self.db open]) {
//        
//        NSString* sql = @"DELETE FROM BuyCarTable where fpk_id = ? and user_id = ?";
//        isSuccess=[self.db executeUpdate:sql,fpk_id, [LdGlobalObj sharedInstanse].user_id];
//    }
//    return isSuccess;
//    
//}
//
///**
// *  清空
// */
//- (BOOL)deleteAllBuyCar {
//    
//    BOOL isSuccess = NO;
//    if ([self.db open]) {
//        
//        NSString* sql = @"DELETE FROM BuyCarTable";
//        isSuccess=[self.db executeUpdate:sql];
//    }
//    return isSuccess;
//    
//}
//
///**
// *  取出一组数据
// */
//- (NSArray<BuyCarModel *> *)getBuyCarListByType:(NSString *)fvc_type {
//    
//    NSMutableArray *array = [NSMutableArray array];
//    if ([self.db open]) {
//        NSString *sql = [NSString stringWithFormat:@"select * from BuyCarTable where fvc_type= '%@' and user_id = '%@'", fvc_type, [LdGlobalObj sharedInstanse].user_id];
//        FMResultSet *rs =[self.db executeQuery:sql];
//        while ([rs next]) {
//            BuyCarModel *model = [BuyCarModel model];
//            model.pid = [rs intForColumn:@"pid"];;
//            model.fnb_num = [rs intForColumn:@"fnb_num"];
//            model.fpk_id = [rs stringForColumn:@"fpk_id"];
//            model.fvc_name     = [rs stringForColumn:@"fvc_name"];
//            model.fvc_pic     = [rs stringForColumn:@"fvc_pic"];
//            model.fvc_type    = [rs stringForColumn:@"fvc_type"];
//            model.fvc_type_name        = [rs stringForColumn:@"fvc_type_name"];
//            model.fvc_price      = [rs longForColumn:@"fvc_price"];
//            
//            [array addObject:model];
//        }
//    }
//    
//    return array;
//}
//
///**
// *  取出一组数据
// */
//- (NSArray<BuyCarModel *> *)getBuyCarList {
//    
//    NSMutableArray *array = [NSMutableArray array];
//    if ([self.db open]) {
//        NSString *sql = [NSString stringWithFormat:@"select * from BuyCarTable where user_id = '%@'", [LdGlobalObj sharedInstanse].user_id];
//        FMResultSet *rs =[self.db executeQuery:sql];
//        while ([rs next]) {
//            BuyCarModel *model = [BuyCarModel model];
//            model.fnb_num = [rs intForColumn:@"fnb_num"];
//            model.fpk_id = [rs stringForColumn:@"fpk_id"];
//            model.fvc_name     = [rs stringForColumn:@"fvc_name"];
//            model.fvc_pic     = [rs stringForColumn:@"fvc_pic"];
//            model.fvc_type    = [rs stringForColumn:@"fvc_type"];
//            model.fvc_type_name        = [rs stringForColumn:@"fvc_type_name"];
//            model.fvc_price      = [rs longForColumn:@"fvc_price"];
//            
//            [array addObject:model];
//        }
//    }
//    
//    return array;
//}

@end
