//
//  DBY1VNPlaybackViewController.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/13.
//  Copyright © 2017年 Michael. All rights reserved.
//  H5在线回放

#import <UIKit/UIKit.h>

@interface DBY1VNPlaybackViewController : UIViewController
//如果有链接，从链接进，没有就根据其他参数拼链接进教室
@property(nonatomic,copy)NSString*enterURL;

@property(nonatomic,copy)NSString*appkey;

@property(nonatomic,copy)NSString*partnerID;

@property(nonatomic,copy)NSString*uid;

@property(nonatomic,copy)NSString*nickName;

@property(nonatomic,copy)NSString* roomID;
@end
