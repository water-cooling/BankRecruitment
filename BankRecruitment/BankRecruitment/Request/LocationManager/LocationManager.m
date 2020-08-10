//
//  LocationManager.m
//  ScenicSpot
//
//  Created by wkx on 14-11-5.
//  Copyright (c) 2014年 jdpay. All rights reserved.
//

#import "LocationManager.h"
#import "ChinaMapShift.h"

typedef NS_ENUM(NSUInteger, LocationError) {
    kLocationErrorNotOpen,          //!< 定位未打开
    kLocationErrorDenied,           //!< 定位被用户拒绝
    kLocationErrorUnknown           //!< 未知错误
};

NSString *locateMoonCity = @"月球";

@interface LocationManager()<CLLocationManagerDelegate>
{
    CLLocationManager           *_locationManager;          //!< 位置管理
    CLLocationCoordinate2D       _currentCoordinate;        //!< 经纬度
}

@property (nonatomic, copy) void (^coordinateBlock)() ;

@property (nonatomic, copy) void (^cityBlock)() ;

@property (nonatomic, copy) void (^failureBlock)() ;

@end


@implementation LocationManager
Singleton_implementation(LocationManager)

-(void)setCurrentCity:(NSString *)city{
    _currentCity = city;
}

-(NSString *)getCurrentCity{
    return _currentCity;
}

#pragma mark - Pubilc Method
- (void)getLocationInfo:(void (^)(CLLocationCoordinate2D curCoordinate))coordinateBlock
                   city:(void (^)(NSString *curCity))cityBlock
                failure:(void (^)(NSError *error,NSString *curCity))failureBlock
{
    self.coordinateBlock = coordinateBlock;
    self.cityBlock = cityBlock;
    self.failureBlock = failureBlock;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : @"用户未打开定位服务" };
        NSError *error = [[NSError alloc] initWithDomain:@"用户未打开定位服务"
                                                    code:kLocationErrorNotOpen
                                                userInfo:userInfoDict];
//        if ([[Config currentConfig].isFirstGetInApp boolValue]) {
//            self.failureBlock(error,locateMoonCity);
//            [Config currentConfig].isFirstGetInApp = @NO;
//        }
//        else{
//            NSString *str =[USER_DEFAULT objectForKey:NSUserDefaultsMoonCity];
//            if (str.length>0) {
//                self.failureBlock(error,[USER_DEFAULT objectForKey:NSUserDefaultsMoonCity]);
//            }
//            else{
//                self.failureBlock(error,locateDefaultCity);
//            }
//        }
        return;
    }
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 1;
    
    if (IS_IOS8) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

#pragma mark--CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count == 0) {
        return;
    }
    [_locationManager stopUpdatingLocation];
    CLLocation *loc = [locations objectAtIndex:0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocationCoordinate2D chinaCoordinate = [self transformFromWGSToGCJ:loc.coordinate];
    CLLocation * chinaLoaction = [[CLLocation alloc] initWithLatitude:chinaCoordinate.latitude longitude:chinaCoordinate.longitude];
    
    Location oldlocation2;
    oldlocation2.lat = chinaCoordinate.latitude;
    oldlocation2.lng = chinaCoordinate.longitude;
    Location newlocation2 = bd_encrypt(oldlocation2);
    _currentCoordinate.latitude = newlocation2.lat;
    _currentCoordinate.longitude = newlocation2.lng;
    if (self.coordinateBlock != nil) {
        self.coordinateBlock(_currentCoordinate);
    }
    [geocoder reverseGeocodeLocation:chinaLoaction completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            if (placemark.locality != nil || placemark.administrativeArea != nil) {
                NSString *city = placemark.subLocality;
                if (!city) {
                    city = placemark.locality;
                }
                if (!city) {
                    city = placemark.administrativeArea;
                }
                
                if([city containsString:@"区"])
                {
                    city = placemark.locality;
                    if (!city) {
                        city = placemark.administrativeArea;
                    }
                }
                
                NSLog(@"当前城市：%@", city);
                
                //转化为BD09格式
                Location oldlocation;
                oldlocation.lat = chinaCoordinate.latitude;
                oldlocation.lng = chinaCoordinate.longitude;
                Location newlocation = bd_encrypt(oldlocation);
                _currentCoordinate.latitude = newlocation.lat;
                _currentCoordinate.longitude = newlocation.lng;
                if (self.cityBlock != nil) {
                    self.cityBlock([city copy]);
                    self.cityBlock = nil;
                }
            }
        }else{
            if (self.cityBlock != nil) {
                self.cityBlock(locateMoonCity);
                self.cityBlock = nil;
            }
        };
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
        {
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : @"用户拒绝App定位" };
            NSError *error = [[NSError alloc] initWithDomain:@"用户拒绝App定位"
                                                        code:kLocationErrorNotOpen
                                                    userInfo:userInfoDict];
//            if ([[Config currentConfig].isFirstGetInApp boolValue]) {
//                self.failureBlock(error,locateMoonCity);
//                [Config currentConfig].isFirstGetInApp = @NO;
//            }else{
//                NSString *str =[USER_DEFAULT objectForKey:NSUserDefaultsMoonCity];
//                if (str.length>0) {
//                    self.failureBlock(error,[USER_DEFAULT objectForKey:NSUserDefaultsMoonCity]);
//                }
//                else{
//                    self.failureBlock(error,locateDefaultCity);
//                }
//            }
        }
            break;
        case kCLErrorLocationUnknown:
            default:
        {
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : @"未知错误，没有获取到经纬度" };
            NSError *error = [[NSError alloc] initWithDomain:@"未知错误"
                                                        code:kLocationErrorNotOpen
                                                    userInfo:userInfoDict];
//            if ([[Config currentConfig].isFirstGetInApp boolValue]) {
//                self.failureBlock(error,locateMoonCity);
//                [Config currentConfig].isFirstGetInApp = @NO;
//            }else{
//                
//                NSString *str =[USER_DEFAULT objectForKey:NSUserDefaultsMoonCity];
//                if (str.length>0) {
//                    self.failureBlock(error,[USER_DEFAULT objectForKey:NSUserDefaultsMoonCity]);
//                }
//                else{
//                    self.failureBlock(error,locateDefaultCity);
//                }
//                
//            }
        }
            break;
    }
}

#pragma mark - Private Method
const double pi = 3.14159265358979324;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
- (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgLoc
{
    CLLocationCoordinate2D mgLoc;
    if ([self outOfChina:wgLoc])
    {
        mgLoc = wgLoc;
        return mgLoc;
    }
    double dLat =[self transformLat:wgLoc.longitude - 105.0 withLong:wgLoc.latitude - 35.0];
    double dLon =[self transformLon:wgLoc.longitude - 105.0 withLong:wgLoc.latitude - 35.0];
    double radLat = wgLoc.latitude / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    mgLoc.latitude = wgLoc.latitude + dLat;
    mgLoc.longitude = wgLoc.longitude + dLon;
    
    return mgLoc;
}

- (BOOL)outOfChina:(CLLocationCoordinate2D)wgLoc
{
    if (wgLoc.longitude < 72.004 || wgLoc.longitude > 137.8347)
        return true;
    if (wgLoc.latitude < 0.8293 || wgLoc.latitude > 55.8271)
        return true;
    return false;
}

-(CLLocationDegrees)transformLat:(CLLocationDegrees)x withLong:(CLLocationDegrees)y
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

-(CLLocationDegrees) transformLon:(CLLocationDegrees)x withLong:(CLLocationDegrees)y
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}

@end
