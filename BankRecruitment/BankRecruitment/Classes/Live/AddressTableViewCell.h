//
//  AddressTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/1.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *receiveNameLab;
@property (weak, nonatomic) IBOutlet UILabel *receivePhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
