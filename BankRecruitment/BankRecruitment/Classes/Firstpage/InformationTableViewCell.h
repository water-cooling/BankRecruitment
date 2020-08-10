//
//  NewsTableViewCell.h
//  Recruitment
//
//  Created by 夏建清 on 2018/5/29.
//  Copyright © 2018年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *newsImageView;
@property (nonatomic, strong) IBOutlet UILabel *newsTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *newsTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *newsCountLabel;
@end
