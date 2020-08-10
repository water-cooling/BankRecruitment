//
//  FirstPageHeadTableViewCell.h
//  ZHILI
//
//  Created by linus on 15/9/17.
//  Copyright (c) 2017年 ZTE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
#import "FirstAdModel.h"

@protocol FirstTableCellHeadFunctionBtnFunc <NSObject>
- (void)FirstTableCellHeadImageTap:(NSInteger)index;
@end

@interface FirstPageHeadTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, assign) id<FirstTableCellHeadFunctionBtnFunc> delegate;

@property (nonatomic, strong) IBOutlet UILabel *upLabel;
//滚动视图对象
@property (nonatomic ,strong) IBOutlet UIScrollView *upScrollView;
//视图中小圆点，对应视图的页码
@property (retain, nonatomic) SMPageControl *upPageControl;
//动态数组对象，存储图片
@property (copy, nonatomic) NSArray *upImages;


@property (nonatomic, strong) NSTimer *timer;

- (void)setupImagesPage:(id)sender;

@end
