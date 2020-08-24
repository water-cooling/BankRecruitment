//
//  MineMessageTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/5.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MineMessageTableViewCell.h"

@implementation MineMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
       self.layer.shadowColor = [UIColor colorWithHex:@"#3C3C3C"].CGColor;
       self.layer.shadowRadius = -M_PI_2;
       self.layer.shadowOpacity = 1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)getMineMessageTableViewCellByDetailString:(NSString *)string
{
    CGSize size = [LdGlobalObj sizeWithString:string font:[UIFont systemFontOfSize:13] width:Screen_Width-60];
    return size.height + 60;
}

@end
