//
//  DBYFullScreenBottomView.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/13.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYFullScreenBottomView.h"

#import "DBYBaseUIMacro.h"

#import "DBYProgressView.h"

@interface DBYFullScreenBottomView ()
@property(nonatomic,strong)UIButton*quitFullScreenButton;

@property(nonatomic,strong)CAGradientLayer* gradientLayer;

@property(nonatomic,weak)UIButton* playButton;

@property(nonatomic,weak)DBYProgressView* progressView;

@property(nonatomic,weak)UILabel* currentTimeLabel;

@property(nonatomic,weak)UILabel* totalTimeLabel;

@property(nonatomic,weak)UIButton* speedButton;
@end
@implementation DBYFullScreenBottomView
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
    
    
    self.gradientLayer.frame = self.bounds;
    
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)DBYColorFromRGBA(0, 0, 0, 0.0).CGColor,
                                  (__bridge id)DBYColorFromRGBA(0, 0, 0, 0.8).CGColor];
    
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.5f), @(1.0f)];

    
    CGFloat playButtonW = 24;
    CGFloat playButtonH = 32;
    CGFloat playButtonX = 6;
    CGFloat playButtonY = self.frame.size.height - playButtonH - 8;
    self.playButton.frame = CGRectMake(playButtonX, playButtonY, playButtonW, playButtonH);
    
    
    [self.currentTimeLabel sizeToFit];
    CGFloat currentTimeLabelX = CGRectGetMaxX(self.playButton.frame) + 6;
    CGFloat currentTimeLabelW = self.currentTimeLabel.frame.size.width + 2;
    CGFloat currentTimeLabelH = self.currentTimeLabel.frame.size.height;
    CGFloat currentTimeLabelY = self.frame.size.height -currentTimeLabelH - 18;
    self.currentTimeLabel.frame = CGRectMake(currentTimeLabelX, currentTimeLabelY, currentTimeLabelW, currentTimeLabelH);
    
    CGFloat quitFullScreenButtonW = 32;
    CGFloat quitFullScreenButtonH = quitFullScreenButtonW;
    CGFloat quitFullScreenButtonX = self.frame.size.width - quitFullScreenButtonW - 4;
    CGFloat quitFullScreenButtonY = self.frame.size.height - quitFullScreenButtonH - 8;
    self.quitFullScreenButton.frame = CGRectMake(quitFullScreenButtonX, quitFullScreenButtonY, quitFullScreenButtonW, quitFullScreenButtonH);
    
    
    CGFloat speedButtonW = 58;
    CGFloat speedButtonH = 24;
    CGFloat speedButtonX = self.quitFullScreenButton.frame.origin.x - 6 - speedButtonW;
    CGFloat speedButtonY = self.frame.size.height - speedButtonH - 12;
    self.speedButton.frame = CGRectMake(speedButtonX, speedButtonY, speedButtonW, speedButtonH);
    
    [self.totalTimeLabel sizeToFit];
    CGFloat totalTimeLabelW = self.totalTimeLabel.frame.size.width + 2;
    CGFloat totalTimeLabelH = self.totalTimeLabel.frame.size.height;
    CGFloat totalTimeLabelX = speedButtonX - 16 - totalTimeLabelW;
    CGFloat totalTimeLabelY = currentTimeLabelY;
    self.totalTimeLabel.frame = CGRectMake(totalTimeLabelX, totalTimeLabelY, totalTimeLabelW, totalTimeLabelH);
    
    CGFloat progressViewX = CGRectGetMaxX(self.currentTimeLabel.frame) + 12;
    CGFloat progressViewW = totalTimeLabelX - 12 - progressViewX;
    CGFloat progressViewH = 16;
    CGFloat progressViewY = self.frame.size.height - progressViewH - 16;
    self.progressView.frame = CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH);

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
    self.gradientLayer = [CAGradientLayer layer];
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:self.gradientLayer];
    
    //退出全屏按钮
    UIButton*quitFullScreenButton = [[UIButton alloc]init];
    [quitFullScreenButton setImage:[UIImage imageNamed:@"DBYSDKResource.bundle/return"] forState:UIControlStateNormal];
    [self addSubview:quitFullScreenButton];
    self.quitFullScreenButton = quitFullScreenButton;
    [quitFullScreenButton addTarget:self action:@selector(clickQuitFullScreenButton) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    UILabel*currentTimeLabel = [[UILabel alloc]init];
    currentTimeLabel.font = [UIFont systemFontOfSize:12];
    currentTimeLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:currentTimeLabel];
    self.currentTimeLabel = currentTimeLabel;
    
    UILabel*totalTimeLabel = [[UILabel alloc]init];
    totalTimeLabel.font = [UIFont systemFontOfSize:12];
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalTimeLabel ];
    self.totalTimeLabel = totalTimeLabel;

    
    UIButton*speedButton = [[UIButton alloc]init];
    speedButton.layer.masksToBounds = YES;
    speedButton.layer.cornerRadius = 4;
    speedButton.layer.borderColor = [UIColor whiteColor].CGColor;
    speedButton.layer.borderWidth = 1;
    [speedButton setBackgroundImage:[DBYUIUtils createImageWithColor:DBYColorFromRGBA(0, 0, 0, 0.4)] forState:UIControlStateNormal];
    [speedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    speedButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:speedButton];
    self.speedButton = speedButton;
    
    
    self.mode = DBYFullScreenBottomViewModePlayback;
    
    
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
    
    //TODO:测试
    [speedButton setTitle:@"1.0倍速" forState:UIControlStateNormal];
    currentTimeLabel.text = @"99:99:99";
    totalTimeLabel.text = @"99:99:99";
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
#pragma mark - action methods
- (void)clickQuitFullScreenButton
{
    if (self.clickQuitFullScreenButtonHandler) {
        self.clickQuitFullScreenButtonHandler();
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
-(void)setMode:(DBYFullScreenBottomViewMode)mode
{
    _mode = mode;
    
    BOOL shouldHidden = mode == DBYFullScreenBottomViewModeLive;
    
    self.playButton.hidden = shouldHidden;
    self.currentTimeLabel.hidden = shouldHidden;
    self.progressView.hidden = shouldHidden;
    self.totalTimeLabel.hidden = shouldHidden;
    self.speedButton.hidden = shouldHidden;
    
}
@end
