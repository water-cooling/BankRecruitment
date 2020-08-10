//
//  VideoSelectViewController.h
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoCatalogModel;
typedef void (^VideoSelectViewControllerBlock)(NSInteger selectIndex);

@interface VideoSelectViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *typeList;
@property (nonatomic, assign) NSInteger selectedTypeIndex;
@property (nonatomic, copy) VideoSelectViewControllerBlock videoSelectViewControllerBlock;

- (void)refreshRemoteMessageVideoListBy:(VideoCatalogModel *)model;

@end
