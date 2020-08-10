//
//  NSDate+Helper.h
//  SuningEBuy
//
//  Created by 刘坤 on 12-8-30.
//  Copyright (c) 2012年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

/*tools*/

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)formatString;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString;

//add by cuizl  计算某一天到达现在的天数
+(NSInteger) daysFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;

//add by snping :get the weekday of a special date
// return : a string ex: 周三
+(NSString *)getWeekdayByDate:(NSDate *)date;

// yyyy-MM-dd HH:mm:ss
+ (NSString *)timeFormart:(NSString *)formartString;

+ (NSString *)nowTimeStringWithFormart:(NSString *)formart;

+ (NSString *)stringdateFromString:(NSDate  *)string withFormat:(NSString *)formatString;


@end
