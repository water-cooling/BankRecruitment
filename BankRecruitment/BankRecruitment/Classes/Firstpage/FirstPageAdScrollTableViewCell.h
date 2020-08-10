//
//  FirstPageAdScrollTableViewCell.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/28.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
#import "FirstAdModel.h"
#import "WSPageView.h"
#import "WSIndexBanner.h"
#import "UIImageView+WebCache.h"

@interface FirstPageAdScrollTableViewCell : UITableViewCell<WSPageViewDataSource, WSPageViewDelegate>
@property (copy, nonatomic) NSArray *upImages;
//视图中小圆点，对应视图的页码
@property (retain, nonatomic) SMPageControl *upPageControl;
//@property (retain, nonatomic) WSPageView *pageView;

- (void)setupImagesPage:(id)sender;
@end
