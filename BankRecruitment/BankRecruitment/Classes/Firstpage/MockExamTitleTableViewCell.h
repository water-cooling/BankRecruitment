//
//  MockExamTitleTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/1.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MockExamTitleTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* examTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel* examNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end
