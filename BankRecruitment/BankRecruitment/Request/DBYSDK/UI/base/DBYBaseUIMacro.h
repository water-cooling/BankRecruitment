//
//  DBYBaseUIMacro.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/10.
//  Copyright © 2017年 Michael. All rights reserved.
//

#ifndef DBYBaseUIMacro_h
#define DBYBaseUIMacro_h

#import "DBYUIUtils.h"

#define DBYColorFromRGBA(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define DBYColorFromHEX(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#endif /* DBYBaseUIMacro_h */
