//
//  ZhaopinTableViewCell.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ZhaopinTableViewCell.h"

@implementation ZhaopinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 74.5, Screen_Width, 0.5)];
    lineView.backgroundColor = kColorLineSepBackground;
    [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
