//
//  DBYPlayBackManager.h
//  OnlinePlaybackTest
//
//  Created by Michael on 17/3/6.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DBYOnlinePlayBackManagerStartPlayBackErrorTypeNoError = 100000,
    DBYOnlinePlayBackManagerStartPlayBackErrorTypeHttpError = 100001,
    DBYOnlinePlayBackManagerStartPlayBackErrorTypeLocalPathError,
    DBYOnlinePlayBackManagerStartPlayBackErrorTypeJsonError,
    DBYOnlinePlayBackManagerStartPlayBackErrorTypeModeError,
    DBYOnlinePlayBackManagerStartPlayBackErrorTypeAuthError,
    DBYOnlinePlayBackManagerStartPlayBackErrorTypeOpenFileError,
    DBYOnlinePlayBackManagerStartPlayBackErrorTypeFLVFileError,
} DBYOnlinePlayBackManagerStartPlayBackErrorType;

typedef enum : NSUInteger {
    DBYOnlinePlayBackManagerClassRoomType1V1 = 1,
    DBYOnlinePlayBackManagerClassRoomType1VN = 2,
} DBYOnlinePlayBackManagerClassRoomType;


@protocol DBYOnlinePlayBackManagerDelegate;
@interface DBYOnlinePlayBackManager : NSObject

-(instancetype)initWithPartnerID:(NSString*)partnerID appKey:(NSString*)appkey;


@property(nonatomic,assign)DBYOnlinePlayBackManagerClassRoomType classRoomType;



-(void)startPlaybackWithRoomID:(NSString*)roomID
                           uid:(NSString*)uid
                      userName:(NSString*)userName
                      userRole:(int)userRole
                     startTime:(NSTimeInterval)startTime
                      seekTime:(NSTimeInterval)seekTime
               completeHandler:(void(^)(NSString*error ,DBYOnlinePlayBackManagerStartPlayBackErrorType errorType))completeHandler;
-(void)startPlaybackWithUrl:(NSString *)url
                 withRoomId:(NSString*)roomId
                  startTime:(NSTimeInterval)startTime
                   seekTime:(NSTimeInterval)seekTime
            completeHandler:(void (^)(NSString *error, DBYOnlinePlayBackManagerStartPlayBackErrorType errorType))completeHandler;

-(void)setDrawLineWidthWith:(CGFloat)lineWidth;
-(void)setPPTViewWithView:(UIView*)pptView;
-(void)setStudentViewWith:(UIView *)studentView;
-(void)setTeacherViewWith:(UIView *)teacherView;

@property(nonatomic,weak)id<DBYOnlinePlayBackManagerDelegate> delegate;
//是否在播放
@property(nonatomic,assign)BOOL isPlaying;
@property(nonatomic,assign)BOOL isRendering;
//发送状态到动态课件webview
-(void)sendStatusToWebViewWithEventType:(NSString*)eventType data:(NSString*)jsonStr;

#pragma mark - play methods
-(void)seekToTimeWith:(NSTimeInterval)time completeHandler:(void(^)(NSString* errorMsg))competeHandler;

//停止播放
-(void)stopPlayWithCompleteHandler:(void(^)())completeHandler;
//暂停播放
-(void)pausePlay;
//恢复播放
-(void)resumePlay;

//设置播放速度 返回是否设置成功
-(BOOL)setPlaySpeedWith:(float)speed;
//聊天数组
@property(nonatomic,strong)NSMutableArray<NSDictionary*>* chatDictArray;
//总时间（秒）
@property(nonatomic,assign)NSTimeInterval totalTime;
@property(nonatomic,assign)NSTimeInterval lessonStartTime;
@property(nonatomic,assign)NSTimeInterval lessonEndTime;
@property(nonatomic,assign)NSTimeInterval currentTime;
@property(nonatomic,assign)BOOL hasPause;
@end
@protocol DBYOnlinePlayBackManagerDelegate <NSObject>
@optional
#pragma mark - 视频相关
/**
 开始视频或结束视频时调用
 
 @param hasVideo 是否有视频
 @param view     在哪个View上
 */
-(void)playbackManager:(DBYOnlinePlayBackManager*)manager hasVideo:(BOOL)hasVideo inView:(UIView*)view;
#pragma mark - seek
/**
 seek失败回调
 @param code 失败类型
 */
-(void)playbackManager:(DBYOnlinePlayBackManager*)manager seekFailWithCode:(int)code;
#pragma mark - play
/**
 播放完调用
 */
-(void)playbackManagerDidPlayEnd:(DBYOnlinePlayBackManager*)manager;

//返回播放时间
-(void)playBackManager:(DBYOnlinePlayBackManager*)manager playedAtTime:(NSTimeInterval)time;
//开始播放时调用 总时长
-(void)playBackManager:(DBYOnlinePlayBackManager*)manager totalTime:(NSTimeInterval)time;
//重复登录时调用 （提示被踢）
-(void)playBackManagerDidDuplicateLogin:(DBYOnlinePlayBackManager*)manager;
#pragma mark - 聊天相关
//有聊天时调用 返回收到所有消息最新的30条
-(void)playbackManager:(DBYOnlinePlayBackManager *)manager hasChatMessageWithChatArray:(NSArray*)chatDictArray;
#pragma mark - ppt
//加载ppt失败时调用
-(void)playbackManagerDidFailLoadPPT:(DBYOnlinePlayBackManager *)manager;

#pragma mark - 底层自动seek
-(void)playbackManager:(DBYOnlinePlayBackManager *)manager shouldSeekTo:(NSTimeInterval)time;
@end
