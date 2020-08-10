//
//  DBYPlaybackBottomView.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 2017/4/25.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYPlaybackBottomView.h"

#import "DBYBaseUIMacro.h"

#import "DBYProgressView.h"

@interface DBYPlaybackBottomView ()
@property(nonatomic,strong)CAGradientLayer* gradientLayer;

@property(nonatomic,weak)UIButton* fullScreenButton;

@property(nonatomic,weak)UIButton* playButton;

@property(nonatomic,weak)DBYProgressView* progressView;

@property(nonatomic,weak)UILabel* currentTimeLabel;

@property(nonatomic,weak)UILabel* totalTimeLabel;

@end
@implementation DBYPlaybackBottomView
#pragma mark - life cycle
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self prepareSubviews];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)DBYColorFromRGBA(0, 0, 0, 0.0).CGColor,
                                  (__bridge id)DBYColorFromRGBA(0, 0, 0, 0.8).CGColor];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.5f), @(1.0f)];
    
    //设置全屏按钮位置
    CGFloat fullScreenButtonW = 32;
    CGFloat fullScreenButtonH = fullScreenButtonW;
    CGFloat fullScreenButtonX = self.frame.size.width - fullScreenButtonW - 4;
    CGFloat fullScreenButtonY = self.frame.size.height - fullScreenButtonH - 8;
    self.fullScreenButton.frame = CGRectMake(fullScreenButtonX, fullScreenButtonY, fullScreenButtonW, fullScreenButtonH);
    
    CGFloat playButtonW = 24;
    CGFloat playButtonH = 32;
    CGFloat playButtonX = 6;
    CGFloat playButtonY = self.frame.size.height - playButtonH - 8;
    self.playButton.frame = CGRectMake(playButtonX, playButtonY, playButtonW, playButtonH);
    
    CGFloat progressViewX = CGRectGetMaxX(self.playButton.frame) + 6;
    CGFloat progressViewH = 16;
    CGFloat progressViewW = self.frame.size.width - progressViewX*2;
    CGFloat progressViewY = self.frame.size.height - progressViewH - 16;
    self.progressView.frame = CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH);
    
    
    CGFloat currentTimeLabelX = progressViewX;
    CGFloat currentTimeLabelH = 11;
    CGFloat currentTimeLabelY = self.frame.size.height - currentTimeLabelH - 5;
    CGFloat currentTimeLabelW = 50;
    self.currentTimeLabel.frame = CGRectMake(currentTimeLabelX, currentTimeLabelY, currentTimeLabelW, currentTimeLabelH);
    
    CGFloat totalTimeLabelW = currentTimeLabelW;
    CGFloat totalTimeLabelX = CGRectGetMaxX(self.progressView.frame) - totalTimeLabelW;
    CGFloat totalTimeLabelH = currentTimeLabelH;
    CGFloat totalTimeLabelY = currentTimeLabelY;
    self.totalTimeLabel.frame = CGRectMake(totalTimeLabelX, totalTimeLabelY, totalTimeLabelW, totalTimeLabelH);
    
   
}
#pragma mark - public methods
-(void)setProgressWith:(float)progress
{
    [self.progressView setProgressWith:progress];
}
-(float)progress
{
    return self.progressView.progress;
}
-(void)setTotalTimeLabelWithTime:(NSTimeInterval)time
{
    NSString*timeStr = [self timeStrWithTime:time];
    
    self.totalTimeLabel.text = timeStr;
}
-(void)setCurrentTimeLabelWithTime:(NSTimeInterval)time
{
    NSString*timeStr = [self timeStrWithTime:time];
    
    self.currentTimeLabel.text = timeStr;
}
-(void)setPlayButtonStateWith:(BOOL)isPlaying
{
    self.playButton.selected = !isPlaying;
}
-(void)setFullScreenButtonHidden:(BOOL)hidden
{
    self.fullScreenButton.hidden = hidden;
}
#pragma mark - private methods
-(NSString*)timeStrWithTime:(NSTimeInterval)time
{
    int second = (int)time %60;
    int minute = ((int)time/60) %60;
    int hour = (int)time / 3600;
    
    NSString*timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hour, minute, second];
    return timeStr;
}
-(void)prepareSubviews
{
    self.gradientLayer = [[CAGradientLayer alloc]init];
    
    [self.layer addSublayer:self.gradientLayer];
    
    //全屏按钮
    UIButton*fullScreenButton = [[UIButton alloc]init];
    [fullScreenButton setImage:[DBYUIUtils bundleImageWithImageName:@"Fullscreen"] forState:UIControlStateNormal];
//    [fullScreenButton setBackgroundImage:[DBYUIUtils createImageWithColor:DBYColorFromRGBA(0, 0, 0, 0.4)] forState:UIControlStateNormal];
//    fullScreenButton.layer.masksToBounds = YES;
//    fullScreenButton.layer.cornerRadius = 4;
    [fullScreenButton addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fullScreenButton];
    self.fullScreenButton = fullScreenButton;
    
    //播放按钮
    UIButton*playButton = [[UIButton alloc]init];
    [playButton setImage:[DBYUIUtils bundleImageWithImageName:@"stop"] forState:UIControlStateNormal];
    [playButton setImage:[DBYUIUtils bundleImageWithImageName:@"play"] forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    self.playButton = playButton;
    
    //进度条
    DBYProgressView*progressView = [[DBYProgressView alloc]init];
    [self addSubview:progressView];
    self.progressView = progressView;
    
    __weak typeof(self) weakSelf = self;
    progressView.paningHandler = ^(float progress) {
        if (weakSelf.paningHandler) {
            weakSelf.paningHandler(progress);
        }
    };
    progressView.beginPanHandler = ^(float progress) {
        if (weakSelf.beginPanHandler) {
            weakSelf.beginPanHandler(progress);
        }
    };
    progressView.endPanHandler = ^(float progress) {
        if (weakSelf.endPanHandler) {
            weakSelf.endPanHandler(progress);
        }
    };
    
    
    UILabel*currentTimeLabel = [[UILabel alloc]init];
    currentTimeLabel.font = [UIFont systemFontOfSize:11];
    currentTimeLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:currentTimeLabel];
    self.currentTimeLabel = currentTimeLabel;
    
    UILabel*totalTimeLabel = [[UILabel alloc]init];
    totalTimeLabel.font = [UIFont systemFontOfSize:11];
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:totalTimeLabel ];
    self.totalTimeLabel = totalTimeLabel;
    
    
     self.mode = DBYPlaybackBottomViewModePlayback;
    //TODO:测试
    currentTimeLabel.text = @"00:00:00";
    totalTimeLabel.text = @"00:00:00";
}
#pragma mark - action methods
-(void)clickFullScreen:(UIButton*)button
{
    if (self.clickFullScreenHandler) {
        self.clickFullScreenHandler();
    }
}
- (void)clickPlay:(UIButton*)button
{
    button.selected = !button.isSelected;
    
    if (self.clickPlayButtonHandler) {
        self.clickPlayButtonHandler(!button.isSelected);
    }
}
#pragma mark - setter 
-(void)setMode:(DBYPlaybackBottomViewMode)mode
{
    _mode = mode;
    //直播模式需要隐藏部分控件
    BOOL shouldHide = mode == DBYPlaybackBottomViewModeLive;
    
    self.playButton.hidden = shouldHide;
    self.progressView.hidden = shouldHide;
    
    self.currentTimeLabel.hidden = shouldHide;
    self.totalTimeLabel.hidden = shouldHide;
    
}

@end
