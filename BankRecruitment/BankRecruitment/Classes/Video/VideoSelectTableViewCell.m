//
//  VideoSelectTableViewCell.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "VideoSelectTableViewCell.h"

@implementation VideoSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 119.5, Screen_Width, 0.5)];
    lineView.backgroundColor = kColorLineSepBackground;
    [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
