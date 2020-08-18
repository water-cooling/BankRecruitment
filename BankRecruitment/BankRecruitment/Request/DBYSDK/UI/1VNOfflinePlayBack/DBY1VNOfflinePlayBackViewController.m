//
//  DBY1VNOfflinePlayBackViewController.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/19.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBY1VNOfflinePlayBackViewController.h"

#import "DBYOfflinePlayBackManager.h"

#import "DBYSelectView.h"

#import "DBYFullScreenNavView.h"

#import "DBYFullScreenBottomView.h"

#import "DBYBaseUIMacro.h"

#import "DBYBaseChatTableViewCell.h"

#import "DBYPlaybackBottomView.h"

#import "DBYProgressHUD+NJ.h"

#import "DBYChatEventInfo.h"

#import "DBYChatInfo.h"

@interface DBY1VNOfflinePlayBackViewController ()<UITableViewDelegate,UITableViewDataSource,DBYSelectViewDelegate,DBYOfflinePlayBackManagerDelegate>
@property(nonatomic,strong)DBYOfflinePlayBackManager*playbackManager;

@property(nonatomic,weak)UIView* pptView;

//隐藏ppt底部view 按钮
@property(nonatomic,weak)UIButton* pptBottomHideButton;

@property(nonatomic,weak)DBYPlaybackBottomView* playBackBottomView;
//
@property(nonatomic,weak)DBYSelectView* selectView;
//分割线
@property(nonatomic,weak)UIView*lineView;
//聊天放置View
@property(nonatomic,weak)UIView* chatView;
//所有聊天
@property(nonatomic,weak)UITableView*allChatView;
//老师聊天
@property(nonatomic,weak)UITableView* teacherChatView;

//全屏 导航栏
@property(nonatomic,weak)DBYFullScreenNavView* fullScreenNavView;

@property(nonatomic,weak)DBYFullScreenBottomView * fullScreenBottomView;
//全屏隐藏导航栏 按钮
@property(nonatomic,weak)UIButton* fullScreenHideButton;

//@property(nonatomic,weak)UIView* videoView;

@property(nonatomic,assign)BOOL firstToLandScape;

@end

@implementation DBY1VNOfflinePlayBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:26/255.0 green:25/255.0 blue:31/255.0 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];

    self.navigationController.navigationBar.backIndicatorImage = [DBYUIUtils bundleImageWithImageName:@"Back Arrow"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [DBYUIUtils bundleImageWithImageName:@"Back Arrow"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
    self.firstToLandScape = YES;
    
    
    UIView*pptView = [[UIView alloc]init];
    [self.view addSubview:pptView];
    self.pptView = pptView;
    
    
    UIButton*pptBottomHideButton = [[UIButton alloc]init];
    [pptBottomHideButton addTarget:self action:@selector(clickPPTBottomViewHide:) forControlEvents:UIControlEventTouchDown];
    [pptView addSubview:pptBottomHideButton];
    self.pptBottomHideButton = pptBottomHideButton;
    
    __weak typeof(self) weakSelf = self;
    
    DBYPlaybackBottomView*playbackBottomView = [[DBYPlaybackBottomView alloc]init];
    [pptView addSubview:playbackBottomView];
    self.playBackBottomView = playbackBottomView;
    playbackBottomView.clickFullScreenHandler = ^{
        [weakSelf clickFullScreen];
    };
    
    
    
//    UIView*videoView = [[UIView alloc]init];
//    [pptView addSubview:videoView];
//    self.videoView = videoView;
    
    //全屏按钮
//    UIButton*fullScreenButton = [[UIButton alloc]init];
//    [fullScreenButton setImage:[DBYUIUtils bundleImageWithImageName:@"Fullscreen"] forState:UIControlStateNormal];
//    [fullScreenButton setBackgroundImage:[DBYUIUtils createImageWithColor:DBYColorFromRGBA(0, 0, 0, 0.4)] forState:UIControlStateNormal];
//    fullScreenButton.layer.masksToBounds = YES;
//    fullScreenButton.layer.cornerRadius = 4;
//    [pptView addSubview:fullScreenButton];
//    [fullScreenButton addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
//    self.fullScreenButton = fullScreenButton;
    
    DBYSelectView *selectView = [[DBYSelectView alloc]initWithTitles:@[@"全部聊天"]];
    [self.view addSubview:selectView];
    selectView.delegate = self;
    self.selectView = selectView;
    
    //分割线
    UIView*lineView = [[UIView alloc]init];
    lineView.backgroundColor = DBYColorFromRGBA(229, 230, 235, 1);
    [self.view addSubview:lineView];
    self.lineView = lineView;
    
    //聊天列表
    UIView*chatView = [[UIView alloc]init];
    [self.view addSubview:chatView];
    self.chatView = chatView;
    
    UITableView*allChatView = [[UITableView alloc]init];
    allChatView.backgroundColor = DBYColorFromRGBA(238, 238, 242, 1);
    [chatView addSubview:allChatView];
    allChatView.delegate = self;
    allChatView.dataSource = self;
    allChatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [allChatView registerClass:[DBYBaseChatTableViewCell class] forCellReuseIdentifier:kDBYBaseChatTableViewCellReuseID];
    allChatView.rowHeight = kDBYBaseChatTableViewCellHeight;
    self.allChatView = allChatView;
    /*
    //老师聊天列表
    UITableView*teacherChatView = [[UITableView alloc]init];
    teacherChatView.hidden = YES;
    teacherChatView.backgroundColor = DBYColorFromRGBA(238, 238, 242, 1);
    [chatView addSubview:teacherChatView];
    teacherChatView.delegate = self;
    teacherChatView.dataSource = self;
    teacherChatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [teacherChatView registerClass:[DBYBaseChatTableViewCell class] forCellReuseIdentifier:kDBYBaseChatTableViewCellReuseID];
    teacherChatView.rowHeight = kDBYBaseChatTableViewCellHeight;
    self.teacherChatView = teacherChatView;
    */
    //全屏控件
    UIButton*fullScreenHideButton = [[UIButton alloc]init];
    fullScreenHideButton.hidden = YES;
    [self.view addSubview:fullScreenHideButton];
    self.fullScreenHideButton = fullScreenHideButton;
    [fullScreenHideButton addTarget:self action:@selector(clickHideFullScreen:) forControlEvents:UIControlEventTouchDown];
    
    DBYFullScreenNavView*fullScreenNavView = [[DBYFullScreenNavView alloc]init];
    fullScreenNavView.hidden = YES;
    fullScreenNavView.title = self.title;
    [self.view addSubview:fullScreenNavView];
    self.fullScreenNavView = fullScreenNavView;
    fullScreenNavView.clickBackButtonHandler = ^(){
        [weakSelf back];
    };
    
    DBYFullScreenBottomView * fullScreenBottomView = [[DBYFullScreenBottomView alloc]init];
    fullScreenBottomView.hidden = YES;
    [self.view addSubview:fullScreenBottomView];
    self.fullScreenBottomView = fullScreenBottomView;
    fullScreenBottomView.clickQuitFullScreenButtonHandler = ^(){
        [weakSelf clickQuitButton];
    };
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(active:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    
    
    
    
    self.playbackManager = [[DBYOfflinePlayBackManager alloc]init];
    
    self.playbackManager.roomID = self.roomID;
    
    [self.playbackManager setupSlideViewWith:pptView];
    
    self.playbackManager.delegate = self;
    
    self.playBackBottomView.beginPanHandler = ^(float progress){
        [weakSelf.playbackManager pause];
    };
    self.playBackBottomView.endPanHandler = ^(float progress){
        [weakSelf.playbackManager seekToProgress:progress];
        
        [weakSelf.playbackManager resume];
    };
    self.playBackBottomView.clickPlayButtonHandler = ^(BOOL isPlaying) {
        if (isPlaying) {
            [weakSelf.playbackManager resume];
        } else {
            [weakSelf.playbackManager pause];
        }
    };
    
    self.fullScreenBottomView.beginPanHandler = ^(float progress){
        [weakSelf.playbackManager pause];
    };
    self.fullScreenBottomView.endPanHandler = ^(float progress){
        [weakSelf.playbackManager seekToProgress:progress];
        
        [weakSelf.playbackManager resume];
    };
    self.fullScreenBottomView.clickPlayButtonHandler = ^(BOOL isPlaying) {
        if (isPlaying) {
            [weakSelf.playbackManager resume];
        } else {
            [weakSelf.playbackManager pause];
        }
    };
    
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect frame = self.view.frame;
    if (frame.size.height > frame.size.width) {
        [self rotateToPortrait];
    } else {
        [self rotateToLandScape];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.playbackManager prepareForPlayWithCompleteHandler:^(NSString *errorMsg, DBYOfflinePlayBackManagerPrepareErrorType error) {
        if (error != DBYOfflinePlayBackManagerPrepareErrorTypeNoError) {
            [DBYProgressHUD showError:@"播放出错"];
            return ;
        }
        [self.playBackBottomView setTotalTimeLabelWithTime:self.playbackManager.lessonLength];
        
        [self.fullScreenBottomView setTotalTimeLabelWithTime:self.playbackManager.lessonLength];
        
        [self.playbackManager play];
    }];
}
#pragma mark - screen rotate 屏幕旋转
//竖屏
-(void)rotateToPortrait
{
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //调整pptView
    self.pptView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width, self.view.frame.size.width/4*3);
    
    CGFloat playBackBottomViewHeight = 68;
    self.playBackBottomView.frame = CGRectMake(0, CGRectGetHeight(self.pptView.frame) - playBackBottomViewHeight, self.pptView.frame.size.width, playBackBottomViewHeight);
    self.playBackBottomView.hidden = NO;
    
    
    self.pptBottomHideButton.frame = self.pptView.bounds;
    self.pptBottomHideButton.hidden = NO;
    self.pptBottomHideButton.selected = NO;
    
//    self.videoView.frame = CGRectMake(0,  self.pptView.frame.size.height*(1-0.4), self.pptView.frame.size.height*0.4 / 3 * 4, self.pptView.frame.size.height*0.4);
    
    
//    CGFloat fullScreenButtonW = 40;
//    CGFloat fullScreenButtonH = fullScreenButtonW;
//    CGFloat fullScreenButtonX = self.pptView.frame.size.width - fullScreenButtonW;
//    CGFloat fullScreenButtonY = self.pptView.frame.size.height - fullScreenButtonH;
//    self.fullScreenButton.frame = CGRectMake(fullScreenButtonX, fullScreenButtonY, fullScreenButtonW, fullScreenButtonH);
//    
//    self.fullScreenButton.hidden = NO;
    
    
    self.selectView.hidden = NO;
    self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.pptView.frame), self.view.frame.size.width, 44);
    
    self.lineView.hidden = NO;
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), self.view.frame.size.width, 1);
    
    self.chatView.hidden = NO;
    self.chatView.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.lineView.frame));
    
    self.allChatView.frame = self.chatView.bounds;
    self.teacherChatView.frame = self.chatView.bounds;
    
    self.fullScreenHideButton.hidden = YES;
    self.fullScreenNavView.hidden = YES;
    self.fullScreenBottomView.hidden = YES;
}
//横屏
-(void)rotateToLandScape
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat pptViewH = self.view.frame.size.height;
    CGFloat pptViewW = pptViewH / 3 * 4;
    CGFloat pptViewY = 0;
    CGFloat pptViewX = (self.view.frame.size.width - pptViewW)/2;
    self.pptView.frame = CGRectMake(pptViewX, pptViewY, pptViewW, pptViewH);
    
    self.playBackBottomView.hidden = YES;
//    self.videoView.frame = CGRectMake(0,  self.pptView.frame.size.height*(1-0.4), self.pptView.frame.size.height*0.4 / 3 * 4, self.pptView.frame.size.height*0.4);
    
    self.chatView.hidden = YES;
    
    self.playBackBottomView.hidden = YES;
    self.pptBottomHideButton.hidden = YES;
//    self.fullScreenButton.hidden = YES;
    
    
    self.lineView.hidden = YES;
    self.selectView.hidden = YES;
    
    
    self.fullScreenHideButton.hidden = NO;
    self.fullScreenHideButton.frame = self.view.bounds;
    self.fullScreenHideButton.selected = YES;
    
    self.fullScreenNavView.hidden = NO;
    self.fullScreenNavView.frame = CGRectMake(0, 0, self.view.frame.size.width, 68);
    
    
    self.fullScreenBottomView.hidden = NO;
    self.fullScreenBottomView.frame = CGRectMake(0, self.view.frame.size.height - 68, self.view.frame.size.width, 68);
    
    
//    if (self.firstToLandScape) {
//        [self performSelector:@selector(hideFullScreenView) withObject:nil afterDelay:5];
//        self.firstToLandScape = NO;
//    }
}
#pragma mark - Notification methods
- (void)active:(NSNotification*)noti
{
    NSLog(@"active");
    
    if (self.playbackManager) {
        [self.playbackManager resume];
    }
}
- (void)resignActive:(NSNotification*)noti
{
    NSLog(@"resignActive");
    
    if (self.playbackManager) {
        [self.playbackManager pause];
    }
}
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
    {
        //
        [self rotateToLandScape];
    }
    if (orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
        self.navigationController.navigationBarHidden = YES;
    {
        //
        [self rotateToLandScape];
        
    }
    if (orientation == UIInterfaceOrientationPortrait)
    {
        //
        
        
        [self rotateToPortrait];
        
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        
    {
        
        //
        
    }
    
}

#pragma mark - action methods
-(void)back
{
    NSLog(@"click back button");
    
    if (self.navigationController.viewControllers.count >= 2) {
        
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)clickFullScreen:(UIButton*)button
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
- (void)clickHideFullScreen:(UIButton*)button
{
    //选中状态 隐藏全屏导航栏
    self.fullScreenBottomView.hidden = button.isSelected;
    self.fullScreenNavView.hidden  = button.isSelected;
    
    button.selected = !button.isSelected;
}
-(void)clickPPTBottomViewHide:(UIButton*)button
{
    button.selected = !button.isSelected;
    self.playBackBottomView.hidden = button.isSelected;
}
#pragma mark - block methods
-(void)clickFullScreen
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
-(void)clickQuitButton
{
    //退出全屏
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
#pragma mark - DBYSelectViewDelegate
-(void)selectView:(DBYSelectView *)selectView didClickButtonAtIndex:(NSInteger)index
{
    NSLog(@"点击selectView按钮,index:%ld",(long)index);
    switch (index) {
        case 0:
        {
            //显示所有聊天
            self.allChatView.hidden = NO;
            self.teacherChatView.hidden = YES;
        }
            break;
        case 1:
        {
            self.allChatView.hidden = YES;
            self.teacherChatView.hidden = NO;
        }
            break;
        default:
            break;
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.playbackManager) {
        if (tableView == self.allChatView) {
            return self.playbackManager.chatInfoArray.count;
        }
        if (tableView == self.teacherChatView) {
//            return  self.liveManager.teacherChatDictArray.count;
        }
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBYBaseChatTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:kDBYBaseChatTableViewCellReuseID];
    
    DBYChatEventInfo*chatEventInfo;
    if (tableView == self.allChatView) {
        chatEventInfo = [self.playbackManager.chatInfoArray objectAtIndex:self.playbackManager.chatInfoArray.count - 1 - indexPath.row];
    }
    if (tableView == self.teacherChatView) {
//        chatDict = [self.liveManager.teacherChatDictArray objectAtIndex:self.liveManager.teacherChatDictArray.count - 1 -indexPath.row];
    }
    
    
    DBYChatInfo*chatInfo = [[DBYChatInfo alloc]init];
    
    chatInfo.role = chatEventInfo.role;
    chatInfo.userName = chatEventInfo.userName;
    chatInfo.message = chatEventInfo.message;
    chatInfo.uid = chatEventInfo.uid;
    chatInfo.time = [NSDate dateWithTimeIntervalSince1970:chatEventInfo.recordTime/1000];
    
    cell.chatInfo = chatInfo;
    
    
    return cell;
}
#pragma mark - DBYOfflinePlayBackManagerDelegate
-(void)offlinePlayBackManager:(DBYOfflinePlayBackManager *)manager isPlayingAtProgress:(float)progress time:(NSTimeInterval)time
{
    [self.playBackBottomView setProgressWith:progress];
    [self.playBackBottomView setCurrentTimeLabelWithTime:time];
    
    [self.fullScreenBottomView setProgressWith:progress];
    [self.fullScreenBottomView setCurrentTimeLabelWithTime:time];
}
-(void)offlinePlayBackManager:(DBYOfflinePlayBackManager *)manager chatInfoArray:(NSArray *)chatInfoArray
{
    [self.allChatView reloadData];
}
-(void)offlinePlayBackManager:(DBYOfflinePlayBackManager *)manager playStateIsPlaying:(BOOL)isPlaying
{
    [self.playBackBottomView setPlayButtonStateWith:isPlaying];
    [self.fullScreenBottomView setPlayButtonStateWith:isPlaying];
}
@end
