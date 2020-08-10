//
//  PayMethodTableViewCell.h
//  ZhiliGou
//
//  Created by xia jianqing on 17/2/12.
//  Copyright © 2017年 ZTE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMethodTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) IBOutlet UILabel *payTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *payDetailLabel;
@property (nonatomic, strong) IBOutlet UIImageView *selectImageView;
@end
