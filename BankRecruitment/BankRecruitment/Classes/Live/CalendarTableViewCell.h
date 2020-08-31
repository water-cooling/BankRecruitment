//
//  CalendarTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *calendarTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *calendarTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic, strong) UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editheight;

@end
