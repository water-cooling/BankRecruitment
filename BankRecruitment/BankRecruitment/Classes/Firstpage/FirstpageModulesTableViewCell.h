//
//  FirstpageModulesTableViewCell.h
//  ZhiLi
//
//  Created by linus on 2017/1/12.
//  Copyright © 2017年 xia jianqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstpageModulesFunctionBtnFunc <NSObject>
- (void)FirstTableCellHeadFunctionBtnPressed:(NSInteger)index;
@end

@interface FirstpageModulesTableViewCell : UITableViewCell<UIScrollViewDelegate>
//滚动视图对象
@property (nonatomic ,strong) IBOutlet UIScrollView *functionBtnScrollView;
//视图中小圆点，对应视图的页码
@property (retain, nonatomic) IBOutlet UIPageControl *functionBtnPageControl;
//动态数组对象，存储图片
@property (copy, nonatomic) NSArray *functionBtnDictLists;

@property (nonatomic, assign) id<FirstpageModulesFunctionBtnFunc> delegate;

- (void)setupFunctionsPage:(id)sender;
@end
