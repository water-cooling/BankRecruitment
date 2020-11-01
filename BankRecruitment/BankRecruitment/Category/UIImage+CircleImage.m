//
//  UIImage+CircleImage.m
//  Recruitment
//
//  Created by humengfan on 2020/10/30.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "UIImage+CircleImage.h"

@implementation UIImage (CircleImage)
- (UIImage *)circleImage{
UIGraphicsBeginImageContext(self.size);
CGContextRef ctx = UIGraphicsGetCurrentContext();
CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
CGContextAddEllipseInRect(ctx, rect);
CGContextClip(ctx);
[self drawInRect:rect];
UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
return image;
}

+(NSData*)getDataFromImage:(UIImage*)image{
    NSData *data;
/*判断图片是不是png格式的文件*/
    if(UIImagePNGRepresentation(image)){
        data = UIImagePNGRepresentation(image);
    /*判断图片是不是jpeg格式的文件*/
    }else{
        data = UIImageJPEGRepresentation(image,1.0);
    }
    return data;
}


@end
