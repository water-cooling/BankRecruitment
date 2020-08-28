//
//  MyCourseTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/10.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCourseTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *liveTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveClassPlanLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTImeLab;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@end
