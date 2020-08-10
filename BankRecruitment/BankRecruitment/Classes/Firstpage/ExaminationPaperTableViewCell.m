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
    
    self.ExaminationPaperTitleLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:17];
    self.ExaminationPaperPriceLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:18];
    self.ExaminationPaperClassPlanLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:14];
    self.ExaminationPaperBuyNumberLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:11];
    self.ExaminationPaperLimitTimeLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:11];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
