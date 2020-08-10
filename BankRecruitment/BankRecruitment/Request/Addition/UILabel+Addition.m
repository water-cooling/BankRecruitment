//
//  UILabel+Addition.m
//  JDFramework
//
//  Created by wkx on 14-5-26.
//  Copyright (c) 2014年 JD. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       font:(UIFont *)font
                  textColor:(UIColor *)textcolor
{
    __autoreleasing UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = textcolor;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

+ (UILabel *)labelWithFrame:(CGRect)rect text:(NSString *)text font:(UIFont *)font
{
    __autoreleasing UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font origin:(CGPoint)origin
{
    CGSize size = [text sizeWithFont:font];
    
    __autoreleasing UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){origin, size}];
    label.text = text;
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.backgroundColor =  [UIColor clearColor];
    
    return label;
}

@end
