//
//  DBYAnimateImageView.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 2017/5/2.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYAnimateImageView.h"

@interface DBYAnimateImageView ()
@property(nonatomic,strong)NSTimer*timer;

@property(nonatomic,assign)NSInteger imageIndex;
@end
@implementation DBYAnimateImageView
#pragma mark - life cycle
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _animateDuration = 0.1;
        self.imageIndex = 0;
        self.contentMode = UIViewContentModeCenter;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_animateDuration target:self selector:@selector(updateImage:) userInfo:nil repeats:YES];
    }
    return self;
}
-(void)dealloc
{
    
}
#pragma mark - public methods
-(void)start
{
    if (self.timer) {
        [self.timer setFireDate:[NSDate date]];
    }
}
-(void)stop
{
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}
-(void)clear
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark - timer methods
-(void)updateImage:(NSTimer*)timer
{
    if (self.imageIndex + 1 >= self.images.count) {
        return;
    }
    
    UIImage*image = [self.images objectAtIndex:self.imageIndex+1];
    self.imageIndex ++;
    self.image = image;
    
    if (self.imageIndex == self.images.count - 1) {
        self.imageIndex = 0;
    }
    
}
#pragma mark - setter
-(void)setAnimateDuration:(NSTimeInterval)animateDuration
{
    _animateDuration = animateDuration;
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:animateDuration target:self selector:@selector(updateImage:) userInfo:nil repeats:YES];
    
    
}
#pragma mark - 懒加载
-(NSMutableArray<UIImage *> *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}
@end
