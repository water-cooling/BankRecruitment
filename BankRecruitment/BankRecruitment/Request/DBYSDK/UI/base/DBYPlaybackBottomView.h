//
//  DBYPlaybackBottomView.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 2017/4/25.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    DBYPlaybackBottomViewModePlayback = 0, //回放模式 有进度条 时间 播放按钮
    DBYPlaybackBottomViewModeLive ,//直播模式 只有全屏按钮
} DBYPlaybackBottomViewMode;
@interface DBYPlaybackBottomView : UIView

//显示模式
@property(nonatomic,assign)DBYPlaybackBottomViewMode mode;
//点击全屏按钮回调
@property(nonatomic,copy)void(^clickFullScreenHandler)();

//获取当前进度
-(float)progress;
//设置进度（0.0 - 1.0）
-(void)setProgressWith:(float)progress;
//设置总时间
-(void)setTotalTimeLabelWithTime:(NSTimeInterval)time;
//设置当前时间
-(void)setCurrentTimeLabelWithTime:(NSTimeInterval)time;
//设置播放按钮是否播放
-(void)setPlayButtonStateWith:(BOOL)isPlaying;
//设置全屏按钮是否隐藏
-(void)setFullScreenButtonHidden:(BOOL)hidden;


@property(nonatomic,copy)void(^beginPanHandler)(float progress);//开始滑动
@property(nonatomic,copy)void(^paningHandler)(float progress);//滑动中
@property(nonatomic,copy)void(^endPanHandler)(float progress);//停止滑动

@property(nonatomic,copy)void(^clickPlayButtonHandler)(BOOL isPlaying);
@end
