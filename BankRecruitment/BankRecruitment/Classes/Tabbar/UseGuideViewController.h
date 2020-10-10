//
//  UseGuideViewController.h
//  Ganggangda
//
//  Created by xiajianqing on 15/8/17.
//  Copyright (c) 2015年 Longlian. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SMPageControl.h"

@protocol  UseGuideDelegate <NSObject>
-(void)removeGuideView;
@end

@interface UseGuideViewController : UIViewController<UIScrollViewDelegate>
{
    int currentPage;
    SMPageControl *pageControl;
}
@property (nonatomic, assign) BOOL isLogined;
@property (assign,nonatomic) id<UseGuideDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UIImageView *guideView;
@property (nonatomic, strong) UIScrollView *guideScrollView;
@property (nonatomic, strong) NSTimer *timer;

@end
