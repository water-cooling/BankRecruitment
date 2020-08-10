//
//  DBYChatEventInfo.h
//  DBYSDKDemo01
//
//  Created by Michael on 16/10/13.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBYChatEventInfo : NSObject
//时间戳(毫秒)
@property(nonatomic,assign)NSTimeInterval recordTime;
//相对音频时间(秒)
@property(nonatomic,assign)NSTimeInterval relativeTime;

//用户名
@property(nonatomic,copy)NSString* userName;
//用户id
@property(nonatomic,copy)NSString* uid;
//图片链接
@property(nonatomic,copy)NSString* imageUrl;
//用户类型 （2是学生 1是老师 4是助教）
@property(nonatomic,assign)int role;
//聊天内容
@property(nonatomic,copy)NSString* message;
@end
