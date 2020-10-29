//
//  BaseViewController.h
//  Recruitment
//
//  Created by humengfan on 2020/10/23.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
-(void)setFakeNavigationBarCommonLeftButton;
-(void)setupRefreshTable:(UIScrollView *)tableView needsFooterRefresh:(BOOL)isFooterRefresh;
- (void)reloadHeaderTableViewDataSource;
- (void)reloadFooterTableViewDataSource;
-(void)setIOS:(UIScrollView *)scroller;
@end

NS_ASSUME_NONNULL_END
