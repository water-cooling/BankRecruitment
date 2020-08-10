//
//  TeacherIntroduceTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TeacherIntroduceWebViewHeightRefreshBlock)(float height, int index);

@interface TeacherIntroduceTableViewCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;
@property (nonatomic, strong) IBOutlet UILabel *teacherNameLabel;
@property (nonatomic, strong) IBOutlet UIWebView *teacherDetailWebView;
@property (nonatomic, copy) TeacherIntroduceWebViewHeightRefreshBlock teacherIntroduceWebViewHeightRefreshBlock;

@end
