//
//  DBYUIUtils.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/10.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYUIUtils.h"

#include <sys/param.h>
#include <sys/mount.h>


@implementation DBYUIUtils

#pragma mark - color to image
+ (UIImage*)createImageWithColor:(UIColor*)color
{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    return theImage;
    
}

+(UIImage*)bundleImageWithImageName:(NSString*)name
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"DBYSDKResource.bundle/%@",name]];
}

+ (NSString *) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"手机剩余存储空间为：%qi MB" ,freespace/1024/1024];
}
@end
