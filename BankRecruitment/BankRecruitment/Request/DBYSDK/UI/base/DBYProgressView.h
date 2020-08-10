//
//  DBYProgressView.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 2017/4/25.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBYProgressView : UIView
@property(nonatomic,copy)void(^beginPanHandler)(float progress);//开始滑动
@property(nonatomic,copy)void(^paningHandler)(float progress);//滑动中
@property(nonatomic,copy)void(^endPanHandler)(float progress);//停止滑动

-(void)setProgressWith:(float)progress;
-(float)progress;
@end
