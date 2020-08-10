//
//  DBYLiveManager.h
//  DBYSDK
//
//  Created by Michael on 16/11/2.
//  Copyright © 2016年 vipkid. All rights reserved.
//  使用c++内核的直播管理类

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#define DBYLIVEMANAGERMAXCHATCOUNT 30 //最多显示聊天数

typedef enum : NSUInteger {
    DBYLiveManagerStatusTypeAppsConnect = 10,//apps消息连接成功
    DBYLiveManagerStatusTypeAppsError,//apps连接失败
    DBYLiveManagerStatusTypeAppsReconnect,//apps重连
    DBYLiveManagerStatusTypeAudioConnect = 100,//音频连接成功
    DBYLiveManagerStatusTypeAudioError,//音频连接失败
    DBYLiveManagerStatusTypeAudioReconnect,//音频重连
    DBYLiveManagerStatusTypeVideoConnect = 200,//视频连接成功
    DBYLiveManagerStatusTypeVideoError,//视频连接失败
    DBYLiveManagerStatusTypeVideoReconnect//视频重连
} DBYLiveManagerStatusType;

typedef enum : NSUInteger {
    DBYLiveManagerEnterRoomErrorTypeNoError = 0,
    DBYLiveManagerEnterRoomErrorTypeNoPPTView,
    DBYLiveManagerEnterRoomErrorTypeAuthInfoFail = 900,
    DBYLiveManagerEnterRoomErrorTypeAuthHttpError = 901,
    DBYLiveManagerEnterRoomErrorTypeAuthReturnFalse = 10000,//返回失败
    DBYLiveManagerEnterRoomErrorTypeAuthNotBegin,//课程未开始
    DBYLiveManagerEnterRoomErrorTypeAuthNoOneToLive = 10004,//没有人直播
    DBYLiveManagerEnterRoomErrorTypeAuthPlaybackConversionFailed,//回放转换失败
    DBYLiveManagerEnterRoomErrorTypeAuthPlaybackConversion,//回放转换中
    DBYLiveManagerEnterRoomErrorTypeTestVMError, //测速失败
    DBYLiveManagerEnterRoomErrorTypeAppsStartFail,//链接apps失败
    DBYLiveManagerEnterRoomErrorTypeAPIHasStart,//多次进入教室
    DBYLiveManagerEnterRoomErrorTypeRECOVERY_NOTSTART_OR_NOTPAUSE,//未暂停就调用恢复
    DBYLiveManagerEnterRoomErrorTypePAUSE_NOTSTART_OR_HASPAUSE,//未恢复就调用暂停
    DBYLiveManagerEnterRoomErrorTypeUserRoleTypeWrong = 10100,//用户角色错误
    DBYLiveManagerEnterRoomErrorTypeParamHasNil = 20000 //参数为空
    
} DBYLiveManagerEnterRoomErrorType;

typedef enum : NSUInteger {
    DBYLiveManagerUserRoleTypeTeacher = 1,//老师
    DBYLiveManagerUserRoleTypeStudent = 2,//学生
    DBYLiveManagerUserRoleTypeAdmin = 3,
    DBYLiveManagerUserRoleTypeTeacherAssistant = 4,//助教
    DBYLiveManagerUserRoleTypeParent = 6,//加载
} DBYLiveManagerUserRoleType;


typedef enum : NSUInteger {
    DBYLiveManagerVoteType2Options = 10,//两个选项
    DBYLiveManagerVoteType3Options,
    DBYLiveManagerVoteType4Options,
    DBYLiveManagerVoteType5Options,
    DBYLiveManagerVoteTypeTrueOrFalse = 30//判断题
} DBYLiveManagerVoteType;//答题类型枚举


typedef enum : NSUInteger {
    DBYLiveManagerClassRoomType1V1 = 1,
    DBYLiveManagerClassRoomType1VN = 2,
} DBYLiveManagerClassRoomType;//进入教室类型
@protocol DBYLiveManagerDelegate ;
@interface DBYLiveManager : NSObject

//使用参数进教室时，需传入appkey和partnerID
-(instancetype)initWithPartnerId:(NSString* )partnerId withAppKey:(NSString *)appKey;
-(void)enterRoomWithRoomID:(NSString*)roomID uid:(NSString*)uid nickName:(NSString*)nickName userRole:(DBYLiveManagerUserRoleType)userRole completeHandler:(void (^)(NSString * errorMsg,DBYLiveManagerEnterRoomErrorType error))completeHandler;


//使用链接进教室时 可以直接调用init
-(instancetype)init;
-(void)enterRoomWithUrl:(NSString *)url completeHandler:(void (^)(NSString *errorMsg ,DBYLiveManagerEnterRoomErrorType error))completeHandler;

-(void)enterRoomWithInviteCodeWith:(NSString*)inviteCode nickName:(NSString*)nickName completeHandler:(void (^)(NSString *errorMsg,DBYLiveManagerEnterRoomErrorType error))completeHandler;

//摄像头预览view大小改变时调用，防止画面变形
-(void)resizeCapturePreviewView;
//设置摄像头方向
-(void)setVideoOrientationWith:(AVCaptureVideoOrientation)orientation;
//切换前后摄像头
- (void)swapFrontAndBackCameras;

//设置ppt显示区域view
-(void)setPPTViewWithView:(UIView*)pptView;
//设置学生视频显示区域（1v1时可用）
-(void)setStudentViewWith:(UIView*)studentView;
//设置老师视频显示区域（视频课可用）
-(void)setTeacherViewWith:(UIView*)teacherView;
//设置画线宽度
-(void)setDrawLineWidthWith:(CGFloat)lineWidth;

//设置无ppt时的背景图片
-(void)setPPTViewBackgroundImage:(UIImage*)image;

//是否允许学生画线 只对1v1学生有效 1v1学生默认打开画线，不需画线时请设置此值为NO
@property(nonatomic,assign)BOOL allowDrawLine;
//所有聊天数组
@property(nonatomic,strong)NSMutableArray<NSDictionary*>* chatDictArray;
//老师和助教聊天数组
@property(nonatomic,strong)NSMutableArray<NSDictionary*>* teacherChatDictArray;
@property(nonatomic,weak)id<DBYLiveManagerDelegate>delegate;
//教室类型
@property(nonatomic,assign)DBYLiveManagerClassRoomType classRoomType;
/**
 发送聊天信息
 */
-(void)sendChatMessageWith:(NSString*)message;
/**
 发送消息

 @param message 消息内容
 @param completeHandler 完成回调 如果errorMsg不为空，则发送失败
 */
-(void)sendChatMessageWith:(NSString *)message completeHandler:(void(^)(NSString*errorMsg))completeHandler;
//发送举手发言请求 (仅限1VN)
-(void)requestRaiseHand;
/**
 发送举手发言请求 (仅限1VN)

 @param completeHandler 完成回调 如果errorMsg不为空，则发送失败
 */
-(void)requestRaiseHandWithCompleteHandler:(void(^)(NSString*errorMsg))completeHandler;

//发送投票消息
-(void)sendVoteWithOptionIndex:(NSInteger)index;
//暂停(进后台用)
-(void)pauseLive;
//恢复（回到前台）
-(void)recoverLive;
/**
 老师开关摄像头

 @param isOpen yes打开摄像头 no关闭
 */
-(void)teacherOpenCam:(BOOL)isOpen completeHandler:(void(^)(NSString*failMsg))completeHandler;


 
-(void)openMic:(BOOL)isOpen completeHandler:(void(^)(NSString*failMsg))completeHandler;


-(void)quitClassRoomWithCompleteHandler:(void(^)())completeHandler;


+(NSString*)enterRoomErrorMessageWithErrorType:(DBYLiveManagerEnterRoomErrorType)errorType;



-(void)sendMessageWithOrder:(NSString*)order;
@end
@protocol DBYLiveManagerDelegate <NSObject>
@optional

/**
 开始视频或结束视频时调用
 
 @param hasVideo 是否有视频
 @param view     在哪个View上
 */
-(void)liveManager:(DBYLiveManager*)manager hasVideo:(BOOL)hasVideo inView:(UIView*)view;
//有状态改变时调用
-(void)liveManager:(DBYLiveManager*)manager statusChangeWith:(DBYLiveManagerStatusType)statusType;
//老师点击禁止或允许显示在线用户数时调用
-(void)liveManager:(DBYLiveManager *)manager denyOnlineNumber:(BOOL)isDeny;
//用户在线数变化时调用
-(void)liveManager:(DBYLiveManager *)manager onlineUserCountWith:(NSInteger)count;
//老师在线状态改变时调用
-(void)liveManager:(DBYLiveManager *)manager teacherStatusChangedWithOnline:(BOOL)online name:(NSString*)name;
//有教室公告时调用
-(void)liveManager:(DBYLiveManager *)manager hasAnnounceContent:(NSString*)announceContent;
//全体禁言或解禁时调用 YES为禁言
-(void)liveManager:(DBYLiveManager *)manager denyChatStatusChange:(BOOL)isDeny;
//聊天频次过高时调用
-(void)liveManagerChatTooFastWith:(DBYLiveManager *)manager;
//被踢下线时调用
-(void)liveManagerDidKickedOff:(DBYLiveManager *)manager;

//选择服务器ip后调用
-(void)liveManager:(DBYLiveManager *)manager didChooseIpAddress:(NSString*)ipAddress;
//authInfo成功后调用
-(void)liveManagerDidAuthInfoSuccess:(DBYLiveManager *)manager;
//开启摄像头失败后调用
-(void)liveManagerOpenCameraFail:(DBYLiveManager*)manager;
//重连媒体服务器时调用
-(void)liveManagerDidReconnectMediaServer:(DBYLiveManager*)manager;
//连接媒体服务器失败时调用
-(void)liveManagerConnectMediaServerFail:(DBYLiveManager*)manager;

//获得教室信息后，第一次连接消息服务器成功时调用
-(void)liveManagerFirstConnectSucess:(DBYLiveManager *)manager;
//获得教室信息后，第一次连接消息服务器失败时调用
-(void)liveManagerFirstConnectError:(DBYLiveManager *)manager;
//网络差时调用
-(void)liveManagerHasNetErrorWith:(DBYLiveManager*)manager;
//网络恢复时调用
-(void)liveManagerNetOKWith:(DBYLiveManager*)manager;
#pragma mark - 聊天相关
//有聊天时调用 返回收到的最新的消息
-(void)liveManager:(DBYLiveManager *)manager hasNewChatMessageWithChatArray:(NSArray*)newChatDictArray;
//有聊天时调用 收到学生和老师助教消息
-(void)liveManager:(DBYLiveManager *)manager hasChatMessageWithChatArray:(NSArray*)chatDictArray;
//有聊天时调用 老师助教消息
-(void)liveManager:(DBYLiveManager *)manager teacherHasChatMessageWithChatArray:(NSArray*)chatDictArray;
//发送聊天失败时调用
-(void)liveManagerSendChatFail:(DBYLiveManager *)manager;
//发送聊天超出限制长度时调用
-(void)liveManagerSendChatMessageTooLong:(DBYLiveManager*)manager;
#pragma mark - ppt加载相关方法
//老师ppt翻页时调用
-(void)liveManagerTeacherChangePPTSlide:(DBYLiveManager*)manager;
//老师打开ppt或切换ppt时调用
-(void)liveManagerTeacherOpenPPT:(DBYLiveManager*)manager;
//加载ppt失败时调用
-(void)liveManagerDidFailLoadPPT:(DBYLiveManager *)manager;
#pragma mark - 举手相关方法

/**
 老师点击清空举手列表时调用
 */
-(void)liveManagerTeacherDownHands:(DBYLiveManager*)manager;
/**
 老师禁止举手时调用
 
 @param isDeny 是否禁止
 */
-(void)liveManager:(DBYLiveManager*)manager denyRaiseHand:(BOOL)isDeny;
/**
 举手失败时调用
 */
-(void)liveManagerRaiseHandFail:(DBYLiveManager *)manager;

/**
 教师给麦或收麦时调用
 
 @param canSpeak YES 表示教师给麦 ；NO 表示教师收麦
 */
-(void)liveManager:(DBYLiveManager*)manager studentCanSpeak:(BOOL)canSpeak;

/**
 老师给/收 其他学生麦时调用
 
 @param userInfo 学生信息 
 @param canSpeak YES 给麦 / NO 收麦
 */
-(void)liveManager:(DBYLiveManager*)manager teacherGiveMicToStudentWithUserInfo:(NSDictionary*)userInfo canSpeak:(BOOL)canSpeak;
#pragma mark - 答题相关方法

/**
 显示投票界面时调用
 @param voteType 投票类型
 */
-(void)liveManager:(DBYLiveManager*)manager shouldShowVoteWithType:(DBYLiveManagerVoteType)voteType;
/**
 停止答题时调用
 */
-(void)liveManagerShouldStopVote:(DBYLiveManager *)manager;
/**
 应该隐藏投票界面时调用
 */
-(void)liveManagerShouldHideVote:(DBYLiveManager *)manager;

/**
 投票数量变化时调用
 @param index   第几个选项 0为第一个选项
 @param count   此选项的变化数量 需累加
 */
-(void)liveManager:(DBYLiveManager *)manager voteChangeWithOptionIndex:(NSInteger)index optionCount:(NSInteger)count;

/**
 投票失败时调用
 */
-(void)liveManagerSendVoteFail:(DBYLiveManager *)manager;


#pragma mark - admin
-(void)liveManager:(DBYLiveManager *)manager receivedMessage:(NSString*)jsonMessage;
@end
