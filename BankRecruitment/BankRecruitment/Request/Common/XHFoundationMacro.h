//
//  XHFoundationMacro.h
//  Xile
//
//  Created by linus on 15/7/30.
//  Copyright (c) 2017年 ZTE. All rights reserved.
//

#ifndef Xile_XHFoundationMacro_h
#define Xile_XHFoundationMacro_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// iPad
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// image STRETCH
#define XH_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

#define MDK_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define MDK_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#endif
