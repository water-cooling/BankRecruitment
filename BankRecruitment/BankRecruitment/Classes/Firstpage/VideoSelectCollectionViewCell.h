//
//  VideoSelectCollectionViewCell.h
//  Recruitment
//
//  Created by humengfan on 2020/8/10.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoSelectCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UILabel *videoTypeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *videoTypeImageView;
@property (nonatomic, strong) IBOutlet UILabel *chapterLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UIButton *videoBtn;
@end

NS_ASSUME_NONNULL_END
