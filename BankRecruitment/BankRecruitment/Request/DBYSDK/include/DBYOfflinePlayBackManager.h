//
//  DBYOfflinePlayBackManager.h
//  DBYSDK
//
//  Created by Michael on 16/12/12.
//  Copyright © 2016年 Michael. All rights reserved.
//  离线回放(m4a)管理器

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    DBYOfflinePlayBackManagerPrepareErrorTypeNoError = 0,//没错误
    DBYOfflinePlayBackManagerPrepareErrorTypeNoRoomID,//没设置roomID
    DBYOfflinePlayBackManagerPrepareErrorTypeClassDirNotFound,//找不到课程文件夹
    DBYOfflinePlayBackManagerPrepareErrorTypeClassConfigNotFound,//找不到课程config.json
    DBYOfflinePlayBackManagerPrepareErrorTypeKeyWrong //key错误
} DBYOfflinePlayBackManagerPrepareErrorType ;

@class DBYChatEventInfo;

#define CHAT_ARRAY_MAX_COUNT 30 //最多显示聊天数

@protocol DBYOfflinePlayBackManagerDelegate ;
@interface DBYOfflinePlayBackManager : NSObject

@property(nonatomic,weak)id<DBYOfflinePlayBackManagerDelegate>delegate;
//播放的课程的roomID
@property(nonatomic,copy)NSString*roomID;
/**
 *  设置ppt显示View ppt的大小和slideView一致
 *
 *  @param slideView 显示ppt的View
 */
-(void)setupSlideViewWith:(UIView*)slideView;

/**
 准备播放

 @param completeHandler 准备完成回调
 */
-(void)prepareForPlayWithCompleteHandler:(void (^)(NSString*errorMsg,DBYOfflinePlayBackManagerPrepareErrorType error))completeHandler;

#pragma mark - play methods

/**
 设置播放速率 （0.5-2.0）0.5为一般速度 默认为1
 
 @param rate 播放速度
 */
-(void)setPlayRate:(float)rate;
/**
 *  播放
 */
-(void)play;
/**
 *  停止播放
 */
-(void)stop;
/**
 *  暂停播放
 */
-(void)pause;
/**
 *  恢复播放
 */
-(void)resume;
/**
 *  到指定进度播放
 *
 *  @param progress 进度 0.0 - 1.0
 */
-(void)seekToProgress:(float)progress;

/**
 *  到指定播放时间
 *
 *  @param time 播放时间 （秒）
 */
-(void)seekToTime:(NSTimeInterval)time;
#pragma mark - playback info
//当先应该显示的聊天信息数组
@property(nonatomic,strong)NSMutableArray<DBYChatEventInfo*>* chatInfoArray;

/**
 当前播放时间
 */
@property(nonatomic,assign)NSTimeInterval currentPlayTime;
/**
 返回课程时长

 @return 没有课程信息时返回0
 */
-(NSTimeInterval)lessonLength;

/**
 返回当前ppt总页数
 */
-(NSInteger)pptSlideCount;

/**
 返回是否在播放

 @return 是否在播放
 */
-(BOOL)isPlaying;
@end

@protocol DBYOfflinePlayBackManagerDelegate <NSObject>
@optional
/**
 播放状态改变时调用
 
 @param isPlaying 正在播放
 */
-(void)offlinePlayBackManager:(DBYOfflinePlayBackManager*)manager playStateIsPlaying:(BOOL)isPlaying;
/**
 *  正在播放中会调用
 *
 *  @param progress 播放进度
 *  @param time     播放时间点
 */
-(void)offlinePlayBackManager:(DBYOfflinePlayBackManager*)manager isPlayingAtProgress:(float)progress time:(NSTimeInterval)time;


/**
 聊天信息数组更新时调用
 
 @param chatInfoArray 包含聊天信息的数组
 */
-(void)offlinePlayBackManager:(DBYOfflinePlayBackManager*)manager chatInfoArray:(NSArray*)chatInfoArray;

/**
 ppt改变时调用
 
 @param currentPPTPageCount 当前页数
 @param pptSlideCount       总页数
 */
-(void)offlinePlayBackManager:(DBYOfflinePlayBackManager*)manager pptHasChangedWithCurrentPPTPageCount:(NSInteger)currentPPTPageCount pptSlideCount:(NSInteger)pptSlideCount;
/**
 *  播放完调用
 *
 */
-(void)offlinePlayBackManagerFinishedPlay:(DBYOfflinePlayBackManager*)manager;




@end
