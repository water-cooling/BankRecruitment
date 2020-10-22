//
//  LdGlobalObj.h
//  GroupV
//
//  Created by lurn on 1/22/14.
//  Copyright (c) 2014 Lordar. All rights reserved.
//
//
// 该类用于保存全局变量，以及操作场景相关变量
//
// 注意：
// 1. ViewControlller 必须用已有机制管理对象，此处只使用weak方式引用，便于调用
// 2. 对于需要本对象管理的对象可以是strong
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "FirstpageViewController.h"
#import "LiveViewController.h"
#import "MineViewController.h"
#import "NewsViewController.h"
#import "VideoViewController.h"
#import "VideoSelectViewController.h"
#import "TabbarViewController.h"
#import "LoginViewController.h"
#import "WSPageView.h"
#import <UShareUI/UShareUI.h>

typedef enum {
    GlobalHttpSelectClose = 0,    //https关闭
    GlobalHttpSelectOpen,        //https打开
} GlobalHttpSelect;

typedef void (^BuyObjectSuccessBlock)();

@class RemoteMessageModel;

@interface LdGlobalObj : NSObject

//
// properties
//
// 运行时常量
@property (assign, nonatomic) BOOL firstLoginIn;            // 每次打开app并登录
@property (assign, nonatomic) BOOL isSaveFlowFlag;
@property (assign, nonatomic) BOOL isNightExamFlag;
@property (assign, nonatomic) BOOL isWarnExamFlag;
@property (assign, nonatomic) int examFontSize;
@property (assign, nonatomic) GlobalHttpSelect httpSelect;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSString *firstExaminPaperEID;
@property (nonatomic, strong) NSMutableArray *advList;
@property (strong, nonatomic) NSString* sessionKey;
@property (strong, nonatomic) NSString* user_id;
@property (strong, nonatomic) NSString* user_mobile;
@property (strong, nonatomic) NSString* user_name;
@property (strong, nonatomic) NSString* tech_id;
@property (assign, nonatomic) BOOL islive;
@property (assign, nonatomic) BOOL islogin;

@property (assign, nonatomic) BOOL istecher;
@property (strong, nonatomic) NSString* user_acc;//积分
@property (strong, nonatomic) NSString* user_LastSign;//最后一次签到
@property (strong, nonatomic) NSString* user_SignDays;//连续签到

@property (nonatomic, assign) CLLocationCoordinate2D user_Coordinate; ///用户的坐标
@property (strong, nonatomic) NSString* currentCityName;
@property (strong, nonatomic) NSString* currentCityId;
@property (strong, nonatomic) NSMutableArray *bussinessArrayFromLocal;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *shareUrl;
@property (nonatomic, strong) NSMutableArray *favoriteTypeArray;
@property (nonatomic, strong) NSMutableArray *purchasedItemIDs;

// ViewController
@property (nonatomic, weak) AppDelegate* appDelegate;
@property (nonatomic, weak) FirstpageViewController *firstPageVC;
@property (nonatomic, weak) TabbarViewController *homePageVC;
@property (nonatomic, weak) LiveViewController *liveVC;
@property (nonatomic, weak) VideoSelectViewController *VideoVC;
@property (nonatomic, weak) NewsViewController *newsVC;
@property (nonatomic, weak) MineViewController *MineVC;
@property (nonatomic, strong) LoginViewController *loginVC;

// 服务器信息
@property (strong, nonatomic) NSString* webAppIp;
@property (strong, nonatomic) NSString* webNewAppIp;
@property (strong, nonatomic) NSString* webAppPort;
@property (strong, nonatomic) NSString* fileServIp;
@property (strong, nonatomic) NSString* fileGetPort;
@property (strong, nonatomic) NSString* fileSetPort;
@property (strong, nonatomic) NSString* htmlServIp;

// 存储数据库
@property (strong, nonatomic) NSString* homePath;   // 程序根路径
@property (strong, nonatomic) NSString* docPath;    // Documents 路径
@property (strong, nonatomic) NSString* dataPath;   // 存储通讯录等程序运行必须的数据
@property (strong, nonatomic) NSString* cachePath;  // 缓存数据，图片、声音、录像等数据，可以清除的数据
@property (strong, nonatomic) NSString* tempPath;   // 临时数据，可以被随时删除的数据

@property (strong, nonatomic) NSString* addressDBPath; // 通讯录数据库地址
@property (strong, nonatomic) NSString* mainDBPath; // 程序数据库地址

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) NSTimer *examTimer;
@property (nonatomic, strong) NSNumber *examTimerNumber;

@property (nonatomic, strong) WSPageView *pageView;

@property (nonatomic, copy) BuyObjectSuccessBlock buyObjectSuccessBlock;

//
// functions
//
+(LdGlobalObj*)sharedInstanse;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;
+ (CGSize)sizeWithAttributedString:(NSAttributedString *)string width:(CGFloat)width;
+ (CGSize)boundsWithAttributeString:(NSAttributedString *)attributeString needWidth:(CGFloat)needWidth;
- (void)startExamTimer;
- (void)pauseExamTimer;
- (void)stopExamTimer;
- (void)resumeExamTimer;
- (void)processRemoteMessage:(RemoteMessageModel *)remoteMessageModel;
- (void)payActionByType:(NSString *)buyType payID:(NSString *)payID;
- (void)checkUnchekReceipt;
@end
