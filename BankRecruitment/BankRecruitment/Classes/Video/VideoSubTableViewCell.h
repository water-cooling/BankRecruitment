//
//  VideoSubTableViewCell.h
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoSubTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *videoTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *videoNumberTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *videoNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *videoCorrectRateTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *videoCorrectRateLabel;
@property (nonatomic, strong) IBOutlet UIButton *typeButton;

@end
