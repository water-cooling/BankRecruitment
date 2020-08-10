//
//  ExamTitleTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/8.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamTitleTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* examIndexLabel;
@property (nonatomic, strong) IBOutlet UILabel* examTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel* examTopTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *examTypeImageView;
@end
