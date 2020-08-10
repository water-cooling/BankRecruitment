//
//  DBYChatInfo.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/10.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYChatInfo.h"

@implementation DBYChatInfo


//NSDictionary*chatDictInfo = @{@"userName":userName,@"message":msg,@"role":@(role),@"isOwner":@([manager.uid isEqualToString:uid]),@"time":[NSDate dateWithTimeIntervalSince1970:time],@"uid":uid};

-(instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
//        self.userName = [dict objectForKey:@"userName"];
//        self.message = [dict objectForKey:@"message"];
//        self.role = [[dict objectForKey:@"role"]intValue];
//        self.isOwner = [[dict objectForKey:@"isOwner"]boolValue];
//        self.time = [dict objectForKey:@"time"];
//        self.uid = [dict objectForKey:@"uid"];
    }
    return self;
}

+(instancetype)chatInfoWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}


-(NSString *)timeStr
{
    if (_timeStr == nil) {
        NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"HH:mm:ss";
        _timeStr =  [formatter stringFromDate:self.time];
    }
    return _timeStr;
}
@end
