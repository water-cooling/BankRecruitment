//
//  LdGlobalObj.m
//  GroupV
//
//  Created by lurn on 1/22/14.
//  Copyright (c) 2014 Lordar. All rights reserved.
//

#import "LdGlobalObj.h"
#import "LdCommon.h"
#import "DisplayCityManager.h"
#import "RemoteMessageModel.h"
#import "WebViewController.h"
#import "MockModel.h"
#import "LiveModel.h"
#import "VideoCatalogModel.h"
#import "ExaminationPaperModel.h"
#import "LiveUserClassScheduleModel.h"
#import "DBY1VNLiveViewController.h"
#import "DBY1VNPlaybackViewController.h"
#import "MockExamDetailViewController.h"
#import "RemoteExamPaperViewController.h"
#import "VideoSubViewController.h"
#import "CourseDetailViewController.h"
#import <StoreKit/StoreKit.h>
#import "BBAlertView.h"
#import "MessageWordDetailViewController.h"

#define _FIRST_RUN              @"_FIRST_RUN_"

#define _SET_WEB_IP             @"SET_WEB_IP"
#define _SET_WEB_PORT           @"SET_WEB_PORT"
#define _SET_FILE_IP            @"SET_FILE_IP"
#define _SET_FILE_GET_IP        @"SET_FILE_GET_IP"
#define _SET_FILE_SET_IP        @"SET_FILE_SET_IP"
#define SET_HTML_SET_IP        @"SET_HTML_SET_IP"

#define _APNS_TOKEN             @"_APNS_TOKEN_"

#define _CUSR_NAME              @"_CUSR_NAME_"
#define _CUSR_TEL_NUM           @"_CUSR_TEL_NUM_"
#define _CUSR_PASSWORD          @"_CUSR_PASSWORD_"
#define _CUSR_IP                @"_CUSR_IP_"
#define _CUSR_OPEN_FIRE_PORT    @"_CUSR_OPEN_FIRE_PORT_"
#define _CUSR_STATUS_PORT       @"_CUSR_STATUS_PORT_"
#define _CUSR_OPEN_FIRE_NAME    @"_CUSR_OPEN_FIRE_NAME_"
#define _CUSR_OPEN_FIRE_PWD     @"_CUSR_OPEN_FIRE_PWD_"
#define _CUSR_IS_CM             @"_CUSR_IS_CM_"
#define _CUSR_CORP_TEL_NUM      @"_CUSR_CORP_TEL_NUM_"
#define _CUSR_CORP_ID           @"_CUSR_CORP_ID_"

static LdGlobalObj* _glbObj;

//
// interface
//
@interface LdGlobalObj()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (strong, nonatomic) id me;
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *payObjectId;
@end

@implementation LdGlobalObj

+(LdGlobalObj*)sharedInstanse
{
    if(!_glbObj)
    {
        _glbObj = [[LdGlobalObj alloc] init];
        [_glbObj initObjs];
        _glbObj.me = _glbObj;
    }
    
    return _glbObj;
}

// get setting value with default value
-(id)getSettingForKey:(NSString*)key default:(id)value
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        return value;
    }
    else
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
}

// 初始化对象
-(void)initObjs
{
    //
    // 服务器配置
    //
    self.firstLoginIn = YES;
    self.isSaveFlowFlag = NO;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *isWarnLiveFlag = [def objectForKey:@"KWarnLiveFlag"];
    if(isWarnLiveFlag)
    {
        self.isWarnExamFlag = isWarnLiveFlag.boolValue;
    }
    else
    {
        self.isWarnExamFlag = YES;
    }
    
    NSNumber *isNightFlag = [def objectForKey:@"isNightExamFlag"];
    if(isNightFlag)
    {
        self.isNightExamFlag = isNightFlag.boolValue;
    }
    else
    {
        self.isNightExamFlag = NO;
    }
    NSNumber *examFontSize = [def objectForKey:@"examFontSize"];
    if(examFontSize)
    {
        self.examFontSize = examFontSize.intValue;
    }
    else
    {
        self.examFontSize = 14;
    }

    self.httpSelect = GlobalHttpSelectClose;
    self.firstExaminPaperEID = @"";
    self.user_id = @"0";
    self.user_mobile = @"";
    self.user_name = @"";
    self.currentCityId = @"";
    self.currentCityName = @"";
    self.deviceToken = @"";
    self.bussinessArrayFromLocal = [NSMutableArray arrayWithCapacity:9];
    self.shareUrl = @"https://appsto.re/cn/ApYQ_.i";
    self.favoriteTypeArray = [NSMutableArray arrayWithCapacity:9];
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    CLLocationCoordinate2D Coordinate;
    Coordinate.longitude = 0;
    Coordinate.latitude = 0;
    self.user_Coordinate = Coordinate;
    self.advList = [NSMutableArray arrayWithCapacity:9];
    
    //
    // 以下地址切记不可修改为开发环境
    //http://120.26.192.48:8080/bshApp/AppAction?action=getBootScrollPics&uid=0
    self.webAppIp       = @"http://yk.yinhangzhaopin.com/bshApp/AppAction";
    self.webAppPort     = [self getSettingForKey:_SET_WEB_PORT default:@"10007"];
    self.fileServIp     = @"http://yk.yinhangzhaopin.com/";
    self.fileGetPort    = [self getSettingForKey:_SET_FILE_GET_IP default:@"10008"];
    self.fileSetPort    = [self getSettingForKey:_SET_FILE_SET_IP default:@"10009"];
    self.htmlServIp     = @"http://yk.yinhangzhaopin.com/zlh5/";

    //
    // 路径初始化
    //
    self.homePath = NSHomeDirectory();
    
    self.docPath = [self.homePath stringByAppendingPathComponent:@"Documents"];
    self.tempPath = [self.homePath stringByAppendingPathComponent:@"tmp"];
    
    self.dataPath = [self.docPath stringByAppendingPathComponent:@"data"];
    self.cachePath = [self.docPath stringByAppendingPathComponent:@"cache"];
 
    // 创建数据路径
    if (![[NSFileManager defaultManager] fileExistsAtPath: self.dataPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath: self.dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    // 创建缓存路径
    if (![[NSFileManager defaultManager] fileExistsAtPath: self.cachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath: self.cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    // 添加购买监听
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

// 定义成方法方便多个label调用 增加代码的复用性
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传入的字体字典
                                       context:nil];
    
    return rect.size;
}

// 定义成方法方便多个label调用 增加代码的复用性
+ (CGSize)sizeWithAttributedString:(NSAttributedString *)string width:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 9000)];
    label.numberOfLines = 0;
    label.attributedText = string;
    [label sizeToFit];
    CGSize size = [label sizeThatFits:label.frame.size];
//    NSInteger rowNum = size.height/[UIFont systemFontOfSize:[LdGlobalObj sharedInstanse].examFontSize].lineHeight;
//    if(rowNum==1)
//    {
//        return CGSizeMake(size.width, size.height-15);
//    }
//    else
//    {
        return size;
//    }
}

- (void)startExamTimer
{
    if([LdGlobalObj sharedInstanse].examTimer)
    {
        [[LdGlobalObj sharedInstanse].examTimer invalidate];
        [LdGlobalObj sharedInstanse].examTimer = nil;
    }
    [LdGlobalObj sharedInstanse].examTimerNumber = [NSNumber numberWithInt:0];
    [LdGlobalObj sharedInstanse].examTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(examTimerAction) userInfo:nil repeats:YES];
}

- (void)stopExamTimer
{
    [[LdGlobalObj sharedInstanse].examTimer invalidate];
}

- (void)pauseExamTimer
{
    [[LdGlobalObj sharedInstanse].examTimer setFireDate:[NSDate distantFuture]];
}

- (void)resumeExamTimer
{
    [[LdGlobalObj sharedInstanse].examTimer setFireDate:[NSDate date]];
}

- (void)examTimerAction
{
    int number = [LdGlobalObj sharedInstanse].examTimerNumber.intValue;
    [LdGlobalObj sharedInstanse].examTimerNumber = [NSNumber numberWithInt:++number];
}

#pragma processRemoteMessage
- (void)processRemoteMessage:(RemoteMessageModel *)remoteMessageModel
{
    if([remoteMessageModel.mType isEqualToString:@"全员推送"])
    {
        if(strIsNullOrEmpty(remoteMessageModel.msgUrl))
        {
            //进入一个显示消息文字的页面
            UINavigationController *currentNav = (UINavigationController *)[LdGlobalObj sharedInstanse].homePageVC.selectedViewController;
            MessageWordDetailViewController *vc = [[MessageWordDetailViewController alloc] init];
            vc.detailString = remoteMessageModel.msg;
            vc.title = remoteMessageModel.name;
            [currentNav pushViewController:vc animated:YES];
            
        }else{
            UINavigationController *currentNav = (UINavigationController *)[LdGlobalObj sharedInstanse].homePageVC.selectedViewController;
            WebViewController *vc = [[WebViewController alloc] init];
            vc.urlString = remoteMessageModel.msgUrl;
            vc.title = remoteMessageModel.name;
            [currentNav pushViewController:vc animated:YES];
        }
        
        return;
    }
    
    [LLRequestClass requestdoGetAdvDetailBytitle:remoteMessageModel.mType path:remoteMessageModel.linkId Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            UINavigationController *currentNav = (UINavigationController *)[LdGlobalObj sharedInstanse].homePageVC.selectedViewController;
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                if([remoteMessageModel.mType isEqualToString:@"模考报名"])
                {
                    //进入模考详情
                    MockModel *model = [MockModel model];
                    [model setDataWithDic:contentDict];
                    MockExamDetailViewController *vc = [[MockExamDetailViewController alloc] init];
                    vc.mockModelID = model.ID;
                    vc.hidesBottomBarWhenPushed = YES;
                    [currentNav pushViewController:vc animated:YES];
                }
                else if([remoteMessageModel.mType isEqualToString:@"关联课程"])
                {
                    //带房间号，进入到直播房间
                    [self gotoLiveRoomByDict:contentDict];
                }
                else if([remoteMessageModel.mType isEqualToString:@"关联试卷"])
                {
                    //展现给客户试卷 列表信息 ，点击列表 进入到考试
                    ExaminationPaperModel *model = [ExaminationPaperModel model];
                    [model setDataWithDic:contentDict];
                    RemoteExamPaperViewController *vc = [[RemoteExamPaperViewController alloc] init];
                    vc.paperModel = model;
                    vc.hidesBottomBarWhenPushed = YES;
                    [currentNav pushViewController:vc animated:YES];
                }
                else if([remoteMessageModel.mType isEqualToString:@"关联视频"])
                {
                    //（指定人员推送，发送指定视频列表ID  calog）给出列表下的几个视频详情
                    VideoCatalogModel *model = [VideoCatalogModel model];
                    [model setDataWithDic:contentDict];

//                    [LdGlobalObj sharedInstanse].VideoVC.isFirstLoad = NO;
                    [LdGlobalObj sharedInstanse].homePageVC.selectedIndex = 2;
                    [self performSelector:@selector(jumpVideoViewBy:) withObject:model afterDelay:0.3];
                }
                else if([remoteMessageModel.mType isEqualToString:@"全员推送模考"])
                {
                    //模考详情   -显示模块的页面
                    MockModel *model = [MockModel model];
                    [model setDataWithDic:contentDict];
                    MockExamDetailViewController *vc = [[MockExamDetailViewController alloc] init];
                    vc.mockModelID = model.ID;
                    vc.hidesBottomBarWhenPushed = YES;
                    [currentNav pushViewController:vc animated:YES];
                }
                else if([remoteMessageModel.mType isEqualToString:@"全员推送课程"])
                {
                    //显示直播课的广告页面
                    LiveModel *model = [LiveModel model];
                    [model setDataWithDic:contentDict];
                    CourseDetailViewController *vc = [[CourseDetailViewController alloc] init];
                    vc.liveModel = model;
                    vc.hidesBottomBarWhenPushed = YES;
                    [currentNav pushViewController:vc animated:YES];
                }
                else if([remoteMessageModel.mType isEqualToString:@"全员推送试卷"])
                {
                    //显示试卷列表，但是要带上 多少人购买 和 价格，点击显示试卷的详情
                    ExaminationPaperModel *model = [ExaminationPaperModel model];
                    [model setDataWithDic:contentDict];
                    RemoteExamPaperViewController *vc = [[RemoteExamPaperViewController alloc] init];
                    vc.paperModel = model;
                    vc.hidesBottomBarWhenPushed = YES;
                    [currentNav pushViewController:vc animated:YES];
                }
                else if([remoteMessageModel.mType isEqualToString:@"全员推送视频"])
                {
                    //指定到视频界面，上方显示推送过来的大类，自己通过大类名称 获取到下级
                    VideoCatalogModel *model = [VideoCatalogModel model];
                    [model setDataWithDic:contentDict];

//                    [LdGlobalObj sharedInstanse].VideoVC.isFirstLoad = NO;
                    [LdGlobalObj sharedInstanse].homePageVC.selectedIndex = 2;
                    [self performSelector:@selector(jumpVideoViewBy:) withObject:model afterDelay:0.3];
                }
            }
            else
            {
                ZB_Toast(@"查看失败");
            }
        }
        else
        {
//            ZB_Toast(@"查看失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        ZB_Toast(@"查看失败");
    }];
}

- (void)jumpVideoViewBy:(VideoCatalogModel *)model
{
    [[LdGlobalObj sharedInstanse].VideoVC refreshRemoteMessageVideoListBy:model];
}

//带房间号，进入到直播房间
- (void)gotoLiveRoomByDict:(NSDictionary *)dict
{
    LiveModel *model = [LiveModel model];
    [model setDataWithDic:dict];
    
    [LLRequestClass requestdoGetLiveInfoBySID:model.LID Success:^(id jsonData) {
        NSArray *contentArray1=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray1);
        if(contentArray1.count > 0)
        {
            NSDictionary *contentDict1 = contentArray1.firstObject;
            NSString *result = [contentDict1 objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                LiveUserClassScheduleModel *model = [LiveUserClassScheduleModel model];
                [model setDataWithDic:contentDict1];
                
                NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
                dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
                NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
                NSDate *EndDate = [dateFmt dateFromString:model.EndDate];
                NSDate *currentDate = [NSDate date];
                if([currentDate earlierDate:BegDate]==BegDate&&[currentDate laterDate:EndDate]==EndDate)
                {
                    if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
                    {
                        [self gotoLiveClassByUrl:model.AFile AndName:model.Intro];
                        [self NetworkUploadLiveScheduleLogBySID:model.SID];
                    }
                    else
                    {
                        BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"请登录后再进入直播间，否则可能会播放失败" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"游客身份进入"];
                        LL_WEAK_OBJC(self);
                        [alertView setConfirmBlock:^{
                            [weakself gotoLiveClassByUrl:model.AFile AndName:model.Intro];
                            [weakself NetworkUploadLiveScheduleLogBySID:model.SID];
                        }];
                        [alertView show];
                    }
                }
                else if([EndDate laterDate:currentDate] == currentDate)
                {
                    if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
                    {
                        [self gotoHositoryClassByUrl:model.AFile AndName:model.Intro];
                        [self NetworkUploadLiveScheduleLogBySID:model.SID];
                    }
                    else
                    {
                        BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"请登录后再进入回放，否则可能会播放失败" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"游客身份进入"];
                        LL_WEAK_OBJC(self);
                        [alertView setConfirmBlock:^{
                            [weakself gotoHositoryClassByUrl:model.AFile AndName:model.Intro];
                            [weakself NetworkUploadLiveScheduleLogBySID:model.SID];
                        }];
                        [alertView show];
                    }
                }
                else
                {
                    ZB_Toast(@"直播还未开始哦");
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)gotoLiveClassByUrl:(NSString *)roomID AndName:(NSString *)name;
{
    DBY1VNLiveViewController* testVC = [[DBY1VNLiveViewController alloc] init];
    testVC.title = name;//
    testVC.appkey = @"4f9739ab849c46cda986f665a903ff40";//    appkey
    testVC.partnerID = @"20170419161441324358";//   partnerID
    testVC.roomID = roomID;//roomID
    testVC.userID = [LdGlobalObj sharedInstanse].user_id;//       ID
    testVC.nickName = [LdGlobalObj sharedInstanse].user_name;//
    testVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *currentNav = (UINavigationController *)[LdGlobalObj sharedInstanse].homePageVC.selectedViewController;
    [currentNav showViewController:testVC sender :nil];
}

- (void)gotoHositoryClassByUrl:(NSString *)roomID AndName:(NSString *)name;
{
    DBY1VNPlaybackViewController* testVC = [[DBY1VNPlaybackViewController alloc] init];
    testVC.title = name;//
    testVC.appkey = @"4f9739ab849c46cda986f665a903ff40";//    appkey
    testVC.partnerID = @"20170419161441324358";//   partnerID
    testVC.roomID = roomID;//roomID
    testVC.uid = [LdGlobalObj sharedInstanse].user_id;//       ID
    testVC.nickName = [LdGlobalObj sharedInstanse].user_name;//
    testVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *currentNav = (UINavigationController *)[LdGlobalObj sharedInstanse].homePageVC.selectedViewController;
    [currentNav showViewController:testVC sender :nil];
}

- (void)NetworkUploadLiveScheduleLogBySID:(NSString *)SID
{
    [LLRequestClass requestUploadLiveScheduleLogBySID:SID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                
            }
        }
        
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}


#pragma -mark Apple pay
- (void)payActionByType:(NSString *)buyType payID:(NSString *)payID
{
    if([SKPaymentQueue canMakePayments]){
        self.payObjectId = payID;
        [self NetworkGetPayInfoByType:buyType payID:payID];
    }else{
        ZB_Toast(@"您的手机没有打开程序内付费购买");
    }
}

- (void)purchaseFunc:(NSString *)productID {
    [self requestProductData:productID];
}

//请求商品
- (void)requestProductData:(NSString *)productID{
    NSArray *product = [[NSArray alloc] initWithObjects:productID, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

#pragma mark -  SKProductsRequestDelegate代理
//返回的在苹果服务器请求的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        [SVProgressHUD dismiss];
        ZB_Toast(@"支付失败：查询商品信息失败");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%d",(int)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        p = pro;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [SVProgressHUD dismiss];
    ZB_Toast(@"支付失败");
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
    
//    [SVProgressHUD dismiss];
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                [self completeTransaction:tran];
                
                //从沙盒中获取交易凭证并且拼接成请求体数据
                NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
                NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
                
                if(strIsNullOrEmpty(receiptString))
                {
                    return;
                }
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                NSArray *array = [defaults objectForKey:@"unCheckReceiptStringArray"];
                NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:9];
                if(array)
                {
                    mutArray = [NSMutableArray arrayWithArray:array];
                }
                if(![mutArray containsObject:receiptString])
                {
                    [mutArray addObject:receiptString];
                }
                [defaults setObject:mutArray forKey:@"unCheckReceiptStringArray"];
                [defaults synchronize];
                
                [self verifyAppStorePurchaseWithPaymentTransactionByreceiptString:receiptString];
                return;
            }
                break;
            case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"商品添加进列表");
            }
                break;
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"已经购买过商品");
//                [SVProgressHUD dismiss];
//                [self NetworkSendPaySuccess];
////                ZB_Toast(@"已经购买过商品");
//                [self completeTransaction:tran];
//                return;
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"商品购买失败失败");
//                ZB_Toast(@"购买失败");
                [SVProgressHUD dismiss];
                [self completeTransaction:tran];
                return;
            }
                break;
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    _purchasedItemIDs = [[NSMutableArray alloc] init];
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [_purchasedItemIDs addObject:productID];
        NSLog(@"%@",productID);
    }
}

- (void)NetworkGetPayInfoByType:(NSString *)payType payID:(NSString *)payID
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetPayInfoBytype_pay:@"苹果内购" type:payType ID:payID Success:^(id jsonData) {
        NSDictionary *contentDic=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDic);
        if([contentDic isKindOfClass:[NSArray class]])
        {
            [SVProgressHUD dismiss];
            ZB_Toast(@"支付失败");
            return;
        }
        
        NSString *result = [contentDic objectForKey:@"result"];
        if([result isEqualToString:@"success"])
        {
            NSDictionary *PurshIOS = contentDic[@"PurshIOS"];
            self.orderId = PurshIOS[@"ID"];
            
            [self purchaseFunc:PurshIOS[@"IOSPurch"]];
        }
        else
        {
            [SVProgressHUD dismiss];
            ZB_Toast(@"支付失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        ZB_Toast(@"支付失败");
    }];
}

- (void)NetworkSendPaySuccess
{
    [LLRequestClass requestSendPaySuccessById:self.orderId LinkID:self.payObjectId Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                if(self.buyObjectSuccessBlock)
                {
                    self.buyObjectSuccessBlock();
                }
                return;
            }
        }
        ZB_Toast(@"支付上报失败");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
//验证购买，避免越狱软件模拟苹果请求达到非法购买问题

-(void)verifyAppStorePurchaseWithPaymentTransactionByreceiptString:(NSString *)receiptString{
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建请求到苹果官方进行购买验证
    NSURL *url = [NSURL URLWithString:AppStore];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    [NSURLConnection sendAsynchronousRequest:requestM queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            [SVProgressHUD dismiss];
            ZB_Toast(@"购买验证失败");
            NSLog(@"验证购买过程中发生错误，错误信息：%@",connectionError.localizedDescription);
            
            //再请求
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self verifyAppStorePurchaseWithPaymentTransactionByreceiptString:receiptString];
            });
            NSLog(@"遗漏订单验证网络异常");
            
            return;
        }
        else
        {
            [self removeUnchekReceipt:receiptString];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dic);
            if([dic[@"status"] intValue]==0){
                [SVProgressHUD dismiss];
                [self NetworkSendPaySuccess];
            }else if([dic[@"status"] intValue]==21007){
                NSLog(@"在测试环境中取的票据，但是却到正式地址去验证");
                [self verifySANDBOXPurchaseWithPaymentTransactionByreceiptString:receiptString];
            }else{
                ZB_Toast(@"购买验证失败");
                [SVProgressHUD dismiss];
            }
        }
    }];
}

-(void)verifySANDBOXPurchaseWithPaymentTransactionByreceiptString:(NSString *)receiptString{
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    [NSURLConnection sendAsynchronousRequest:requestM queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            [SVProgressHUD dismiss];
            ZB_Toast(@"购买验证失败");
            NSLog(@"验证购买过程中发生错误，错误信息：%@", connectionError.localizedDescription);
            
            //再请求
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self verifyAppStorePurchaseWithPaymentTransactionByreceiptString:receiptString];
            });
            NSLog(@"遗漏订单验证网络异常");
            return;
        }
        else
        {
            [self removeUnchekReceipt:receiptString];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dic);
            if([dic[@"status"] intValue]==0){
                [SVProgressHUD dismiss];
                [self NetworkSendPaySuccess];
            }else{
                ZB_Toast(@"购买验证失败");
                [SVProgressHUD dismiss];
            }
        }
    }];
}

- (void)removeUnchekReceipt:(NSString *)receiptString
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"unCheckReceiptStringArray"];
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:9];
    if(array)
    {
        mutArray = [NSMutableArray arrayWithArray:array];
    }
    if([mutArray containsObject:receiptString])
    {
        [mutArray removeObject:receiptString];
    }
    [defaults setObject:mutArray forKey:@"unCheckReceiptStringArray"];
    [defaults synchronize];
}

- (void)checkUnchekReceipt {
    //取出票据
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"unCheckReceiptStringArray"];
    if ((!array) || (array.count == 0)) {
        return;
    }
    
    for (NSString *urlPara in array) {
        [self verifyAppStorePurchaseWithPaymentTransactionByreceiptString:urlPara];
    }
}

@end
