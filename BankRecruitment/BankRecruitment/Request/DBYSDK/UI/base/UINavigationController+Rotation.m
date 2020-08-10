//
//  UINavigationController+Rotation.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/2/10.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "UINavigationController+Rotation.h"

@implementation UINavigationController (Rotation)
- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
