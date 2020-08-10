//
//  WeatherModel.h
//  CBWallet4iPhone
//
//  Created by 秦会文 on 14-8-7.
//  Copyright (c) 2014年 qhwlord. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

/*当前实况天气*/
@property (nonatomic,copy) NSString *curWeather;             //!<当前天气
@property (nonatomic,copy) NSString *curTemp;             //!<当前温度
@property (nonatomic,copy) NSString *curWindDirection;    //!<当前风向
@property (nonatomic,copy) NSString *curWindStrength;     //!<当前风力
@property (nonatomic,copy) NSString *curHumidity;         //!<当前湿度
@property (nonatomic,copy) NSString *updateTime;             //!<更新时间

@property (nonatomic,copy) NSString *weatherImageName;     

/*今天信息*/
@property (nonatomic,copy) NSString *todayCity;           //!<城市名称
@property (nonatomic,copy) NSString *todayDate;           //!<今天日期
@property (nonatomic,copy) NSString *todayWeek;           //!<今天星期
@property (nonatomic,copy) NSString *todayTemp;           //!<今天温度范围
@property (nonatomic,copy) NSString *todayWeather;        //!<今天天气
@property (nonatomic,copy) NSString *todayWind;           //!<今天风

@property (nonatomic,copy) NSString *fa;           //!<天气code1
@property (nonatomic,copy) NSString *fb;           //!<天气code2

/*未来几天 天气信息*/
@property (nonatomic,copy) NSString *dayWeek;           //!<当天 星期
@property (nonatomic,copy) NSString *dayHighTemp;       //!<当天 最高气温
@property (nonatomic,copy) NSString *dayLowTemp;        //!<当天 最低气温
@property (nonatomic,copy) NSString *dayFa;             //!<当天 天气code1
@property (nonatomic,copy) NSString *dayFb;             //!<当天 天气code2
@property (nonatomic,copy) NSString *dayWeather;        //!<当天 天气



@end
