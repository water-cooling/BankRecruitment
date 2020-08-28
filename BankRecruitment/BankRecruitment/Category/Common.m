//
//  Common.m
//  HealthCloud
//
//  Created by lihaibo on 15/10/26.
//  Copyright © 2015年 bomei. All rights reserved.
//

#include <sys/sysctl.h>
#import <AdSupport/AdSupport.h>
static NSString *const kAppVersion = @"appVersion";
@implementation Common

+ (void)popUrl:(NSString *)url
    withTarget:(UIViewController *)target
{
    NSArray *arr = target.navigationController.viewControllers;
    for (UIViewController *view in arr) {
        if ([view isKindOfClass:NSClassFromString(url)]) {
            //            [view transferParameters:paramers];
            [target.navigationController popToViewController:view animated:YES];
        }
    }
}


@end
