//
//  MockReportScoreTableViewCell.m
//  Recruitment
//
//  Created by xia jianqing on 2017/9/20.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MockReportScoreTableViewCell.h"

@implementation MockReportScoreTableViewCell

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
