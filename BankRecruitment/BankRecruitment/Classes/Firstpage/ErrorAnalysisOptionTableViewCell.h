//
//  ErrorAnalysisOptionTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ErrorAnalysisOption) {
    ErrorAnalysisOptionNomal,
    ErrorAnalysisOptionRight,
    ErrorAnalysisOptionWrong
};

@interface ErrorAnalysisOptionTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *examOptionButton;
@property (nonatomic, strong) IBOutlet UIButton *examOptionImageView;
@property (nonatomic, strong) IBOutlet UILabel *examOptionDetailLabel;

- (void)setOptinalCellType:(ErrorAnalysisOption)type attributeString:(NSMutableAttributedString *)attributeString;
@end
