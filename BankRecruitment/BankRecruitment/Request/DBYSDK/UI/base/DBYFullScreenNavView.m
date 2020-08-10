//
//  DBYFullScreenNavView.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/13.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYFullScreenNavView.h"

#import "DBYBaseUIMacro.h"

@interface DBYFullScreenNavView ()
//返回按钮
@property(nonatomic,strong)UIButton*backButton;

@property(nonatomic,strong)UILabel* titleLabel;

@property(nonatomic,strong)CAGradientLayer* gradientLayer;
@end
@implementation DBYFullScreenNavView

-(instancetype)init
{
    if (self = [super init]) {
        
         self.gradientLayer = [CAGradientLayer layer];
        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        [self.layer addSublayer:self.gradientLayer];
        
        self.backButton = [[UIButton alloc]init];
        [self.backButton setImage:[UIImage imageNamed:@"DBYSDKResource.bundle/Back Arrow"] forState:UIControlStateNormal];
        [self addSubview:self.backButton];
        [self.backButton  addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * fullScreenTitleLabel = [[UILabel alloc]init];
        fullScreenTitleLabel.font = [UIFont systemFontOfSize:16];
        fullScreenTitleLabel.textAlignment = NSTextAlignmentCenter;
        fullScreenTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:fullScreenTitleLabel];
        self.titleLabel = fullScreenTitleLabel;
        
        
        //实现背景渐变
        
            }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginX = 8;
    CGFloat marginY = 2;
    
    CGFloat backButtonW = 24;
    CGFloat backButtonH = 32;
    CGFloat backButtonX = 6;
    CGFloat backButtonY = 8;

    self.backButton.frame = CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH);
    
    CGFloat titleLabelY = marginY;
    CGFloat titleLabelX = CGRectGetMaxX(self.backButton.frame) + marginX ;
    CGFloat titleLabelH = backButtonH;
    CGFloat titleLabelW = self.frame.size.width - titleLabelX*2;
    
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
   
    self.gradientLayer.frame = self.bounds;
    
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)DBYColorFromRGBA(0, 0, 0, 0.8).CGColor,
                                  (__bridge id)DBYColorFromRGBA(0, 0, 0, 0).CGColor];
    
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.5f), @(1.0f)];

}
- (void)clickBackButton
{
    if (self.clickBackButtonHandler) {
        self.clickBackButtonHandler();
    }
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}
@end
