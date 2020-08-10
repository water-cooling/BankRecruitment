//
//  DBYChatInfo.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/10.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBYChatInfo : NSObject
@property(nonatomic,copy)NSString*userName;
@property(nonatomic,copy)NSString*message;
@property(nonatomic,copy)NSString*uid;
@property(nonatomic,assign)int role;
@property(nonatomic,assign)BOOL isOwner;
@property(nonatomic,strong)NSDate* time;

//发送时间格式化后的字符串
@property(nonatomic,copy)NSString* timeStr;

+(instancetype)chatInfoWithDict:(NSDictionary*)dict;
@end

//NSDictionary*chatDictInfo = @{@"userName":userName,@"message":msg,@"role":@(role),@"isOwner":@([manager.uid isEqualToString:uid]),@"time":[NSDate dateWithTimeIntervalSince1970:time],@"uid":uid};
