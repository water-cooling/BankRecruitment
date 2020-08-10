//
//  UIImage+Addition.h
//  JDFramework
//
//  Created by wkx on 14-5-5.
//  Copyright (c) 2014年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

+ (UIImage *)imageWithColor: (UIColor *) color imageSize:(CGSize)imageSize;
//将图片裁剪成圆形
+ (UIImage *)circleImage:(UIImage *)image withParam:(CGFloat)inset;
//将图片裁剪成指定大小
- (UIImage *)resizedImage:(CGSize)size imageOrientation:(UIImageOrientation)imageOrientation;

//图片缩放
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

//view 转 image
+ (UIImage *)imageFromView:(UIView *)orgView;

//图片裁剪
+ (UIImage *)cutImageFromImage:(UIImage *)image inRect:(CGRect)rect;

//切图拉伸
+ (UIImage *)imageResizableWithName:(NSString *)imageName;

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

+ (UIImage *)streImageNamed:(NSString *)imageName;

//调整图片的方向
- (UIImage *)fixOrientation:(UIImage *)aImage;


@end
