//
//  SearchViewController.h
//  UISearchControllerDemo
//
//  Created by 周博 on 2017/12/13.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionListModel.h"
typedef void(^searchClickBlock)(QuestionListModel * model);
@interface SearchViewController :BaseViewController
@property (nonatomic ,copy)searchClickBlock block;
@property (nonatomic ,copy)NSString *searchStr;
@end
