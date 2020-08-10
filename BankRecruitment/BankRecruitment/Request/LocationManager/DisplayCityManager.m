//
//  DisplayCityManager.m
//  ScenicSpot
//
//  Created by wx on 14-11-13.
//  Copyright (c) 2014年 jdpay. All rights reserved.
//

#import "DisplayCityManager.h"

//key 天气
#define WEATHER_KEY @"d3c638c4e64f4ca1b087992516e94770"

@interface DisplayCityManager()
{
    NSString                                *_tempCity;
}
@end

@implementation DisplayCityManager
Singleton_implementation(DisplayCityManager)


#pragma mark - Public Method
-(void)getDisplayCity{
    self.curCity = @"未知";
    [self getLocation];
}

#pragma mark - HTTPRequest

-(void)getLocation{
    LocationManager *cityLocation = [LocationManager sharedLocationManager];
    [cityLocation getLocationInfo:^(CLLocationCoordinate2D curCoordinate)
     {
         self.coorinate = curCoordinate;
     }
                             city:^(NSString *curCity) {
                                 [self getWeatherInfoWithCityName:curCity];
                                 _tempCity = curCity;
                                 _locationCity = curCity;
                                 [NotificationCenter postNotificationName:NSNotificationCenterGetCity object:nil];
                             }
                          failure:^(NSError *error,NSString *curCity) {
                              _tempCity = curCity;
                              _locationCity = curCity;
//                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"定位失败，请开启定位:设置 > 隐私 > 位置 > 定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                              [alert show];
                          }];
}

//"now": { //实况天气
//    "cond": { //天气状况
//        "code": "100",  //天气状况代码
//        "txt": "晴" //天气状况描述
//    },
//    "fl": "30",  //体感温度
//    "hum": "20%",  //相对湿度（%）
//    "pcpn": "0.0",  //降水量（mm）
//    "pres": "1001",  //气压
//    "tmp": "32",  //温度
//    "vis": "10",  //能见度（km）
//    "wind": { //风力风向
//        "deg": "10",  //风向（360度）
//        "dir": "北风",  //风向
//        "sc": "3级",  //风力
//        "spd": "15" //风速（kmph）
//    }
//},
- (void)getWeatherInfoWithCityName:(NSString *)city
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.heweather.com/x3/weather?city=%@&key=%@",city,WEATHER_KEY];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1000];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError || !response || !data) {
            
            return ;
        }
        if ( [(NSHTTPURLResponse *) response statusCode] == 200 && data) {
            NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"result ======  %@",result);
            NSArray *HeWeather = result[@"HeWeather data service 3.0"];
            if(HeWeather.count==0)
            {
                return;
            }
            NSDictionary *weatherDict = HeWeather.firstObject;
            if ([EncodeFromDic(weatherDict, @"status") isEqualToString:@"ok"]) {
                //解析数据
                
                WeatherModel *model = [[WeatherModel alloc] init];
                NSDictionary *curDic = [weatherDict objectForKey:@"now"];
                
                model.curTemp = [curDic objectForKey:@"tmp"];
                
                NSDictionary *cond = [curDic objectForKey:@"cond"];
                model.curWeather = [cond objectForKey:@"txt"];
                
                NSDictionary *wind = [curDic objectForKey:@"wind"];
                model.curWindDirection = [wind objectForKey:@"dir"];
                model.curWindStrength = [wind objectForKey:@"sc"];
                
                model.curHumidity = [curDic objectForKey:@"fl"];
                
                NSDictionary *basic = [weatherDict objectForKey:@"basic"];
                NSDictionary *update = [basic objectForKey:@"update"];
                model.updateTime = [update objectForKey:@"loc"];
                
                model.weatherImageName = [self getWeatherImageNameBy:_locationCity];
                
//                NSDictionary *todayDic = [resultDic objectForKey:@"today"];
//                
//                model.todayCity = [todayDic objectForKey:@"city"];
//                model.todayDate = [todayDic objectForKey:@"date_y"];
//                model.todayWeek = [todayDic objectForKey:@"week"];
//                model.todayTemp = [todayDic objectForKey:@"temperature"];
//                model.todayWeather = [todayDic objectForKey:@"weather"];
//                
//                NSDictionary *weatherIdDic = [todayDic objectForKey:@"weather_id"];
//                model.fa = [weatherIdDic objectForKey:@"fa"];
//                model.fb = [weatherIdDic objectForKey:@"fb"];
//                //当天最高  最低气温
//                NSArray *futureArray = [resultDic objectForKey:@"future"];
//                NSString *temp = [[futureArray objectAtIndex:0] objectForKey:@"temperature"];
//                NSArray  *tmpArray= [temp componentsSeparatedByString:@"~"];
//                
//                NSString *strDayHighTemp= [tmpArray objectAtIndex:1];
//                model.dayHighTemp = [strDayHighTemp substringToIndex:strDayHighTemp.length-1];
//                
//                NSString *strDayLowTemp= [tmpArray objectAtIndex:0];
//                model.dayLowTemp = [strDayLowTemp substringToIndex:strDayLowTemp.length-1];
//                
//                NSLog(@"当前温度===》%@",model.curTemp);
//                NSLog(@"当前天气===》%@",model.todayWeather);
//                //组合天气按转后天气算
//                NSLog(@"天气编码===》%@",model.fb);
//                NSLog(@"温度范围===》%@",[NSString stringWithFormat:@"%@/%@°",model.dayHighTemp,model.dayLowTemp]);
                self.curWeather = model;
                [NotificationCenter postNotificationName:NSNotificationCenterGetWeather object:nil];
            }
        }else{//错误时刷新数据
            
        }
    }];
}

- (NSString *)getWeatherImageNameBy:(NSString *)weather
{
    if([weather isEqualToString:@"晴"])
    {
        return @"qing.png";
    }
    else if ([weather isEqualToString:@"多云"])
    {
        return @"qingzhuanduoyun.png";
    }
    else if ([weather isEqualToString:@"少云"])
    {
        return @"qingzhuanduoyun.png";
    }
    else if ([weather isEqualToString:@"晴间多云"])
    {
        return @"qingzhuanduoyun.png";
    }
    else if ([weather isEqualToString:@"阴"])
    {
        return @"yin.png";
    }
    else if ([weather isEqualToString:@"阵雨"])
    {
        return @"zhongyu.png";
    }
    else if ([weather isEqualToString:@"强阵雨"])
    {
        return @"zhongyu.png";
    }
    else if ([weather isEqualToString:@"雷阵雨"])
    {
        return @"bingbao.png";
    }
    else if ([weather isEqualToString:@"强雷阵雨"])
    {
        return @"bingbao.png";
    }
    else if ([weather isEqualToString:@"雷阵雨伴有冰雹"])
    {
        return @"bingbao.png";
    }
    else if ([weather isEqualToString:@"小雨"])
    {
        return @"yu.png";
    }
    else if ([weather isEqualToString:@"中雨"])
    {
        return @"zhongyu.png";
    }
    else if ([weather isEqualToString:@"大雨"])
    {
        return @"dayu.png";
    }
    else if ([weather hasSuffix:@"暴雨"])
    {
        return @"baoyu.png";
    }
    else if ([weather isEqualToString:@"中雪"])
    {
        return @"zhongxue.png";
    }
    else if ([weather isEqualToString:@"大雪"])
    {
        return @"daxue.png";
    }
    else if ([weather hasSuffix:@"雪"])
    {
        return @"xiaoxue.png";
    }
    else if ([weather hasSuffix:@"雾"])
    {
        return @"wu.png";
    }
    else if ([weather hasSuffix:@"雨"])
    {
        return @"yu.png";
    }
    else
    {
        return @"qingzhuanduoyun.png";
    }
}

@end
