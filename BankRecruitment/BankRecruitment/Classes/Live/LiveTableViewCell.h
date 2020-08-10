//
//  LiveTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *liveTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *livePriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveClassPlanLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveClassTeacherLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveBuyNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveLimitTimeLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *priceConstraint;

@end
