//
//  NSString.h
//  HealthCloud
//
//  Created by lihaibo on 15/10/26.
//  Copyright © 2015年 bomei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

- (BOOL)isContainedChinese;
- (NSString *)md5;
- (id)parseToArrayOrNSDictionary;
- (BOOL)isPureFloat;
- (NSDate *)dateFromStringFormat:(NSString *)format;
- (NSDate *)dateFromSecondString;
- (NSDate *)dateFromFullString;
- (NSDate *)dateFromShortString;

- (NSString *)validLength;

- (NSString *) ossDateFormat;

//以下是数据的验证部分
- (NSString *)trim;//去除两端空格
- (NSString *)trimAllSpace;//去除所有空格
- (NSString *)whiteSpceText;//每四个加一个空格
- (NSString *)nameText;
//验证字符串是否包含特殊字符
- (BOOL)isIncludeSpecialCharact;
- (NSString *)wy_stringByAppendingUrlPathComponent:(NSString *)str;

- (NSString *)wy_increaseString;
- (NSString *)wy_displayMoneyAndUnit;
- (NSString *)wy_displayMoney;

- (BOOL)wy_true;

- (NSString *)smallMD5;

@end
