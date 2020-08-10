//
//  UIViewController+SNToast.m
//  SuningEBuy
//
//  Created by xzoscar on 15/11/18.
//  Copyright © 2015年 苏宁易购. All rights reserved.
//

#import "UIViewController+SNToast.h"
#import "SNToast.h"

@implementation UIViewController (SNToast)

/*
 * toast in self.view
 * @xzoscar
 */

- (void)toast:(NSString *)toastString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SNToast toast:toastString view:self.view];
    });
}

/*
 * hide Toast
 * You do not need call this function!
 * @xzoscar
 */
- (void)hideToast {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SNToast hideToast];
    });
}

@end