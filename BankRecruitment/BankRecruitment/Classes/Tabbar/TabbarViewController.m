//
//  TabbarViewController.m
//  Recruitment
//
//  Created by humengfan on 2020/8/8.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "TabbarViewController.h"
#import "FirstpageViewController.h"
#import "LiveViewController.h"
#import "QAListViewController.h"
#import "NewsViewController.h"
#import "MineViewController.h"
#import "VideoSelectViewController.h"
@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawNavigationBarAndViews];
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)drawNavigationBarAndViews{
    FirstpageViewController *FirstPageVC = [[FirstpageViewController alloc] init];
    UINavigationController *FirstPageVCNAV = [[UINavigationController alloc] initWithRootViewController:FirstPageVC];
    [LdGlobalObj sharedInstanse].firstPageVC = FirstPageVC;
    FirstPageVCNAV.tabBarItem.image = [[UIImage imageNamed:@"bottom_icon_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FirstPageVCNAV.tabBarItem.selectedImage = [[UIImage imageNamed:@"bottom_icon_home_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FirstPageVCNAV.tabBarItem.title = @"首页";
    [FirstPageVCNAV.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorSelect, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    LiveViewController *liveVC = [[LiveViewController alloc] init];
    UINavigationController *liveVCNav = [[UINavigationController alloc] initWithRootViewController:liveVC];
    [LdGlobalObj sharedInstanse].liveVC = liveVC;
    liveVCNav.tabBarItem.image = [[UIImage imageNamed:@"home_icon_play"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    liveVCNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_icon_play_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    liveVCNav.tabBarItem.title = @"课程";
    [liveVCNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorSelect, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    QAListViewController *QAPageVC = [[QAListViewController alloc] init];
    UINavigationController *QAPageVCNAV = [[UINavigationController alloc] initWithRootViewController:QAPageVC];
    [LdGlobalObj sharedInstanse].firstPageVC = FirstPageVC;
    QAPageVCNAV.tabBarItem.image = [[UIImage imageNamed:@"wd-w"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    QAPageVCNAV.tabBarItem.selectedImage = [[UIImage imageNamed:@"wd-x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    QAPageVCNAV.tabBarItem.title = @"问答";
    [QAPageVCNAV.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorSelect, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    VideoSelectViewController *videoVC = [[VideoSelectViewController alloc] init];
    UINavigationController *videoVCNav = [[UINavigationController alloc] initWithRootViewController:videoVC];
//    [videoVC NetworkGetVideoTypes];
//    videoVC.isFirstLoad = YES;
    [LdGlobalObj sharedInstanse].VideoVC = videoVC;
    videoVCNav.tabBarItem.image = [[UIImage imageNamed:@"home_icon_tiku"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    videoVCNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_icon_tiku_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    videoVCNav.tabBarItem.title = @"题库";
    [videoVCNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorSelect, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    UINavigationController *mineVCNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    [LdGlobalObj sharedInstanse].MineVC = mineVC;
    mineVCNav.tabBarItem.image = [[UIImage imageNamed:@"home_icon_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVCNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_icon_my_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVCNav.tabBarItem.title = @"我的";
    [mineVCNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorSelect, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    self.viewControllers = @[FirstPageVCNAV, liveVCNav,QAPageVCNAV, videoVCNav, mineVCNav];
   
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
