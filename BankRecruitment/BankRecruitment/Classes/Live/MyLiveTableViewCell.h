//
//  MyLiveTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLiveTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *liveTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *livePriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveClassPlanLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveClassTeacherLabel;
@end
