//
//  NSString.m
//  HealthCloud
//
//  Created by lihaibo on 15/10/26.
//  Copyright © 2015年 bomei. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>

#define kOSSIMAGEBASEFILEURL                 [NSString stringWithFormat:@"http://%@.%@/",kOSSBULKETKEY,kOSSDOMAINURL]

@implementation NSString (Common)

- (BOOL)isContainedChinese{
    NSUInteger length = self.length;
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isPureFloat{
    if ([self containsString:@"."]) {
        return YES;
    }
    return NO;

}

- (NSString *)md5{

    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  [output uppercaseString];
}

- (id)parseToArrayOrNSDictionary{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

- (NSDate *)dateFromStringFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:format];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)dateFromSecondString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)dateFromFullString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)dateFromShortString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSString *)validLength {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *) ossDateFormat {
    NSArray *aArray = [self componentsSeparatedByString:@"/"];
    
    return aArray[1];
}

//数据验证部分
- (NSString *)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimAllSpace{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)whiteSpceText{
    NSInteger index = self.length / 4;
    if (self.length % 4 == 0) {
        index--;
    }
    NSMutableString *whiteSpceText = [self mutableCopy];
    for(int i = 1 ; i <= index ; i++){
        [whiteSpceText insertString:@" " atIndex: i * 5 - 1];
    }
    return whiteSpceText;
}

- (NSString *)nameText{
    if (self.length < 1) {
        return @"";
    }else{
        return [self stringByReplacingOccurrencesOfString:[self substringToIndex:1] withString:@"*"];
    }
}

-(BOOL)isIncludeSpecialCharact{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

- (NSString *)wy_stringByAppendingUrlPathComponent:(NSString *)str{
    return [[[self stringByAppendingPathComponent:str] stringByReplacingOccurrencesOfString:@"http://" withString:@"http:/"] stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
}

- (NSString *)wy_increaseString{
    NSInteger num = self.integerValue;
    return [NSString stringWithFormat:@"%ld",(long)(num + 1)];
}

- (NSString *)wy_displayMoneyAndUnit{
    return [NSString stringWithFormat:@"%@元",[self wy_displayMoney]];
}

- (NSString *)wy_displayMoney{
    return [NSString stringWithFormat:@"%.2f",self.floatValue];
}

- (BOOL)wy_true{
    return [self caseInsensitiveCompare:@"Y"] == NSOrderedSame;
}

- (NSString *)smallMD5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

/**
 计算文字大小(size)

 @param fontSize 文字大小
 @param widht 文字宽度，如果为‘0’或者‘MAXFLOAT’或者‘CGFLOAT_MAX’，该方法为计算文字宽度
 @param height 文字高度，如果为‘0’或者‘MAXFLOAT’或者‘CGFLOAT_MAX’，该方法为计算文字高度
 @return 返回文字的size
 */
- (CGSize)sizeWithFont:(CGFloat)fontSize textSizeWidht:(CGFloat)widht textSizeHeight:(CGFloat)height {
    
    if (widht == MAXFLOAT || widht == CGFLOAT_MAX || widht == 0) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
        return CGSizeMake(rect.size.width + 8, height);
    } else if (height == MAXFLOAT || height == CGFLOAT_MAX || height == 0) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(widht, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
        
        return CGSizeMake(widht, rect.size.height + 8);
    }
    return CGSizeMake(0, 0);
}

@end
