//
//  MineFunctionBtnTableViewCell.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MineFunctionBtnFunc <NSObject>
- (void)MineFunctionBtnPressed:(NSInteger)index;
@end
@interface MineFunctionBtnTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, assign) id<MineFunctionBtnFunc> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgtop;

@property (weak, nonatomic) IBOutlet UILabel *telephoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *noReadCountLab;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTop;
@property (weak, nonatomic) IBOutlet UIButton *PersonInfoBtn;

@end
