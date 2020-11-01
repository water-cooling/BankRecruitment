//
//  UIImage+CircleImage.h
//  Recruitment
//
//  Created by humengfan on 2020/10/30.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CircleImage)
- (UIImage *)circleImage;
+(NSData*)getDataFromImage:(UIImage*)image;
@end

NS_ASSUME_NONNULL_END
