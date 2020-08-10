//
//  DBYProgressView.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 2017/4/25.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYProgressView.h"

#import "DBYBaseUIMacro.h"

@interface DBYProgressView ()
//圆球
@property(nonatomic,weak)UIImageView*slideView;
//总进度view
@property(nonatomic,weak)UIView* sumView;
//进度view
@property(nonatomic,weak)UIView* progressView;

@property(nonatomic,assign)float progress;


@property(nonatomic,assign)CGRect lastLayoutSubviewsFrame;//记录上次layoutSubview时的frame


//是否正在滑动
@property(nonatomic,assign)BOOL isPaning;
@end
@implementation DBYProgressView
#pragma mark - life cycle
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (CGRectEqualToRect(self.frame, self.lastLayoutSubviewsFrame)) {
        return;
    }
    self.lastLayoutSubviewsFrame = self.frame;
    
    CGFloat sumViewH = self.frame.size.height / 4;
    CGFloat sumViewW = self.frame.size.width;
    CGFloat sumViewX = 0 ;
    CGFloat sumViewY = (self.frame.size.height - sumViewH)*0.5;
    self.sumView.frame = CGRectMake(sumViewX, sumViewY, sumViewW, sumViewH);
    
    
    
    CGFloat slideViewH = self.frame.size.height;
    CGFloat slideViewW = slideViewH;
    CGFloat slideViewY = 0;
    CGFloat slideViewX = 0;
    
    CGFloat progressViewH = sumViewH;
    CGFloat progressViewW = (sumViewW - slideViewW )* self.progress + 0.5*slideViewW;
    CGFloat progressViewX = 0;
    CGFloat progressViewY = 0;
    
    slideViewX = progressViewW - slideViewW*0.5;
    
    self.progressView.frame = CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH);
    
    self.slideView.frame = CGRectMake(slideViewX, slideViewY, slideViewW, slideViewH);
}

-(void)panRoundView:(UIPanGestureRecognizer*)pan
{
    CGPoint location = [pan locationInView:self];//触控的坐标
    
    CGRect currentProgressFrame = self.progressView.frame;
    
    CGRect roundVIewFrame = self.slideView.frame;
    
    
    currentProgressFrame.size.width = location.x ;
    roundVIewFrame.origin.x = location.x - roundVIewFrame.size.width*0.5;
    
    if (location.x<roundVIewFrame.size.width*0.5) {
        currentProgressFrame.size.width = roundVIewFrame.size.width*0.5;
        roundVIewFrame.origin.x = 0;
    }
    if (location.x > self.bounds.size.width - roundVIewFrame.size.width*0.5) {
        currentProgressFrame.size.width = self.bounds.size.width - roundVIewFrame.size.width*0.5;
        roundVIewFrame.origin.x = self.bounds.size.width - roundVIewFrame.size.width;
    }
    
    self.progressView.frame = currentProgressFrame;
    
    self.slideView.frame = roundVIewFrame;
    
    self.progress = (currentProgressFrame.size.width - roundVIewFrame.size.width*0.5)/(self.bounds.size.width - roundVIewFrame.size.width);
    NSLog(@"%f",self.progress);
    
    if (pan.state==UIGestureRecognizerStateBegan ) {
        self.isPaning = YES;
        if (self.beginPanHandler) {
            self.beginPanHandler(self.progress);
        }
    } else if (pan.state == UIGestureRecognizerStateEnded){
        self.isPaning = NO;
        if (self.endPanHandler) {
            self.endPanHandler(self.progress);
        }
        
    } else {
        if (self.paningHandler) {
            self.paningHandler(self.progress);
        }
    }
}

-(void)setProgressWith:(float)progress
{
    
    if (self.isPaning) {
        return;
    }
    
    if (isnan(progress)) {
        return;
    }
    self.progress = progress;
    
    CGRect currentProgressFrame = self.progressView.frame;
    
    CGRect roundVIewFrame = self.slideView.frame;
    
    currentProgressFrame.size.width = self.progress *(self.bounds.size.width - roundVIewFrame.size.width) + roundVIewFrame.size.width*0.5;
    
    roundVIewFrame.origin.x = currentProgressFrame.size.width - roundVIewFrame.size.width*0.5;
    
    
    self.progressView.frame = currentProgressFrame;
    self.slideView.frame = roundVIewFrame;
}

#pragma mark - private methods
-(void)prepareSubviews
{
    UIView*sumView = [[UIView alloc]init];
    sumView.backgroundColor = DBYColorFromRGBA(255, 255, 255, 0.4);
    [self addSubview:sumView];
    self.sumView = sumView;
    
    //progressView
    UIView*progressView = [[UIView alloc]init];
    progressView.backgroundColor = DBYColorFromRGBA(255, 255, 255, 1);
    [sumView addSubview:progressView];
    self.progressView = progressView;
    
    UIImageView*slideView = [[UIImageView alloc]initWithImage:[DBYUIUtils bundleImageWithImageName:@"O"]];
    slideView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:slideView];
    self.slideView = slideView;
    slideView.userInteractionEnabled = YES;

    UIPanGestureRecognizer*pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRoundView:)];
    [slideView addGestureRecognizer:pan];
    
}


@end
