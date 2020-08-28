//  //   Common.h
//   HealthCloud
//  //   Created by lihaibo on 15/10/26.
//   Copyright © 2015年 bomei. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^block)(void);

@interface Common : NSObject
/**
 *  处理页面返回
 *
 */
+ (void)popUrl:(NSString *)url
    withTarget:(UIViewController *)target;

@end
