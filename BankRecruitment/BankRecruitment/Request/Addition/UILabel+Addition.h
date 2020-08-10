//
//  UILabel+Addition.h
//  JDFramework
//
//  Created by wkx on 14-5-26.
//  Copyright (c) 2014年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Addition)

/**
 *	@brief	创建UILabel
 *
 *	@param 	frame       大小
 *	@param 	font        字体
 *	@param 	textcolor 	文字颜色
 *
 *	@return	UILabel
 */
+ (UILabel *)labelWithFrame:(CGRect)frame
                       font:(UIFont *)font
                  textColor:(UIColor *)textcolor;


/**
 *  创建UILabel
 *
 *  @param rect 大小
 *  @param text 文本
 *  @param font 字体
 *
 *  @return UILabel
 */
+ (UILabel *)labelWithFrame:(CGRect)rect text:(NSString *)text font:(UIFont *)font;

/**
 *  创建UILabel, Label大小自动适应文本大小
 *
 *  @param text 文本
 *  @param font 字体
 *  @param origin    起始位置
 *
 *  @return UILabel
 */
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font origin:(CGPoint)origin;

@end
