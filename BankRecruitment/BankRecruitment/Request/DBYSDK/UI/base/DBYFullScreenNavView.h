//
//  DBYFullScreenNavView.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/13.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBYFullScreenNavView : UIView
@property(nonatomic,copy)NSString* title;

@property(nonatomic,copy)void(^clickBackButtonHandler)();
@end
