//
//  NewsTableViewCell.m
//  Recruitment
//
//  Created by 夏建清 on 2018/5/29.
//  Copyright © 2018年 LongLian. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell

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
