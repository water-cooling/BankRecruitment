//
//  NewLoginViewController.h
//  Recruitment
//
//  Created by yltx on 2020/8/12.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^LoginSuccessBlock)();

@interface LoginViewController : UIViewController
@property (nonatomic, copy) LoginSuccessBlock loginSuccessBlock;
- (void)saveAutoLoginMes;

@end

NS_ASSUME_NONNULL_END
