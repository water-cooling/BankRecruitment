//
//  RemoteMessageModel.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 消息列表
 
 消息ID  ：ID
 关联ID  ：LinkID
 消息标题：Name
 消息体  ：Msg
 消息URL：MsgURL
 推送类别：mType
 发送时间：BegTime
 截止时间：EndTime
 创建时间：CreateTime
 消息方式：sType
 会员ID  ：uid
 发送状态 ：SendState
 */

//友盟消息
@interface RemoteMessageModel : NSObject
@property (nonatomic, copy) NSString *notify_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *msgUrl;
@property (nonatomic, copy) NSString *mType;
@property (nonatomic, copy) NSString *linkId;

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
