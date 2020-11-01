//
//  RecruitMentShareViewController.h
//  Recruitment
//
//  Created by yltx on 2020/8/22.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecruitMentShareViewController : UIViewController
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesTitle;
@property (nonatomic, copy) NSString *shareWebUrl;
@property (nonatomic, assign)BOOL  isTabbar;
@end

NS_ASSUME_NONNULL_END
