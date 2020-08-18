//
//  ExaminationPaperTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExaminationPaperTableViewCell.h"

@implementation ExaminationPaperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ExaminationPaperTitleLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:15];
    self.ExaminationPaperClassPlanLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:12];
    self.ExaminationPaperBuyNumberLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:12];
    self.ExaminationPaperLimitTimeLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
