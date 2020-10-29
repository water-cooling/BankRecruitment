//
//  LdCommon.h
//  GroupV
//
//  Created by lurn on 1/25/14.
//  Copyright (c) 2014 Lordar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LdGlobalObj.h"
#import "UIColor+Addition.h"
#import "LdActionSheet.h"
#import "SNToast.h"

/* 使用高德SDK, 请首先注册APIKey, 注册APIKey请参考 http://lbs.amap.com/console/key
 */
const static NSString *APIKey = @"bd7a0d4add223891c4aee367f68961aa";

//提示框信息展示
#define ZB_Toast(string) [SNToast toast:string];

#define kHttpRequestTimeout 15

#define kHttpRequestFailedShowTime 2

#define kMulriple [UIScreen mainScreen].bounds.size.width / 375.0

#define kDefaultSquareImage [UIImage imageNamed:@"LaunchImage"]
#define kDefaultHorizontalRectangleImage [UIImage imageNamed:@"banner_default"]

#define kexampleUserLongitude 114.213000
#define kexampleUserLatitude 22.294959

#define MJWeakSelf __weak typeof(self) weakSelf = self;

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define LLLocalizedString(key) [[InternationalControl bundle] localizedStringForKey:key value:nil table:@"Localizable"]

#pragma mark - Navigation
//头部Navigation Bar颜色值为：＃42B4FF
//
//边线颜色均为：＃e6e6e6
//
//底部灰色背景及间隔颜色均为：＃f3f3f3
//
//内容区域背景色均为：＃ffffff

//字体颜色均为：＃333333


#define kColorBarGrayBackground UIColorFromHex(0xf3f3f3)
#define kColorLineSepBackground UIColorFromHex(0xe6e6e6)
#define kColorSelect UIColorFromHex(0x51a6ff)
#define kColorNavigationBar [UIColor whiteColor]
#define kColorDarkText UIColorFromHex(0x444444)
#define kColorBlackText [UIColor colorWithHex:@"#333333"]
#define KColorBlueText [UIColor colorWithHex:@"#558CF4"]


#pragma mark--常用define
//判断是否是IOS7以上系统
#define IS_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)
#define IS_IOS8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8)
#define IS_IOS9 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] == 9)
#define IS_IOS10 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] == 10)
//判断是否是各个尺寸英寸的屏幕
#define IS_Iphone4 fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)480 ) < DBL_EPSILON
#define IS_Iphone5 fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON
#define IS_Iphone6 fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)667 ) < DBL_EPSILON
#define IS_Iphone6Plus fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)736 ) < DBL_EPSILON
#define IS_iPhoneX (Screen_Width == 375.f && Screen_Height == 812.f ? YES : NO)
//获取屏幕宽和高
#define Screen_Width CGRectGetWidth([[UIScreen mainScreen] bounds])
#define Screen_Height CGRectGetHeight([[UIScreen mainScreen] bounds])

#define kExamTitleCellWidthOffset (IS_Iphone6Plus ? 54.0f : 44.f)

// Status bar height.
#define  StatusBarHeight      (IS_iPhoneX ? 44.f : 20.f)

// Status bar & navigation bar height.
#define StatusBarAndNavigationBarHeight  (IS_iPhoneX ? 88.f : 64.f)
#define ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

// Tabbar height.
#define  TabbarHeight         (IS_iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  TabbarSafeBottomMargin         (IS_iPhoneX ? 34.f : 0.f)

//App主Delegate
#define appDelegate          ((AppDelegate *)[[UIApplication sharedApplication] delegate])
//导航栏高度
#define NavigationBar_Height        44
//底部bar高度
#define TABBAR_HEIGHT               49
//获取View的位置信息，最大最小的X，Y坐标，及View的宽和高
#define MinY(x)         CGRectGetMinY(x.frame)
#define MaxY(x)         CGRectGetMaxY(x.frame)
#define MinX(x)         CGRectGetMinX(x.frame)
#define MaxX(x)         CGRectGetMaxX(x.frame)
#define Width(x)        CGRectGetWidth(x.frame)
#define Height(x)       CGRectGetHeight(x.frame)
//颜色RGB值
#define UIColorRef(red1,green1,blue1) [UIColor colorWithRed:red1/255.0f green:green1/255.0f blue:blue1/255.0f alpha:1.0f]
//判断从json返回的string值的正确值
#define STR_VALUE(string) (string==nil||[string isKindOfClass:[NSNull class]]||[[NSString stringWithFormat:@"%@", string] length]==0)?@"":string
//数据解析
#define EncodeFromDic(dic,key) [dic[key] isKindOfClass:[NSString class]]?dic[key]:([dic[key] isKindOfClass:[NSNumber class]] ? [dic[key] stringValue]:@"")
//通知中心
#define NotificationCenter  [NSNotificationCenter defaultCenter]
//G－C－D中经常用到的
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//打印相关
#define _po(o) NSLog(@"%@", (o))
#define _pn(o) NSLog(@"%d", (o))
#define _pf(o) NSLog(@"%f", (o))
#define _ps(o) NSLog(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) NSLog(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.y, (o).size.width, (o).size.height)
#define DOBJ(obj) NSLog(@"%s: %@", #obj, [(obj) description])
//做标记日志
#define MARK NSLog(@"\nMARK: %s, %d", __PRETTY_FUNCTION__, __LINE__)

//单实例宏定义--------------start
///@interface
#define Singleton_Interface(className) \
+ (className *)shared##className;

///@implementation
#define Singleton_implementation(className) \
+ (instancetype)shared##className \
{ \
static dispatch_once_t onceToken; \
static id instance = nil; \
dispatch_once(&onceToken, ^{ \
instance = [[className alloc] init]; \
});  \
return instance; \
}
//单实例宏定义--------------end

//创建Model宏定义--------------start
///@interface
#define Model_Interface(className) \
+ (instancetype)model;

///@implementation
#define Model_Implementation(className) \
+ (instancetype)model \
{ \
__autoreleasing className *model = [[className alloc] init]; \
return model; \
}

//block中使用 weak 属性
#define LL_WEAK_OBJC(type)  __weak typeof(type) weak##type = type


#define     NSNotificationCenterGetCity         @"NSNotificationCenterGetCity"          //!< 获取到显示城市
#define     NSNotificationCenterGetWeather      @"NSNotificationCenterGetWeather"       //!< 获取到天气
#define     NSNotificationCenterRefreshCityData         @"NSNotificationCenterRefreshCityData"          //!< 获取到显示城市
#define     NSNotificationCenterCurrentCityChanged           @"NSNotificationCenterCurrentCityChanged"          //!< 获取到显示城市


//
// 获取重用或从NIB中新建CELL，用于
//          -(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//
// [注意] : 从Table中获取指定的Cell，如果没有NIB中获取；
//
UITableViewCell* ldGetTableCellFromNib(UITableView* tableView, NSString* cellReuseId, Class cellClass, NSString* nibName);
// [切记] : reuseId必须和CELL同名
#define GET_TABLE_CELL_FROM_NIB(TABLE, CELL, NIB) ((CELL*)ldGetTableCellFromNib(TABLE, @#CELL, [CELL class], NIB))

//
// 获取重用或新建系统样式CELL，用于
//          -(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//
UITableViewCell* ldGetTableCellWithStyle(UITableView* tableView, NSString* cellReuseId, UITableViewCellStyle cellStyle);

//
// 获取同意的加载等待Cell
//
UITableViewCell* ldGetTableBusyCell(UITableView* tableView);

//
// 根据UILabel控件和字符串内容，计算控件的高度
//
BOOL ldGetHeightAndLineNumFromLabel(UILabel* label, NSString* str, float* height, int* linenum);

//
// 字符串是否为空
//
BOOL strIsNullOrEmpty(NSString* str);

NSString* strWithOutSpaceAndReturn(NSString* responseString);

//
// 如果字符串是空，则返回默认值
//
NSString* strIfNull(NSString* str, NSString* def);

//
// 如果字符串为空或者'null'，则返回默认值（改问题本该有服务端在sqlite中过滤！）
//
NSString* strIfNullDB(NSString* str, NSString* def);

//
// 手机长号
//
BOOL strIsLongTelNum(NSString* str);

// 是否是移动号码
BOOL isMobileTelNum(NSString* str);

// 是否是联通号码
BOOL isUnionComTelNum(NSString* str);

// 是否是电信号码
BOOL isTeleComTelNum(NSString* str);

//
// 显示个告警框，只有关闭按钮
//
void showSimpleAlert(NSString* title, NSString* msg);

//
// 图片加载
//
void showWebImageOnView(UIImageView* imageView, NSString* url, UIImage* placehold);

// 将图片保存为JPEG文件
typedef NS_ENUM(NSInteger, SAVE_PICTURE_TYPE) {
    SAVE_PICTURE_KEEP_SIZE,     // 保持不变
    SAVE_PICTURE_FIT_SIZE,      // 等比例拉伸，使图片完全保留
    SAVE_PICTURE_FILL_SIZE,     // 等比例拉伸，使图片填满给定的区域
    SAVE_PICTURE_STRETCH        // 拉伸以填满指定区域
};

BOOL saveJPEGPicture(UIImage* image, NSString* jpge_path, CGSize size, SAVE_PICTURE_TYPE type);

//
// 时间格式转换
//
NSDate* dateFromStrISO(NSString* date_str);
NSString* strFromDateISO(NSDate* date);

//
// 获取UUID
//
NSString* getUUID();

//
// 获取顶层的present viewcontroller
//
UIViewController* getTopPresentVC();

//
// 从url路径中抽取最后的文件名称
//
NSString* getFileNameFromURL(NSString* urlStr);

//
// 获取会议附件的URL
// 说明：附件的格式名称如下： http://ip:port/xx/xxx/00112233.pdf,orig.pdf
//    附件URL : http://ip:port/xx/xxx/00112233.pdf
//    附件原名称： orig.pdf
//
NSString* getAttachURL(NSString* url);

// 获取会议附件的原名称
NSString* getAttachOriginName(NSString* url);

// 创建排序文件名称
NSString* createSortNames(NSArray* names);

// 开始登陆状态检测，决定是否被踢下线
void runStatusCheck(int waitSec);
void runOfflineMessageCheck(int waitSec);
void runMsgReceipt();

NSString* getChatBackImageFilePath(NSString* taskId);
void setChatBackImageFilePath(NSString* taskId, NSString* imageFile);

NSString *getTypeImageName(NSString *type);

BOOL isMobileNumberClassification(NSString* content);

typedef void (^HttpSuccess)(id jsonData);

typedef void (^HttpFailure)(NSError *error);

UIImage *getNavigationBarBackImageByImage(UIImage *image);

//字典转Json字符串
NSString* convertToJSONData(id infoDict);

//JSON字符串转化为字典
NSDictionary *dictionaryWithJsonString(NSString *jsonString);

int dateNumberFromDateToToday(NSString* date_str);

bool isSignAppToday(NSString* date_str);

NSString *AssignEmptyString(NSString* str);

//正则去除网络标签
NSString *getZZwithString(NSString* string);

//iOS NSString 转换编码格式ISO-8859-1
NSString *getISO8859withString(NSString* string);
