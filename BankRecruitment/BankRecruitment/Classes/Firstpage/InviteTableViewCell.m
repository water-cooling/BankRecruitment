//
//  InviteTableViewCell.m
//  Recruitment
//
//  Created by yltx on 2020/8/11.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "InviteTableViewCell.h"

@implementation InviteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pointLab.layer.cornerRadius = 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
