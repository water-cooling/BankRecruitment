//
//  InformationModel.h
//  Recruitment
//
//  Created by 夏建清 on 2018/6/9.
//  Copyright © 2018年 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *TypeName;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Screen;
@property (nonatomic, copy) NSString *PCScreen;
@property (nonatomic, copy) NSString *Info;
@property (nonatomic, copy) NSString *CreateDate;

+ (instancetype)model;
- (void)setDataWithDic:(NSDictionary *)dic;
@end
