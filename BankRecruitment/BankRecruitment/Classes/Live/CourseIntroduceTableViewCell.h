//
//  CourseIntroduceTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CourseIntroduceWebViewHeightRefreshBlock)(float height);
@interface CourseIntroduceTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, copy) CourseIntroduceWebViewHeightRefreshBlock courseIntroduceWebViewHeightRefreshBlock;
@end
