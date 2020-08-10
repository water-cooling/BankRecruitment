//
//  FirstPageAdScrollTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/28.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "FirstPageAdScrollTableViewCell.h"

#define kHeadScrollHeight 150

@implementation FirstPageAdScrollTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//改变滚动视图的方法实现
- (void)setupImagesPage:(id)sender
{
    if(![LdGlobalObj sharedInstanse].pageView)
    {
        [LdGlobalObj sharedInstanse].pageView = [[WSPageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadScrollHeight)];
        [LdGlobalObj sharedInstanse].pageView.minimumPageAlpha = 0.4;   //非当前页的透明比例
        [LdGlobalObj sharedInstanse].pageView.minimumPageScale = 0.85;  //非当前页的缩放比例
        [LdGlobalObj sharedInstanse].pageView.autoTime = 3;    //自动切换视图的时间,默认是5.0
        
        //初始化pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [LdGlobalObj sharedInstanse].pageView.frame.size.height - 8 - 10, kScreenWidth, 8)];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageControl.hidden = YES;
        [LdGlobalObj sharedInstanse].pageView.pageControl = pageControl;
        [[LdGlobalObj sharedInstanse].pageView addSubview:pageControl];
    }
    
    [LdGlobalObj sharedInstanse].pageView.orginPageCount = self.upImages.count; //原始页数
    [self addSubview:[LdGlobalObj sharedInstanse].pageView];
    [[LdGlobalObj sharedInstanse].pageView startTimer];
    
    if(!self.upPageControl)
    {
        self.upPageControl = [[SMPageControl alloc]initWithFrame:CGRectMake(0, kHeadScrollHeight-30, Screen_Width, 40)];
        self.upPageControl.backgroundColor=[UIColor clearColor];
        self.upPageControl.currentPageIndicatorImage = [UIImage imageNamed:@"Rectangle_white"];
        self.upPageControl.pageIndicatorImage = [UIImage imageNamed:@"Rectangle_opacity"];
        self.upPageControl.indicatorMargin = 2.0f;
        self.upPageControl.indicatorDiameter = 10.0f;
        [self addSubview:self.upPageControl];
        self.upPageControl.centerX = Screen_Width/2.;
    }
    self.upPageControl.numberOfPages=[self.upImages count];
    self.upPageControl.currentPage=0;
}

@end
