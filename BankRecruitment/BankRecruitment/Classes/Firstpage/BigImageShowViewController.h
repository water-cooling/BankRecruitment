//
//  BigImageShowViewController.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/7/1.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigImageShowViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *imageUrlList;

- (void)setupImagesPage:(id)sender;
@end
