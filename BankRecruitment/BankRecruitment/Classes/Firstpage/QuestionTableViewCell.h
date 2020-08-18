//
//  QuestionTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/30.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *actionBtn;
@property (nonatomic, strong) IBOutlet UIView *upLineView;
@property (nonatomic, strong) IBOutlet UIView *downLineView;
@property (nonatomic, strong) IBOutlet UILabel *questionTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *questionNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *totelCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic, strong) UIView *BottomLine;

@end
