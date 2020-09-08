//
//  ErrorAnalysisOptionTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ErrorAnalysisOptionTableViewCell.h"

@implementation ErrorAnalysisOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.examOptionButton.layer.borderColor = kColorLineSepBackground.CGColor;
    self.examOptionButton.layer.borderWidth = 1;
    self.examOptionButton.layer.cornerRadius = 4;
    self.examOptionButton.layer.masksToBounds = YES;
    
    self.examOptionButton.titleLabel.numberOfLines = 0;
    self.examOptionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    self.examOptionButton.layer.cornerRadius = 12.5;
    self.examOptionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.examOptionButton.userInteractionEnabled = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setOptinalCellType:(ErrorAnalysisOption)type attributeString:(NSMutableAttributedString *)attributeString
{
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        if(type == ErrorAnalysisOptionNomal){
            self.examOptionImageView.hidden = YES;
            
            self.examOptionButton.layer.borderColor = UIColorFromHex(0x666666).CGColor;
            self.examOptionButton.layer.borderWidth = 1;
            self.examOptionButton.layer.masksToBounds = YES;
            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x666666) range:NSMakeRange(0, [attributeString length])];
//            [self.examOptionButton setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
        }
        else if(type == ErrorAnalysisOptionRight)
        {
            [self.examOptionImageView setImage:[UIImage imageNamed:@"错题success"] forState:0];
            [self.examOptionImageView setTitle:@"" forState:0];

            self.examOptionButton.layer.borderColor = [UIColor colorWithHex:@"#207154"].CGColor;
            self.examOptionButton.layer.borderWidth = 1;
            self.examOptionButton.layer.masksToBounds = YES;
            [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#333333"] range:NSMakeRange(0, [attributeString length])];
//            [self.examOptionButton setTitleColor:[UIColor colorWithHex:@"#207154"] forState:UIControlStateNormal];
        }
        else if(type == ErrorAnalysisOptionWrong)
        {
            [self.examOptionImageView setImage:[UIImage imageNamed:@"错题error"] forState:0];
            [self.examOptionImageView setTitle:@"" forState:0];
            self.examOptionButton.layer.borderColor = [UIColor colorWithHex:@"#a13c25"].CGColor;
            self.examOptionButton.layer.borderWidth = 1;
            self.examOptionButton.layer.masksToBounds = YES;
            [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#333333"] range:NSMakeRange(0, [attributeString length])];
//            [self.examOptionButton setTitleColor:[UIColor colorWithHex:@"#a13c25"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if(type == ErrorAnalysisOptionNomal){
            self.examOptionImageView.hidden = YES;
            
            self.examOptionButton.layer.borderColor = kColorLineSepBackground.CGColor;
            self.examOptionButton.layer.borderWidth = 1;
            self.examOptionButton.layer.masksToBounds = YES;
            [attributeString addAttribute:NSForegroundColorAttributeName value:kColorDarkText range:NSMakeRange(0, [attributeString length])];
//            [self.examOptionButton setTitleColor:kColorDarkText forState:UIControlStateNormal];
        }
        else if(type == ErrorAnalysisOptionRight)
        {
            [self.examOptionImageView setImage:[UIImage imageNamed:@"错题success"] forState:0];
            [self.examOptionImageView setTitle:@"" forState:0];
            self.examOptionButton.layer.borderColor = [UIColor colorWithHex:@"#60d49e"].CGColor;
            self.examOptionButton.layer.borderWidth = 1;
            self.examOptionButton.layer.masksToBounds = YES;
            [attributeString addAttribute:NSForegroundColorAttributeName value:kColorDarkText range:NSMakeRange(0, [attributeString length])];
//            [self.examOptionButton setTitleColor:[UIColor colorWithHex:@"#60d49e"] forState:UIControlStateNormal];
        }
        else if(type == ErrorAnalysisOptionWrong)
        {
            self.examOptionImageView.hidden = NO;
            [self.examOptionImageView setImage:[UIImage imageNamed:@"错题error"] forState:0];
            [self.examOptionImageView setTitle:@"" forState:0];
            self.examOptionButton.layer.borderColor = [UIColor colorWithHex:@"#eb472d"].CGColor;
            self.examOptionButton.layer.borderWidth = 1;
            self.examOptionButton.layer.masksToBounds = YES;
            [attributeString addAttribute:NSForegroundColorAttributeName value:kColorDarkText range:NSMakeRange(0, [attributeString length])];
//            [self.examOptionButton setTitleColor:[UIColor colorWithHex:@"#eb472d"] forState:UIControlStateNormal];
        }
    }
    
}



@end
