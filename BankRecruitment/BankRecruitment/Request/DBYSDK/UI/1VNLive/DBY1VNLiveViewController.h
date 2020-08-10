//
//  DBY1VNLiveViewController.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/3/31.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBY1VNLiveViewController : UIViewController

//进教室链接 设置进教室链接优先用链接进教室
@property(nonatomic,copy)NSString* enterURLString;


@property(nonatomic,copy)NSString* inviteCode;

//机构appkey
@property(nonatomic,copy)NSString* appkey;
//机构partnerID
@property(nonatomic,copy)NSString* partnerID;

@property(nonatomic,copy)NSString* userID;

@property(nonatomic,copy)NSString* nickName;

@property(nonatomic,copy)NSString* roomID;

@property(nonatomic,assign)BOOL allowRaiseHand;
@end
