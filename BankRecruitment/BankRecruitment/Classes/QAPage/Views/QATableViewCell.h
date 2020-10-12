//
//  QATableViewCell.h
//  Recruitment
//
//  Created by yltx on 2020/10/12.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QATableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userSignLab;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *questionContentLab;
@property (weak, nonatomic) IBOutlet UILabel *contactNumLab;
@property (weak, nonatomic) IBOutlet UILabel *followNumLab;
@property (weak, nonatomic) IBOutlet UILabel *questionTimeLab;

@end

NS_ASSUME_NONNULL_END
