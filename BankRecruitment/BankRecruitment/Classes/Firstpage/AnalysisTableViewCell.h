//
//  AnalysisTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* AnalysisAnswerLabel;
@property (nonatomic, strong) IBOutlet UILabel* AnalysisTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel* AnalysisLabel;
@property (nonatomic, strong) IBOutlet UIView* AnalysisBackView;

@property (nonatomic, strong) IBOutlet UIView* numBackView;
@property (nonatomic, strong) IBOutlet UILabel* numTitleLabel1;
@property (nonatomic, strong) IBOutlet UILabel* numTitleLabel2;
@property (nonatomic, strong) IBOutlet UILabel* numTitleLabel3;
@property (nonatomic, strong) IBOutlet UILabel* numTitleLabel4;
@property (nonatomic, strong) IBOutlet UILabel* numLabel1;
@property (nonatomic, strong) IBOutlet UILabel* numLabel2;
@property (nonatomic, strong) IBOutlet UILabel* numLabel3;
@property (nonatomic, strong) IBOutlet UILabel* numLabel4;

- (CGFloat)getHeightAnalysisTableCellByString:(NSString *)string;
@end
