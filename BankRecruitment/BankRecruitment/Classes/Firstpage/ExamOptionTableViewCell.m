//
//  ExamOptionTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/31.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExamOptionTableViewCell.h"

@implementation ExamOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.examOptionButton.layer.borderColor = kColorLineSepBackground.CGColor;
    self.examOptionButton.layer.borderWidth = 1;
    self.examOptionButton.layer.cornerRadius = 4;
    self.examOptionButton.layer.masksToBounds = YES;
    
    self.examOptionButton.titleLabel.numberOfLines = 0;
    self.examOptionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.examOptionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.examOptionButton.userInteractionEnabled = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)selectedOptinalCell:(BOOL)selected
{
    if(selected){
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            self.examOptionButton.layer.borderColor = kColorDarkText.CGColor;
            self.examOptionButton.layer.borderWidth = 2;
            self.examOptionButton.layer.masksToBounds = YES;
//            [self.examOptionButton setTitleColor:UIColorFromHex(0xa13125) forState:UIControlStateNormal];
        }
        else
        {
            self.examOptionButton.layer.borderColor = UIColorFromHex(0x646464).CGColor;
            self.examOptionButton.layer.borderWidth = 2;
            self.examOptionButton.layer.masksToBounds = YES;
//            [self.examOptionButton setTitleColor:UIColorFromHex(0xf9491e) forState:UIControlStateNormal];
        }
    }
    else
    {
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            self.examOptionButton.layer.borderColor = UIColorFromHex(0x666666).CGColor;
            self.examOptionButton.layer.borderWidth = 1;
            self.examOptionButton.layer.masksToBounds = YES;
//            [self.examOptionButton setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
        }
        else
        {
            self.examOptionButton.layer.borderColor = kColorLineSepBackground.CGColor;
            self.examOptionButton.layer.borderWidth = 1;
            self.examOptionButton.layer.masksToBounds = YES;
//            [self.examOptionButton setTitleColor:kColorDarkText forState:UIControlStateNormal];
        }
    }
}

@end
