//
//  InviteJobModel.h
//  Recruitment
//
//  Created by humengfan on 2020/8/30.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteJobModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *h5Url;
- (void)setDataWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
