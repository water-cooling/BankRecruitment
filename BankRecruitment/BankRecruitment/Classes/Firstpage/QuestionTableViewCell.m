//
//  QuestionTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/30.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.BottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 66.5, Screen_Width, 0.5)];
    self.BottomLine.backgroundColor = kColorLineSepBackground;
    self.BottomLine.hidden = YES;
    [self addSubview:self.BottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
