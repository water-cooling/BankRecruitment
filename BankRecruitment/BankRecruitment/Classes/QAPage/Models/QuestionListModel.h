//
//  QuestionListModel.h
//  Recruitment
//
//  Created by humengfan on 2020/10/23.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionListModel : NSObject
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, assign) NSInteger answerNum;
@property (nonatomic, assign) NSInteger viewNum;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) NSString *questionCatCode;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userNickName;
@property (nonatomic, strong) NSString *questionCatCodeName;
@property (nonatomic, assign) NSInteger Cellheight;
@end

NS_ASSUME_NONNULL_END
