//
//  QuestionReportTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionReportTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *actionBtn;
@property (nonatomic, strong) IBOutlet UIView *upLineView;
@property (nonatomic, strong) IBOutlet UIView *downLineView;
@property (nonatomic, strong) IBOutlet UILabel *questionTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *questionExamButton;
@property (nonatomic, strong) UIView *BottomLine;
@end
