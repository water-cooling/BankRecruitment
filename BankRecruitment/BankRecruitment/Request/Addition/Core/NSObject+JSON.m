//
//  NSObject+JSON.m
//  SuningEBuy
//
//  Created by @xzoscar
//  Copyright (c) 2016年 Suning. All rights reserved.
//

#import "NSObject+JSON.h"
#import "JSONKit.h"

@implementation NSObject (JSON)

/*!
 @author 徐韦, 16-03-04 14:03:34
 
 @brief Generate JSON data from a Foundation object
 
 @return A NSString instance
 
 @since 5.0
 */
- (id)JSONRepresentation {
    
    if ( [NSJSONSerialization isValidJSONObject:self] )
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                        options:0
                                          error:&error];
#ifdef DEBUG
        if (nil != error) {
            NSLog(@"-JSONRepresentation failed. Error is : %@", error);
        }
#endif
        if (nil != jsonData) {
           return ([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        }
    }
    
    return nil;
}

@end

#pragma mark ----------------------------- json parser

@implementation NSString (JSON)

/*!
 @author 徐韦, 16-03-04 14:03:36
 
 @brief Create a Foundation object from JSON String
 
 @return return a Foundation object
 
 @since 5.0
 */
- (id)JSONValue2 {
    if (nil != self) {
        NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:0
                                                   error:&error];
        if (nil != error) {
            // 尝试一次”非法json“兼容处理
            NSString *string = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
            string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            string = [string stringByReplacingOccurrencesOfString:@"" withString:@"_"];
            jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:0
                                                    error:&error];

            //最后一次尝试用jsonkit解析
            if (nil != error) {
                obj = [jsonData objectFromJSONData];
            }

        }
        return obj;
    }
    return nil;
}

@end


@implementation NSData (JSON)

/*!
 @author 徐韦, 16-03-04 14:03:01
 
 @brief Create a Foundation object from JSON Data
 
 @return return a Foundation object
 
 @since 5.0
 */
- (id)JSONValue2 {
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:self
                                             options:0
                                               error:&error];
#ifdef DEBUG
    if (nil != error) {
        NSLog(@"-JSONValue failed. Error is: %@", error);
    }
#endif
    
    return obj;
}

@end