//
//  WeatherModel.m
//  CBWallet4iPhone
//
//  Created by 秦会文 on 14-8-7.
//  Copyright (c) 2014年 qhwlord. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.curTemp                               forKey:@"curTemp"];
    [aCoder encodeObject:self.curWindDirection                      forKey:@"curWindDirection"];
    [aCoder encodeObject:self.curWindStrength                       forKey:@"curWindStrength"];
    [aCoder encodeObject:self.curHumidity                           forKey:@"curHumidity"];
    [aCoder encodeObject:self.updateTime                            forKey:@"updateTime"];
    
    
    [aCoder encodeObject:self.todayCity                             forKey:@"todayCity"];
    [aCoder encodeObject:self.todayDate                             forKey:@"todayDate"];
    [aCoder encodeObject:self.todayWeek                             forKey:@"todayWeek"];
    [aCoder encodeObject:self.todayTemp                             forKey:@"todayTemp"];
    [aCoder encodeObject:self.todayWeather                          forKey:@"todayWeather"];
    [aCoder encodeObject:self.todayWind                             forKey:@"todayWind"];
    
    [aCoder encodeObject:self.fa                                    forKey:@"fa"];
    [aCoder encodeObject:self.fb                                    forKey:@"fb"];
    
    [aCoder encodeObject:self.dayWeek                               forKey:@"dayWeek"];
    [aCoder encodeObject:self.dayHighTemp                           forKey:@"dayHighTemp"];
    [aCoder encodeObject:self.dayLowTemp                            forKey:@"dayLowTemp"];
    [aCoder encodeObject:self.dayFa                                 forKey:@"dayFa"];
    [aCoder encodeObject:self.dayFb                                 forKey:@"dayFb"];
    [aCoder encodeObject:self.dayWeather                            forKey:@"dayWeather"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.curTemp                            = [aDecoder decodeObjectForKey:@"curTemp"];
        self.curWindDirection                   = [aDecoder decodeObjectForKey:@"curWindDirection"];
        self.curWindStrength                    = [aDecoder decodeObjectForKey:@"curWindStrength"];
        self.curHumidity                        = [aDecoder decodeObjectForKey:@"curHumidity"];
        self.updateTime                         = [aDecoder decodeObjectForKey:@"updateTime"];
        
        self.todayCity                          = [aDecoder decodeObjectForKey:@"todayCity"];
        self.todayDate                          = [aDecoder decodeObjectForKey:@"todayDate"];
        self.todayWeek                          = [aDecoder decodeObjectForKey:@"todayWeek"];
        self.todayTemp                          = [aDecoder decodeObjectForKey:@"todayTemp"];
        self.todayWeather                       = [aDecoder decodeObjectForKey:@"todayWeather"];
        self.todayWind                          = [aDecoder decodeObjectForKey:@"todayWind"];
        
        self.fa                                 = [aDecoder decodeObjectForKey:@"fa"];
        self.fb                                 = [aDecoder decodeObjectForKey:@"fb"];
        
        self.dayWeek                            = [aDecoder decodeObjectForKey:@"dayWeek"];
        self.dayHighTemp                        = [aDecoder decodeObjectForKey:@"dayHighTemp"];
        self.dayLowTemp                         = [aDecoder decodeObjectForKey:@"dayLowTemp"];
        self.dayFa                              = [aDecoder decodeObjectForKey:@"dayFa"];
        self.dayFb                              = [aDecoder decodeObjectForKey:@"dayFb"];
        self.dayWeather                         = [aDecoder decodeObjectForKey:@"dayWeather"];
    }
    return self;
}

@end
