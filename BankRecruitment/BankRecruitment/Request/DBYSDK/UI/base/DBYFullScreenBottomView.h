//
//  DBYFullScreenBottomView.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/13.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DBYFullScreenBottomViewModePlayback,
    DBYFullScreenBottomViewModeLive,
} DBYFullScreenBottomViewMode;
@interface DBYFullScreenBottomView : UIView
@property(nonatomic,copy)void(^clickQuitFullScreenButtonHandler)();

@property(nonatomic,assign)DBYFullScreenBottomViewMode mode;

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

@property(nonatomic,copy)void(^beginPanHandler)(float progress);//开始滑动
@property(nonatomic,copy)void(^paningHandler)(float progress);//滑动中
@property(nonatomic,copy)void(^endPanHandler)(float progress);//停止滑动

@property(nonatomic,copy)void(^clickPlayButtonHandler)(BOOL isPlaying);
@end
