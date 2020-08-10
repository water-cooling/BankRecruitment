//
//  DBYAnimateImageView.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 2017/5/2.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBYAnimateImageView : UIImageView
//切换图片时间间隔 默认0.1
@property(nonatomic,assign)NSTimeInterval animateDuration;
//切换图片数组
@property(nonatomic,strong)NSMutableArray<UIImage*>* images;

//开始切换图片
-(void)start;
//停止切换图片
-(void)stop;
//清除资源
-(void)clear;
@end
