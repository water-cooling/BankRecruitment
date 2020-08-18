//
//  VideoTreeTableViewCell.h
//  Recruitment
//
//  Created by yltx on 2020/8/16.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoTreeTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *actionBtn;
@property (nonatomic, strong) IBOutlet UIView *upLineView;
@property (nonatomic, strong) IBOutlet UIView *downLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cricleHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

NS_ASSUME_NONNULL_END
