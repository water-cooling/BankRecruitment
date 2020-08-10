//
//  MineMessageTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/5.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *messageTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageTimeLabel;

- (CGFloat)getMineMessageTableViewCellByDetailString:(NSString *)string;
@end
