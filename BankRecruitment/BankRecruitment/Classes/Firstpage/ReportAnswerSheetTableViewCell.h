//
//  ReportAnswerSheetTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportAnswerSheetTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIScrollView *answerSheetScrollView;
@property (nonatomic, strong) IBOutlet UILabel *answerTitleLabel;

@property (nonatomic, copy) NSArray *answerList;

- (void)setupSheet;
- (CGFloat)getHeightReportSheetCell;
@end
