//
//  MineFunctionBtnTableViewCell.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MineFunctionBtnTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation MineFunctionBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 189.5, Screen_Width, 0.5)];
//    lineLabel.backgroundColor = kColorLineSepBackground;
//    [self addSubview:lineLabel];
    
    self.functionBtnPageControl.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//改变滚动视图的方法实现
- (void)setupFunctionsPage:(id)sender
{
    self.functionBtnPageControl.currentPageIndicatorTintColor = kColorSelect;
    self.functionBtnPageControl.pageIndicatorTintColor = kColorLineSepBackground;
    //设置委托
    self.functionBtnScrollView.delegate = self;
    //设置背景颜色
    self.functionBtnScrollView.backgroundColor = [UIColor clearColor];
    //设置取消触摸
    self.functionBtnScrollView.canCancelContentTouches = NO;
    //设置滚动条类型
    self.functionBtnScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    //是否自动裁切超出部分
    self.functionBtnScrollView.clipsToBounds = YES;
    //设置是否可以缩放
    self.functionBtnScrollView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    self.functionBtnScrollView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.functionBtnScrollView.directionalLockEnabled = NO;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.functionBtnScrollView.alwaysBounceHorizontal = NO;
    self.functionBtnScrollView.alwaysBounceVertical = NO;
    self.functionBtnScrollView.showsHorizontalScrollIndicator = NO;
    self.functionBtnScrollView.showsVerticalScrollIndicator = NO;
    //用来记录页数
    NSUInteger pages = 0;
    //用来记录scrollView的x坐标
    int originX = 0;
    if(self.functionBtnDictLists.count > 5)
    {
        pages = 2;
        originX = Screen_Width*2;
    }
    else
    {
        pages = 1;
        originX += Screen_Width;
    }
    
    for(int index = 0; index < self.functionBtnDictLists.count; index++)
    {
        NSDictionary *dict = [self.functionBtnDictLists objectAtIndex:index];
        NSString *pic_name = [dict objectForKey:@"path"];
        NSString *pic_title = [dict objectForKey:@"title"];
        
        //创建一个视图
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [functionBtn setBackgroundImage:[UIImage imageNamed:pic_name] forState:UIControlStateNormal];
        functionBtn.tag = index;
        [functionBtn addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *functionLabel = [[UILabel alloc] init];
        functionLabel.font = [UIFont systemFontOfSize:12.];
        functionLabel.textColor = UIColorFromHex(0x444444);
        functionLabel.text = pic_title;
        functionLabel.textAlignment = NSTextAlignmentCenter;
        
        int hang = index/5;
        if(hang > 1)
        {
            hang -= 2;
        }
        int lie = index%5;
        int firstkongxi = 25;
        if(iPhone5)
        {
            firstkongxi = 18;
        }
        
        int iconWidth = 50;
        if(iPhone5)
        {
            iconWidth = 40;
        }
        int kongxi = (Screen_Width - iconWidth*self.functionBtnDictLists.count - firstkongxi*2)/(self.functionBtnDictLists.count-1);
        int xwidth = 0;
        if(index > 5)
        {
            xwidth = Screen_Width;
        }
        
        functionBtn.frame = CGRectMake(xwidth+firstkongxi+kongxi*(lie)+iconWidth*lie, 6*(hang+1)+65*hang, iconWidth, iconWidth);
        functionLabel.frame = CGRectMake(functionBtn.left-10, functionBtn.bottom+1, functionBtn.width+20, 21);
        
        //把视图添加到当前的滚动视图中
        [self.functionBtnScrollView addSubview:functionBtn];
        [self.functionBtnScrollView addSubview:functionLabel];
    }
    
    
    //设置页码控制器的响应方法
    [self.functionBtnPageControl addTarget:self action:@selector(changeFunctionsPage:) forControlEvents:UIControlEventValueChanged];
    //设置总页数
    self.functionBtnPageControl.numberOfPages = pages;
    //默认当前页为第一页
    self.functionBtnPageControl.currentPage = 0;
    //为页码控制器设置标签
    self.functionBtnPageControl.tag = 110;
    //设置滚动视图的位置
    [self.functionBtnScrollView setContentSize:CGSizeMake(originX, 10)];
    
}

- (void)functionBtnAction:(UIButton *)btn
{
    [self.delegate MineFunctionBtnPressed:btn.tag];
}

//改变页码的方法实现
- (void)changeFunctionsPage:(id)sender
{
    NSLog(@"指示器的当前索引值为:%li",(long)self.functionBtnPageControl.currentPage);
    //获取当前视图的页码
    CGRect rect = self.functionBtnScrollView.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = self.functionBtnPageControl.currentPage * Screen_Width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [self.functionBtnScrollView scrollRectToVisible:rect animated:YES];
}

//实现协议UIScrollViewDelegate的方法，必须实现的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //切换改变页码，小圆点
    CGFloat pageWith = Screen_Width;
    int currentPage = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;;
    self.functionBtnPageControl.currentPage = currentPage;
}

@end
