//
//  ExamTitleTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/8.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewExamTitleTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* examIndexLabel;
@property (nonatomic, strong) IBOutlet UILabel* examTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel* desTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;

@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (nonatomic, strong) IBOutlet UILabel* examTopTitleLabel;
@end
