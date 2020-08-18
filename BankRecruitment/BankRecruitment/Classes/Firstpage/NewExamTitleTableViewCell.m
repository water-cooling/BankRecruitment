//
//  ExamTitleTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/8.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "NewExamTitleTableViewCell.h"

@implementation NewExamTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
