//
//  VideoViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/27.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoCatalogModel;
@class VideoTypeModel;
@interface VideoViewController : UIViewController
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) VideoTypeModel *typeModel;
@property (nonatomic, strong) VideoCatalogModel *remoteMessageVideoModel;

- (void)refreshCurrentVideoList;

@end
