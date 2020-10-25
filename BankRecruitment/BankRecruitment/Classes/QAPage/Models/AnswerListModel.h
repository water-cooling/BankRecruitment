//
//  AnswerList.h
//  Recruitment
//
//  Created by humengfan on 2020/10/24.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnswerListModel : NSObject
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *answerContent;
@property (nonatomic, strong) NSString *answerUserAvatar;
@property (nonatomic, strong) NSString *answerUserNickName;
@property (nonatomic, strong) NSString *answerId;
@property (nonatomic, assign) BOOL isCanDel;
@property (nonatomic, assign) BOOL isPraised;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *ykQuestionId;
@property (nonatomic, assign) NSInteger Cellheight;
@end

NS_ASSUME_NONNULL_END
