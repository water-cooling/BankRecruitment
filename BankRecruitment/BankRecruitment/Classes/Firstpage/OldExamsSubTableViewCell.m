//
//  OldExamsSubTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/31.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "OldExamsSubTableViewCell.h"

@implementation OldExamsSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, Screen_Width, 0.5)];
    lineView.backgroundColor = kColorLineSepBackground;
    [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
