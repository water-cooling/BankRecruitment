//
//  BigImageShowViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/7/1.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "BigImageShowViewController.h"
#import "SMPageControl.h"
#import "UIImageView+WebCache.h"

@interface BigImageShowViewController ()<UIScrollViewDelegate>
//滚动视图对象
@property (nonatomic ,strong) IBOutlet UIScrollView *upScrollView;
//视图中小圆点，对应视图的页码
@property (retain, nonatomic) SMPageControl *upPageControl;
@property (nonatomic, strong) NSTimer *timer;

- (void)setupImagesPage:(id)sender;

@end

@implementation BigImageShowViewController

//改变滚动视图的方法实现
- (void)setupImagesPage:(id)sender
{
    if(!self.upPageControl)
    {
        self.upPageControl = [[SMPageControl alloc]initWithFrame:CGRectMake(0, Screen_Height-30-44, Screen_Width, 40)];
        self.upPageControl.backgroundColor=[UIColor clearColor];
        self.upPageControl.currentPageIndicatorImage = [UIImage imageNamed:@"Rectangle_white"];
        self.upPageControl.pageIndicatorImage = [UIImage imageNamed:@"Rectangle_opacity"];
        self.upPageControl.indicatorMargin = 2.0f;
        self.upPageControl.indicatorDiameter = 10.0f;
        [self.view addSubview:self.upPageControl];
        self.upPageControl.centerX = Screen_Width/2.;
    }
    self.upPageControl.numberOfPages=[self.imageUrlList count];
    self.upPageControl.currentPage=0;
    
    [self.upScrollView removeAllSubviews];
    
    //设置委托
    self.upScrollView.delegate = self;
    //设置背景颜色
    self.upScrollView.backgroundColor = [UIColor blackColor];
    //设置取消触摸
    self.upScrollView.canCancelContentTouches = NO;
    //设置滚动条类型
    self.upScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    //是否自动裁切超出部分
    self.upScrollView.clipsToBounds = YES;
    //设置是否可以缩放
    self.upScrollView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    self.upScrollView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.upScrollView.directionalLockEnabled = NO;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.upScrollView.alwaysBounceHorizontal = NO;
    self.upScrollView.alwaysBounceVertical = NO;
    self.upScrollView.showsHorizontalScrollIndicator = NO;
    self.upScrollView.showsVerticalScrollIndicator = NO;
    
    if(self.imageUrlList.count == 0)
    {
        UIImageView* backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        backImageView.image = kDefaultHorizontalRectangleImage;
        [self.upScrollView addSubview:backImageView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pImageViewTapAction)];
        backImageView.userInteractionEnabled = YES;
        [backImageView addGestureRecognizer:ges];
        self.upPageControl.numberOfPages = 0;
        return;
    }
    
    //add the last image in first
    if(self.imageUrlList.count > 1)
    {
        NSString *imageUrl = [self.imageUrlList objectAtIndex:([self.imageUrlList count]-1)];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor blackColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
        //        [imageView setImage:[UIImage imageNamed:[imageDict objectForKey:@"path"]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        [self.upScrollView addSubview:imageView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pImageViewTapAction)];
        [imageView addGestureRecognizer:ges];
        imageView.userInteractionEnabled = YES;
    }
    
    //用来记录页数
    NSUInteger pages = 0;
    //用来记录scrollView的x坐标
    int originX = (self.imageUrlList.count > 1)?Screen_Width:0;
    for(NSString *imageUrl in self.imageUrlList)
    {
        //创建一个视图
        UIImageView *pImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        pImageView.userInteractionEnabled = YES;
        //设置视图的背景色
        pImageView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pImageViewTapAction)];
        [pImageView addGestureRecognizer:ges];
        
        //设置imageView的背景图
        [pImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
        //        [pImageView setImage:[UIImage imageNamed:[imageDict objectForKey:@"path"]]];
        
        //给imageView设置区域
        CGRect rect = CGRectMake(0, 0, Screen_Width, Screen_Height);
        rect.origin.x = originX;
        rect.origin.y = 0;
        //rect.size.width = self.upScrollView.frame.size.width;
        rect.size.height = Screen_Height;
        pImageView.frame = rect;
        //设置图片内容的显示模式(自适应模式)
        pImageView.contentMode = UIViewContentModeScaleAspectFit;
        //把视图添加到当前的滚动视图中
        [self.upScrollView addSubview:pImageView];
        //下一张视图的x坐标:offset为:self.scrollView.frame.size.width.
        originX += Screen_Width;
        //记录scrollView内imageView的个数
        pages++;
    }
    
    //add the first image at the end
    if(self.imageUrlList.count > 1)
    {
        NSString *imageUrl = [self.imageUrlList firstObject];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
        //        [imageView setImage:[UIImage imageNamed:[imageDict objectForKey:@"path"]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake((Screen_Width * ([self.imageUrlList count] + 1)), 0, Screen_Width, Screen_Height);
        [self.upScrollView addSubview:imageView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pImageViewTapAction)];
        [imageView addGestureRecognizer:ges];
        imageView.userInteractionEnabled = YES;
    }
    
    //设置总页数
    self.upPageControl.numberOfPages = pages;
    //默认当前页为第一页
    self.upPageControl.currentPage = 0;
    
    //为页码控制器设置标签
    self.upPageControl.tag = 110;
    
    //设置滚动视图的位置
    [self performSelector:@selector(scrollFirstPage) withObject:nil afterDelay:0.2];
}

- (void)scrollFirstPage{
    if(self.imageUrlList.count > 1)
    {
        [self.upScrollView setContentSize:CGSizeMake(Screen_Width * (self.imageUrlList.count + 2), 100)];
        [self.upScrollView setContentOffset:CGPointMake(Screen_Width, 0)];
        
        [self.upScrollView scrollRectToVisible:CGRectMake(Screen_Width, 0, Screen_Width, Screen_Height) animated:NO];
    }
    else
    {
        [self.upScrollView setContentSize:CGSizeMake(Screen_Width, 0)];
        [self.upScrollView setContentOffset:CGPointMake(0, 0)];
        [self.upScrollView scrollRectToVisible:CGRectMake(0,0,Screen_Width,Screen_Height) animated:NO];
    }
}

- (IBAction)pImageViewTapAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//实现协议UIScrollViewDelegate的方法，必须实现的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate distantFuture]];//暂停
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int currentPage = floor((self.upScrollView.contentOffset.x - Screen_Width / ([self.imageUrlList count]+2)) / Screen_Width) + 1;
    
    //切换改变页码，小圆点
    if(scrollView == self.upScrollView)
    {
        if (currentPage==0) {
            //go last but 1 page
            [self.upScrollView scrollRectToVisible:CGRectMake(Screen_Width * [self.imageUrlList count],0, Screen_Width, Screen_Height) animated:NO];
            
            currentPage = (int)(self.imageUrlList.count-1);
        }
        else if (currentPage==([self.imageUrlList count]+1))
        { //如果是最后+1,也就是要开始循环的第一个
            [self.upScrollView scrollRectToVisible:CGRectMake(Screen_Width,0,Screen_Width,Screen_Height) animated:NO];
            currentPage = 0;
        }
        else
        {
            currentPage--;
        }
        
        self.upPageControl.currentPage = currentPage;
    }
}


@end
