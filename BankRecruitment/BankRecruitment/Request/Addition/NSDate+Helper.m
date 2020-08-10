//
//  NSDate+Helper.m
//  SuningEBuy
//
//  Created by 刘坤 on 12-8-30.
//  Copyright (c) 2012年 Suning. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//add by cuizl  计算某一天到达现在的天数
+(NSInteger) daysFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    
    NSUInteger unitFlags =NSDayCalendarUnit;
    
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:fromDate toDate:toDate  options:0];
    
    //TT_RELEASE_SAFELY(chineseClendar);
    
    return [cps day];
}

+(NSString *)getWeekdayByDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps =[calendar components:NSCalendarUnitWeekday fromDate:date];
    if (!comps) {
        return nil;
    }
    NSString *weekStr = nil;
    NSInteger week = [comps weekday];
    
    if(week==1)
    {
        weekStr=@"周日";
    }else if(week==2){
        weekStr=@"周一";
        
    }else if(week==3){
        weekStr=@"周二";
        
    }else if(week==4){
        weekStr=@"周三";
        
    }else if(week==5){
        weekStr=@"周四";
        
    }else if(week==6){
        weekStr=@"周五";
        
    }else if(week==7){
        weekStr=@"周六";
    }
    
    return weekStr;
}

+ (NSString *)timeFormart:(NSString *)formartString {
    if (nil == formartString || formartString.length != 19) {
        return nil;
    }else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:formartString];
        
        // 秒数
        NSTimeInterval timeInteraval = [[NSDate date] timeIntervalSinceDate:date];
        long long interval = (long long)timeInteraval;
        if (interval < 60) {
            return @"刚刚";
        }else {
            // 分钟
            long long minutes   = interval/60;
            
            if (minutes < 60) {
                return [NSString stringWithFormat:@"%d分钟前",(int)minutes];
            }else {
                long long hours     = minutes/60;
                if (hours < 24) {
                    return [NSString stringWithFormat:@"%d小时前",(int)hours];
                }else {
                    int days = (int)(hours/24);
                    if (days > 30 && days <= 90) {
                        return @"一个月前";
                    }else if (days > 90) {
                        return @"三个月前";
                    }else {
                        return [NSString stringWithFormat:@"%d天前",days];
                    }
                }
            }
        }
    }
}

+ (NSString *)nowTimeStringWithFormart:(NSString *)formart {
    if (nil != formart) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:formart];
        return ([formatter stringFromDate:[NSDate date]]);
    }else {
        return nil;
    }
}

+ (NSString *)stringdateFromString:(NSDate *)date withFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    if (nil == currentDateStr || currentDateStr.length != 19) {
        return nil;
    }else { // {{{ ---
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:currentDateStr];
        
        // 秒数
        NSTimeInterval timeInteraval = [[NSDate date] timeIntervalSinceDate:date];
        long long interval = (long long)timeInteraval;
        if (interval < 60) {
            return @"刚刚";
        }else {
            // 分数
            long long minutes   = interval/60;
            
            if (minutes < 60) {
                return [NSString stringWithFormat:@"%d分钟前",(int)minutes];
            }else {
                long long hours     = minutes/60;
                if (hours < 24) { // 2
                    return [NSString stringWithFormat:@"%d小时前",(int)hours];
                }else {
                    int days = (int)(hours/24);
                    if(days<30){
                        return [NSString stringWithFormat:@"%d天前",days];
                    }if(days>30&&days<360){
                        
                    }
                    
                    switch (days/30) {
                        case 1:
                            return @"1个月前";
                            break;
                        case 2:
                            return @"2个月前";
                            break;
                        case 3:
                            return @"3个月前";
                            break;
                        case 4:
                            return @"4个月前";
                            break;
                        case 5:
                            return @"5个月前";
                            break;
                        case 6:
                            return @"6个月前";
                            break;
                        case 7:
                            return @"7个月前";
                            break;
                        case 8:
                            return @"8个月前";
                            break;
                        case 9:
                            return @"9个月前";
                            break;
                        case 10:
                            return @"10个月前";
                            break;
                        case 11:
                            return @"11个月前";
                            break;
                        default:
                            return @"一年前";
                            break;
                    }
                }
            }
        }
    }
}


@end
