//
//  ExaminationPaperTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExaminationPaperTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *ExaminationPaperTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *ExaminationPaperPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *ExaminationPaperClassPlanLabel;
@property (nonatomic, strong) IBOutlet UILabel *ExaminationPaperBuyNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *ExaminationPaperLimitTimeLabel;

@end
