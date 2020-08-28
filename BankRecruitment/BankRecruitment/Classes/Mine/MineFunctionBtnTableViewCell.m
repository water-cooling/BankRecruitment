//
//  MineFunctionBtnTableViewCell.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MineFunctionBtnTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation MineFunctionBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageTop.constant = IS_iPhoneX ? 50:26;
    self.headImgtop.constant = IS_iPhoneX ? 72:48;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)funcActionClick:(UIButton *)sender {
     [self.delegate MineFunctionBtnPressed:sender.tag-100];
}


@end
