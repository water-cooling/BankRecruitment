//
//  DBYChatTableViewCell.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/10.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString* const kDBYBaseChatTableViewCellReuseID;
extern CGFloat const kDBYBaseChatTableViewCellHeight;
@class DBYChatInfo;
@interface DBYBaseChatTableViewCell : UITableViewCell
@property(nonatomic,strong)DBYChatInfo* chatInfo;
@end
