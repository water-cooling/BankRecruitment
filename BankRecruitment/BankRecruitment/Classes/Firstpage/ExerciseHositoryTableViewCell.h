//
//  ExerciseHositoryTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseHositoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic, strong) IBOutlet UILabel* ExerciseHositoryTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel* ExerciseHositoryTimeLabel;
@end
