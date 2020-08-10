//
//  QuestionReportTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "QuestionReportTableViewCell.h"

@implementation QuestionReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.BottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 61.5, Screen_Width, 0.5)];
    self.BottomLine.backgroundColor = kColorLineSepBackground;
    self.BottomLine.hidden = YES;
    [self addSubview:self.BottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
