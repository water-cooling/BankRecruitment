//
//  LocationManager.h
//  ScenicSpot
//
//  Created by wkx on 14-11-5.
//  Copyright (c) 2014年 jdpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject{
    NSString * _currentCity;
}
Singleton_Interface(LocationManager)

/**
 *	@brief	获取当前GPS信息
 *  
 *  @param  curLocation  经纬度信息
 *          curCity      城市
 *
 *  @param  error        错误信息
 *
 */
- (void)getLocationInfo:(void (^)(CLLocationCoordinate2D curCoordinate))coordinateBlock
                   city:(void (^)(NSString *curCity))cityBlock
                failure:(void (^)(NSError *error,NSString *curCity))failureBlock;

-(void)setCurrentCity:(NSString *)city;

-(NSString *)getCurrentCity;


@end
