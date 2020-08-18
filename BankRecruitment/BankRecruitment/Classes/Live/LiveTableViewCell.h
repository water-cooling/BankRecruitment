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
@property (nonatomic, strong) IBOutlet UILabel *liveClassPlanLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveBuyNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (weak, nonatomic) IBOutlet UILabel *classTImeLab;

@end
