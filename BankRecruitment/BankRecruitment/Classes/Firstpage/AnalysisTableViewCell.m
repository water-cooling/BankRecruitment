//
//  AnalysisTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "AnalysisTableViewCell.h"

@implementation AnalysisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.numBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.numBackView.layer.borderWidth = 1;
    self.numBackView.layer.masksToBounds = YES;
    
//    self.numTitleLabel1.layer.borderColor = kColorLineSepBackground.CGColor;
//    self.numTitleLabel1.layer.borderWidth = 1;
//    self.numTitleLabel1.layer.masksToBounds = YES;
//    
//    self.numTitleLabel2.layer.borderColor = kColorLineSepBackground.CGColor;
//    self.numTitleLabel2.layer.borderWidth = 1;
//    self.numTitleLabel2.layer.masksToBounds = YES;
//    
//    self.numTitleLabel3.layer.borderColor = kColorLineSepBackground.CGColor;
//    self.numTitleLabel3.layer.borderWidth = 1;
//    self.numTitleLabel3.layer.masksToBounds = YES;
//    
//    self.numTitleLabel4.layer.borderColor = kColorLineSepBackground.CGColor;
//    self.numTitleLabel4.layer.borderWidth = 1;
//    self.numTitleLabel4.layer.masksToBounds = YES;
//    
//    self.numLabel1.layer.borderColor = kColorLineSepBackground.CGColor;
//    self.numLabel1.layer.borderWidth = 1;
//    self.numLabel1.layer.masksToBounds = YES;
//    
//    self.numLabel2.layer.borderColor = kColorLineSepBackground.CGColor;
//    self.numLabel2.layer.borderWidth = 1;
//    self.numLabel2.layer.masksToBounds = YES;
//    
//    self.numLabel3.layer.borderColor = kColorLineSepBackground.CGColor;
//    self.numLabel3.layer.borderWidth = 1;
//    self.numLabel3.layer.masksToBounds = YES;
//    
//    self.numLabel4.layer.borderColor = kColorLineSepBackground.CGColor;
//    self.numLabel4.layer.borderWidth = 1;
//    self.numLabel4.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)getHeightAnalysisTableCellByString:(NSString *)string
{
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                         options:options
                                                                              documentAttributes:nil
                                                                                           error:nil];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize] range:NSMakeRange(0, [attributeString length])];
    CGSize size = [LdGlobalObj sizeWithAttributedString:attributeString width:Screen_Width-30];
    return size.height + 160;
}

@end
