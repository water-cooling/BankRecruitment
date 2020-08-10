//
//  DBYClient.h
//  DBYSDKDemo01
//
//  Created by Michael on 16/6/23.
//  Copyright © 2016年 Michael. All rights reserved.
//  SDK接口

#import <Foundation/Foundation.h>
#import "DBYDownloadObject.h"
#import "DBYSDKConfigDef.h"

typedef enum : NSUInteger {
    DBYClientDownloadObjectStateNotDownload=0,
    DBYClientDownloadObjectStateDownloading,
    DBYClientDownloadObjectStatePausing,
    DBYClientDownloadObjectStateWaiting,
    DBYClientDownloadObjectStateDownloaded
} DBYClientDownloadObjectState;


typedef enum : NSUInteger {
    DBYClientServerErrorWrongAppKey = 0,//错误的appKey  SDK设置相关
    DBYClientServerErrorNoBaseFilePath,//没有设置文件基本路径 SDK设置相关
    DBYClientServerErrorCanNotFindConfigJSON,//找不到configJSON 课程文件缺失 建议重新下载
    DBYClientServerErrorCanNotFindPlayBackJSON,//找不到playback JSON文件 课程文件缺失 建议重新下载
    DBYClientServerErrorNotFindPlayer,//没有找到播放器 下载播放器
    DBYClientServerErrorFailStartServer,//虚拟服务器开启失败 重试。。
} DBYClientServerError;
@interface DBYClient : NSObject
//返回sdk版本号
+(NSString*)SDKVersion;
#pragma mark - setting methods
/**
 *  设置解密秘钥
 *
 */
+(void)setAppKeyWith:(NSString*)appkey;
/**
 *  设置下载、虚拟服务器 基本路径
 *
 */
+(void)setFilePathWith:(NSString*)filePath;
/**
 *  设置获取web播放器版本字符串
 *
 */
+(void)setPlayerVersion:(NSString*)playerVersion;
#pragma mark - download methods
/**
 *  根据downloadObject对象开始下载
 *
 */
+(void)startDownloadWith:(DBYDownloadObject*)downloadObj;

/**
 *  停止下载，不保存续传数据
 *
 */
+(void)stopDownloadWith:(DBYDownloadObject*)downloadObj;
/**
 *  暂停下载，保存续传数据
 *
 */
+(void)pauseDownloadWith:(DBYDownloadObject*)downloadObj;
/**
 *  恢复下载
 *
 */
+(void)resumeDownloadWith:(DBYDownloadObject*)downloadObj;


/**
 从保存的本地归档文件恢复下载

 @param continueDownload 是否继续下载 YES：之前在下载的开始继续下载 暂停的存入暂停数组 等待的存入等待数组
 NO：所有下载任务存入暂停数组
 */
+(void)recoverDownloadObjectsWithContinueDownload:(BOOL)continueDownload;


/**
 根据roomid返回课程下载状态
 */
+(DBYClientDownloadObjectState)getDownloadStateWithRoomID:(NSString *)roomID;

/**
 根据roomID返回下载obj
 
 @return 如果没有对应roomID的Obj则返回nil
 */
+(DBYDownloadObject*)getDownloadObjectWithRoomID:(NSString*)roomID;

//暂停所有downloadObj 下载中的会暂停下载 存入暂停数组 等待中的会直接存入暂停数组
+(void)pauseAllDownloadObject;

//开始所有downloadObj 会根据下载限制 开始下载,并存入下载中数组 超过下载限制的存入等待数组
+(void)startAllDownlaodObject;
#pragma mark - download manage
/**
 *  设置最大同时下载数
 *
 */
+(void)setMaxDownloadCount:(int)maxDownloadCount;
/**
 *  获得最大下载数
 *
 */
+(int)getMaxDownloadCount;
/**
 *  返回正在下载objs 数组
 *
 */
+(NSArray*)downloadingObjects;
/**
 *  返回等待下载objs 数组
 *
 */
+(NSArray*)waitingObjects;
/**
 *  返回暂停下载objs 数组
 *
 */
+(NSArray*)pausingObjects;
/**
 *  返回下载失败的数组
 *
 */
+(NSArray*)errorObjects;
#pragma mark - lesson methods
/**
 *  删除对应roomID的本地课程
 *
 *
 *  @return 是否删除成功
 */
+(BOOL)removeLessonWith:(NSString*)roomID;

/**
 *  检查课程是否存在
 */
+(BOOL)checkLessonExistedWith:(NSString*)roomID;
/**
 *  返回课程本地文件夹路径
 */
+(NSString*)getLessonFilePathWith:(NSString*)roomID;
#pragma mark - player methods;
/**
 *  检查播放器是否存在
 */
+(BOOL)checkPlayerExisted;
/**
 *
 */
/**
 *  下载播放器
 *  会先检查本地播放器版本 有新版才下载
 *
 *  @param complateHandler 完成回调
 */
+(void)downloadPlayerWith:(void (^)(NSError*error))complateHandler;


#pragma mark - server methods
/**
 *  根据roomID开启虚拟服务器,返回虚拟服务器链接的字符串
 *
 */
+(NSString *)startServerWith:(NSString *)roomID;

/**
 停止播放器
 */
+(void)stopServer;
/**
 根据roomID开启虚拟服务器

 @param roomID          roomID
 @param completeHandler 完成回调 参数是服务器链接字符串
 @param failHandler     失败回调 参数是错误类型枚举
 */
+(void)startServerWith:(NSString*)roomID completeHandler:(void(^)(NSString* serverURL))completeHandler failHandler:(void(^)(DBYClientServerError error))failHandler;

#if DBYSDKSUPPORTBACKGROUNDDOWNLOAD

#pragma mark - background download
//使用后台下载时，返回session id
+(NSString*)sessionIdentifier;
//保存后台下载完成回调
+(void)addCompletionHandler:(void(^)())handler forSession:(NSString *)identifier;
//app被杀死后 需调用此方法恢复下载任务
+(void)recoverDownloadFromBackground;
#endif
@end
