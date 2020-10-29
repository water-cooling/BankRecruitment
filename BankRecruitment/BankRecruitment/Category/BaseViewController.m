//
//  BaseViewController.m
//  Recruitment
//
//  Created by humengfan on 2020/10/23.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setFakeNavigationBarCommonLeftButton{
    
    UIBarButtonItem *backItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backItemAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)backItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setIOS:(UIScrollView *)scroller{
    if (@available(iOS 11.0, *)) {
        scroller.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        
    }
}
//设置下拉刷新项
-(void)setupRefreshTable:(UIScrollView *)tableView needsFooterRefresh:(BOOL)isFooterRefresh{
    if (tableView == nil) {
        return;
    }
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadHeaderTableViewDataSource)];
    // 隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = NO;
    // 马上进入刷新状态
    // 设置header
    tableView.mj_header = header;
    if (isFooterRefresh) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightThin];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        // 设置颜色
        footer.stateLabel.textColor = [UIColor blackColor];
        tableView.mj_footer = footer;
        tableView.mj_footer.automaticallyHidden = YES;
    }
}


-(void)reloadHeaderTableViewDataSource{
}

- (void)reloadFooterTableViewDataSource{
}

-(void) loadMoreData{
    [self reloadFooterTableViewDataSource];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
