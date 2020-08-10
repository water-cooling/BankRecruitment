//
//  MineFunctionBtnTableViewCell.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MineFunctionBtnFunc <NSObject>
- (void)MineFunctionBtnPressed:(NSInteger)index;
@end
@interface MineFunctionBtnTableViewCell : UITableViewCell<UIScrollViewDelegate>
//滚动视图对象
@property (nonatomic ,strong) IBOutlet UIScrollView *functionBtnScrollView;
//视图中小圆点，对应视图的页码
@property (retain, nonatomic) IBOutlet UIPageControl *functionBtnPageControl;
//动态数组对象，存储图片
@property (copy, nonatomic) NSArray *functionBtnDictLists;

@property (nonatomic, assign) id<MineFunctionBtnFunc> delegate;

- (void)setupFunctionsPage:(id)sender;

@end
