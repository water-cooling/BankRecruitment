//
//  MockExamLearnTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/1.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MockExamLearnTableViewCell.h"

@implementation MockExamLearnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buyButton.layer.cornerRadius = 4;
    self.buyButton.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
