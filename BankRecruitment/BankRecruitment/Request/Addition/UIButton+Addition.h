//
//  UIButton+Addition.h
//  JDFramework
//
//  Created by wkx on 14-5-26.
//  Copyright (c) 2014年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Addition)
#pragma mark - 图标按钮

+ (UIButton *)buttonWithFrame:(CGRect)frame
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

#pragma mark - 扩展点击区域图标按钮

//+ (UIButton *)buttonWithFrame:(CGRect)frame
//              containerFrame:(CGRect)containerFrame
//                       image:(UIImage *)image
//                 tappedImage:(UIImage *)tappedImage
//                      target:(id)target
//                      action:(SEL)selector
//                         tag:(NSInteger)tag;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                  disableIcon:(UIImage *)disableIcon
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  tappedImage:(UIImage *)tappedImage
              backgroundColor:(UIColor *)backgroundColor
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

#pragma mark - 图标+文本+背景色按钮

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        color:(UIColor *)color
                  tappedColor:(UIColor *)tappedColor
              backgroundColor:(UIColor *)backgroundColor
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                  titleInsets:(UIEdgeInsets)titleInsets
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        color:(UIColor *)color
                  tappedImage:(UIImage *)tappedImage
                  tappedColor:(UIColor *)tappedColor
              backgroundColor:(UIColor *)backgroundColor
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                  titleInsets:(UIEdgeInsets)titleInsets
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;


#pragma mark - 文本+背景图按钮

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                  tappedImage:(UIImage *)tappedImage
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                  tappedImage:(UIImage *)tappedImage
                selectedImage:(UIImage *)selectedImage
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                  tappedImage:(UIImage *)tappedImage
                 disableImage:(UIImage *)disableImage
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                        color:(UIColor *)color
                  tappedImage:(UIImage *)tappedImage
                  tappedColor:(UIColor *)tappedColor
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                        color:(UIColor *)color
                  tappedImage:(UIImage *)tappedImage
                  tappedColor:(UIColor *)tappedColor
                selectedImage:(UIImage *)selectedImage
                selectedColor:(UIColor *)selectedColor
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                        color:(UIColor *)color
                  tappedImage:(UIImage *)tappedImage
                  tappedColor:(UIColor *)tappedColor
                 disableImage:(UIImage *)disableImage
                 disableColor:(UIColor *)disableColor
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                        color:(UIColor *)color
                  tappedImage:(UIImage *)tappedImage
                  tappedColor:(UIColor *)tappedColor
                selectedImage:(UIImage *)selectedImage
                selectedColor:(UIColor *)selectedColor
                 disableImage:(UIImage *)disableImage
                 disableColor:(UIColor *)disableColor
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;

#pragma mark - 纯文本按钮

+ (UIButton *)textButtonWithTitle:(NSString *)title
                           origin:(CGPoint)origin
                             font:(UIFont *)font
                            color:(UIColor *)color
                      tappedColor:(UIColor *)tappedColor
                           target:(id)target
                           action:(SEL)selector
                              tag:(NSInteger)tag;

+ (UIButton *)textButtonWithFrame:(CGRect)frame
                            title:(NSString *)title
                             font:(UIFont *)font
                            color:(UIColor *)color
                      tappedColor:(UIColor *)tappedColor
                    contentInsets:(UIEdgeInsets)titleEdgeInsets
                           target:(id)target
                           action:(SEL)selector
                              tag:(NSInteger)tag;


#pragma mark - 全能按钮
/**
 *  全能按钮
 *
 *  @param title           标题
 *  @param frame           大小
 *  @param font            字体颜色
 *  @param image           普通状态背景图片
 *  @param color           普通状态字体颜色
 *  @param tappedImage     点击状态背景图片
 *  @param tappedColor     点击状态字体颜色
 *  @param selectedImage   选中状态背景图片
 *  @param selectedColor   选中状态字体颜色
 *  @param disableImage    不可用状态背景图片
 *  @param disableColor    不可用状态字体颜色
 *  @param backgroundColor 背景颜色
 *  @param icon            普通图标
 *  @param tappedIcon      点击状态图标
 *  @param selectedIcon    选中状态图标
 *  @param disableIcon     不可用状态图标
 *  @param titleInsets     标题边距
 *  @param imageInsets     图片边距
 *  @param target          目标
 *  @param selector        事件
 *  @param tag             tag
 *
 *  @return 按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                        color:(UIColor *)color
                  tappedImage:(UIImage *)tappedImage
                  tappedColor:(UIColor *)tappedColor
                selectedImage:(UIImage *)selectedImage
                selectedColor:(UIColor *)selectedColor
                 disableImage:(UIImage *)disableImage
                 disableColor:(UIColor *)disableColor
              backgroundColor:(UIColor *)backgroundColor
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                 selectedIcon:(UIImage *)selectedIcon
                  disableIcon:(UIImage *)disableIcon
                  titleInsets:(UIEdgeInsets)titleInsets
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;
@end
