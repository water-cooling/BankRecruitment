//
//  CalendarTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "CalendarTableViewCell.h"

@implementation CalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5, Screen_Width, 0.5)];
    _lineView.backgroundColor = kColorLineSepBackground;
    [self addSubview:_lineView];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
