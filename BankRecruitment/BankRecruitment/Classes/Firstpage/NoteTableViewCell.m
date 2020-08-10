//
//  NoteTableViewCell.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "NoteTableViewCell.h"

@implementation NoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)getHeightNoteTableCellByString:(NSString *)string
{
    CGSize size = [LdGlobalObj sizeWithString:string font:[UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize] width:Screen_Width-36];
    return size.height + 86;
}

@end
