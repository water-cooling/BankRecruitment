//
//  DisplayCityManager.h
//  ScenicSpot
//
//  Created by wx on 14-11-13.
//  Copyright (c) 2014年 jdpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherModel.h"
#import "LocationManager.h"

@interface DisplayCityManager : NSObject
Singleton_Interface(DisplayCityManager)

@property (nonatomic, assign) CLLocationCoordinate2D                  coorinate;
/**
 *	@brief	当前城市
 */
@property (nonatomic, copy) NSString *curCity;

/**
 *	@brief	定位
 */
@property (nonatomic, copy) NSString *locationCity;

/**
 *	@brief	天气model
 */
@property (nonatomic, strong) WeatherModel *curWeather;

-(void)getDisplayCity;

@end
