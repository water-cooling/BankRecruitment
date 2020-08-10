//
//  UIButton+Addition.m
//  JDFramework
//
//  Created by wkx on 14-5-26.
//  Copyright (c) 2014年 JD. All rights reserved.
//

#import "UIButton+Addition.h"

@implementation UIButton (Addition)
+ (UIButton *)buttonWithFrame:(CGRect)frame
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:nil
                               frame:frame
                                font:nil
                               image:nil
                               color:nil
                         tappedImage:nil
                         tappedColor:nil
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:[UIColor clearColor]
                                icon:icon
                          tappedIcon:tappedIcon
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:UIEdgeInsetsZero
                              target:target
                              action:selector
                                 tag:tag];
}

#pragma mark - 扩展点击区域图标按钮

//+ (UIButton *)buttonWithFrame:(CGRect)frame
//               containerFrame:(CGRect)containerFrame
//                        image:(UIImage *)image
//                  tappedImage:(UIImage *)tappedImage
//                       target:(id)target
//                       action:(SEL)selector
//                          tag:(NSInteger)tag
//{
//    UIButton *container = [UIButton buttonWithFrame:containerFrame
//                                               icon:nil
//                                         tappedIcon:nil
//                                             target:target
//                                             action:selector
//                                                tag:tag];
//
//    UIButton *button = [UIButton buttonWithFrame:frame
//                                            icon:image
//                                      tappedIcon:tappedImage
//                                          target:target
//                                          action:selector
//                                             tag:tag];
//
//    [container addSubview:button];
//
//    return container;
//}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:nil
                               frame:frame
                                font:nil
                               image:nil
                               color:nil
                         tappedImage:nil
                         tappedColor:nil
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:[UIColor clearColor]
                                icon:icon
                          tappedIcon:tappedIcon
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:imageInsets
                              target:target
                              action:selector
                                 tag:tag];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                  disableIcon:(UIImage *)disableIcon
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:nil
                               frame:frame
                                font:nil
                               image:nil
                               color:nil
                         tappedImage:nil
                         tappedColor:nil
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:[UIColor clearColor]
                                icon:icon
                          tappedIcon:tappedIcon
                        selectedIcon:nil
                         disableIcon:disableIcon
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:imageInsets
                              target:target
                              action:selector
                                 tag:tag];
}

//+ (UIButton *)buttonWithFrame:(CGRect)frame
//                         icon:(UIImage *)icon
//                   tappedIcon:(UIImage *)tappedIcon
//                  disableIcon:(UIImage *)disableIcon
//                  imageInsets:(UIEdgeInsets)imageInsets
//                       target:(id)target
//                       action:(SEL)selector
//                          tag:(NSInteger)tag
//{
//    return [UIButton buttonWithTitle:nil
//                               frame:frame
//                                font:nil
//                               image:nil
//                               color:nil
//                         tappedImage:nil
//                         tappedColor:nil
//                       selectedImage:nil
//                       selectedColor:nil
//                        disableImage:nil
//                        disableColor:nil
//                     backgroundColor:[UIColor clearColor]
//                                icon:icon
//                          tappedIcon:tappedIcon
//                         titleInsets:UIEdgeInsetsZero
//                         imageInsets:imageInsets
//                              target:target
//                              action:selector
//                                 tag:tag];
//}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                  tappedImage:(UIImage *)tappedImage
              backgroundColor:(UIColor *)backgroundColor
                         icon:(UIImage *)icon
                   tappedIcon:(UIImage *)tappedIcon
                  imageInsets:(UIEdgeInsets)imageInsets
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:nil
                               frame:frame
                                font:nil
                               image:nil
                               color:nil
                         tappedImage:tappedImage
                         tappedColor:nil
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:backgroundColor
                                icon:icon
                          tappedIcon:tappedIcon
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:imageInsets
                              target:target
                              action:selector
                                 tag:tag];
}

#pragma mark - 文本+图标按钮

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
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:nil
                               color:color
                         tappedImage:nil
                         tappedColor:tappedColor
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:backgroundColor
                                icon:icon
                          tappedIcon:tappedIcon
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:titleInsets
                         imageInsets:imageInsets
                              target:target
                              action:selector
                                 tag:tag];
}

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
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:nil
                               color:color
                         tappedImage:tappedImage
                         tappedColor:tappedColor
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:backgroundColor
                                icon:icon
                          tappedIcon:tappedIcon
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:titleInsets
                         imageInsets:imageInsets
                              target:target
                              action:selector
                                 tag:tag];
}

#pragma mark - 文本+背景图按钮

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                  tappedImage:(UIImage *)tappedImage
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:image
                               color:[UIColor blackColor]
                         tappedImage:tappedImage
                         tappedColor:[UIColor blackColor]
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:[UIColor clearColor]
                                icon:nil
                          tappedIcon:nil
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:UIEdgeInsetsZero
                              target:target
                              action:selector
                                 tag:tag];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                  tappedImage:(UIImage *)tappedImage
                selectedImage:(UIImage *)selectedImage
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:image
                               color:[UIColor blackColor]
                         tappedImage:tappedImage
                         tappedColor:[UIColor blackColor]
                       selectedImage:selectedImage
                       selectedColor:[UIColor blackColor]
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:[UIColor clearColor]
                                icon:nil
                          tappedIcon:nil
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:UIEdgeInsetsZero
                              target:target
                              action:selector
                                 tag:tag];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                  tappedImage:(UIImage *)tappedImage
                 disableImage:(UIImage *)disableImage
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:image
                               color:[UIColor blackColor]
                         tappedImage:tappedImage
                         tappedColor:[UIColor blackColor]
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:disableImage
                        disableColor:[UIColor blackColor]
                     backgroundColor:[UIColor clearColor]
                                icon:nil
                          tappedIcon:nil
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:UIEdgeInsetsZero
                              target:target
                              action:selector
                                 tag:tag];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                         font:(UIFont *)font
                        image:(UIImage *)image
                        color:(UIColor *)color
                  tappedImage:(UIImage *)tappedImage
                  tappedColor:(UIColor *)tappedColor
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:image
                               color:color
                         tappedImage:tappedImage
                         tappedColor:tappedColor
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:[UIColor clearColor]
                                icon:nil
                          tappedIcon:nil
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:UIEdgeInsetsZero
                              target:target
                              action:selector
                                 tag:tag];
}

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
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:image
                               color:color
                         tappedImage:tappedImage
                         tappedColor:tappedColor
                       selectedImage:selectedImage
                       selectedColor:selectedColor
                        disableImage:nil
                        disableColor:nil
                     backgroundColor:[UIColor clearColor]
                                icon:nil
                          tappedIcon:nil
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:UIEdgeInsetsZero
                              target:target
                              action:selector
                                 tag:tag];
}

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
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:image
                               color:color
                         tappedImage:tappedImage
                         tappedColor:tappedColor
                       selectedImage:nil
                       selectedColor:nil
                        disableImage:disableImage
                        disableColor:disableColor
                     backgroundColor:[UIColor clearColor]
                                icon:nil
                          tappedIcon:nil
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:UIEdgeInsetsZero
                              target:target
                              action:selector
                                 tag:tag];
}

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
                          tag:(NSInteger)tag
{
    return [UIButton buttonWithTitle:title
                               frame:frame
                                font:font
                               image:image
                               color:color
                         tappedImage:tappedImage
                         tappedColor:tappedColor
                       selectedImage:selectedImage
                       selectedColor:selectedColor
                        disableImage:disableImage
                        disableColor:disableColor
                     backgroundColor:[UIColor clearColor]
                                icon:nil
                          tappedIcon:nil
                        selectedIcon:nil
                         disableIcon:nil
                         titleInsets:UIEdgeInsetsZero
                         imageInsets:UIEdgeInsetsZero
                              target:target
                              action:selector
                                 tag:tag];
}


#pragma mark - 纯文本按钮

+ (UIButton *)textButtonWithTitle:(NSString *)title
                           origin:(CGPoint)origin
                             font:(UIFont *)font
                            color:(UIColor *)color
                      tappedColor:(UIColor *)tappedColor
                           target:(id)target
                           action:(SEL)selector
                              tag:(NSInteger)tag
{
    if (!title)
    {
        title = @"";
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = (CGRect){origin, [title sizeWithFont:font]};
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = font;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:tappedColor forState:UIControlStateHighlighted];
    button.tag = tag;
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)textButtonWithFrame:(CGRect)frame
                            title:(NSString *)title
                             font:(UIFont *)font
                            color:(UIColor *)color
                      tappedColor:(UIColor *)tappedColor
                    contentInsets:(UIEdgeInsets)titleEdgeInsets
                           target:(id)target
                           action:(SEL)selector
                              tag:(NSInteger)tag
{
    if (!title)
    {
        return nil;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat width = fmaxf(frame.size.width, [title sizeWithFont:font].width);
    button.frame = (CGRect){frame.origin, width, frame.size.height};
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = font;
    button.titleEdgeInsets = titleEdgeInsets;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:tappedColor forState:UIControlStateHighlighted];
    button.tag = tag;
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - 全能按钮
/**
 *  全能按钮
 *
 *  @param title           标题
 *  @param frame           大小
 *  @param font            字体颜色
 *  @param image           普通状态图片
 *  @param color           普通状态字体颜色
 *  @param tappedImage     点击状态图片
 *  @param tappedColor     点击状态字体颜色
 *  @param selectedImage   选中状态图片
 *  @param selectedColor   选中状态字体颜色
 *  @param disableImage    不可用状态图片
 *  @param disableColor    不可用状态字体颜色
 *  @param backgroundColor 背景颜色
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
                          tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = backgroundColor;
    
    if (title != nil && title.length > 0)
    {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = font;
    }
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    if (image)
    {
        [button setBackgroundImage:[image stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]
                          forState:UIControlStateNormal];
    }
    
    if (color)
    {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (tappedImage)
    {
        [button setBackgroundImage:[tappedImage stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]
                          forState:UIControlStateHighlighted];
    }
    
    if (tappedColor)
    {
        [button setTitleColor:tappedColor forState:UIControlStateHighlighted];
    }
    
    if (selectedImage)
    {
        [button setBackgroundImage:[selectedImage stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]
                          forState:UIControlStateSelected];
    }
    
    if (selectedColor)
    {
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    
    if (disableImage)
    {
        [button setBackgroundImage:[disableImage stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f] forState:UIControlStateDisabled];
    }
    
    if (disableColor)
    {
        [button setTitleColor:disableColor forState:UIControlStateDisabled];
    }
    
    if (icon)
    {
        [button setImage:icon forState:UIControlStateNormal];
    }
    
    if (tappedIcon)
    {
        [button setImage:tappedIcon forState:UIControlStateHighlighted];
    }
    
    if (selectedIcon)
    {
        [button setImage:selectedIcon forState:UIControlStateSelected];
    }
    
    if (disableIcon)
    {
        [button setImage:disableIcon forState:UIControlStateDisabled];
    }
    
    if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, imageInsets))
    {
        button.imageEdgeInsets = imageInsets;
    }
    
    if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, titleInsets))
    {
        button.titleEdgeInsets = titleInsets;
    }
    
    return button;
}

@end
