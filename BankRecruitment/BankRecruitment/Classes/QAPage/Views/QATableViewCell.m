//
//  QATableViewCell.m
//  Recruitment
//
//  Created by yltx on 2020/10/12.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QATableViewCell.h"

@implementation QATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userSignLab.layer.cornerRadius = 12.5;
    self.userSignLab.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
