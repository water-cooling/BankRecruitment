//
//  ExamOptionTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/31.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamOptionTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *examOptionButton;
@property (nonatomic, strong) IBOutlet UILabel *examOptionTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *examOptionDetailLabel;

- (void)selectedOptinalCell:(BOOL)selected;
@end
