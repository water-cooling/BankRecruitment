//
//  DBYDownloadObject.h
//  DBYSDKDemo01
//
//  Created by Michael on 16/6/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

//下载完成通知名称
extern NSString*const DBYDownloadObjectDidFinishDownloadNotificationName;

@protocol DBYDownloadObjectDelegate ;
@interface DBYDownloadObject : NSObject <NSCoding>

+(instancetype)downloadObjectWithRoomID:(NSString*)roomID;

//下载课程的roomID
@property(nonatomic,copy)NSString* roomID;
//下载课程名称
@property(nonatomic,copy)NSString*title;


//是否在下载
@property(nonatomic,assign,getter=isDownloading)BOOL downloadIng;
//是否下载完成
@property(nonatomic,assign,getter=isFinished)BOOL finished;
//下载进度
@property(nonatomic,assign)float progress;
//当前下载速度
@property(nonatomic,assign)float currentDownloadSpeed;
/**
 *  下载数据大小
 */
@property(nonatomic,assign)unsigned long long totalLen;
//已下载大小
@property(nonatomic,assign)float downloadedSize;


//下载链接 （自动生成）
@property(nonatomic,copy)NSString* downloadURLString;
//续传数据
@property(nonatomic,strong)NSData* resumeData;

@property(nonatomic,weak)id<DBYDownloadObjectDelegate> delegate;

//一段时间内下载数据长度
@property(nonatomic,assign)unsigned long long orderTimeRecvLen;
//下载任务
@property(nonatomic,strong)NSURLSessionDownloadTask* downloadTask;


-(void)getFileLengthWith:(void(^)(unsigned long long totalLen,NSString*errorMsg))completeHandler;
@end

/**
 *  监控Object 下载进度等信息代理
 */
@protocol DBYDownloadObjectDelegate <NSObject>
@optional
/**
 *  更新下载信息时调用
 *
 *  @param downloadObject
 */
-(void)downloadObjectDidUpdateInfo:(DBYDownloadObject*)downloadObject;
/**
 *  下载完成调用
 *
 *  @param downloadObject
 */
-(void)downloadObjectFinishDownload:(DBYDownloadObject*)downloadObject;
//暂停下载调用
-(void)downloadObjectDidPauseDownload:(DBYDownloadObject *)downloadObject;
//下载出错调用
-(void)downloadObject:(DBYDownloadObject*)downloadObject didDownloadFailWithError:(NSError*)error;
@end
