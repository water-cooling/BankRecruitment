//
//  ConstHeader.h
//  JDFramework
//
//  Created by wkx on 14-5-4.
//  Copyright (c) 2014年 JD. All rights reserved.
//

#ifndef JDFramework_ConstHeader_h
#define JDFramework_ConstHeader_h


#pragma mark--常用define
//判断是否是IOS7以上系统
#define IS_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)
#define IS_IOS8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8)
//判断是否是各个尺寸英寸的屏幕
#define IS_Iphone4 fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)480 ) < DBL_EPSILON
#define IS_Iphone5 fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON
#define IS_Iphone6 fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)667 ) < DBL_EPSILON
#define IS_Iphone6Plus fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)736 ) < DBL_EPSILON
//获取屏幕宽和高
#define Screen_Width CGRectGetWidth([[UIScreen mainScreen] bounds])
#define Screen_Height CGRectGetHeight([[UIScreen mainScreen] bounds])
//导航栏高度
#define NavigationBar_Height        44
//底部bar高度
#define TABBAR_HEIGHT               46
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
//App主Delegate
#define appDelegate          ((AppDelegate *)[[UIApplication sharedApplication] delegate])
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
//创建Model宏定义--------------end

#endif
