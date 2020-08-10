//
//  DBY1VNLiveViewController.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/3/31.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBY1VNLiveViewController.h"

#import "DBYSelectView.h"

#import "DBYBaseUIMacro.h"

#import "DBYBaseChatTableViewCell.h"

#import "DBYLiveManager.h"

#import "DBYFullScreenNavView.h"

#import "DBYFullScreenBottomView.h"

#import "DBYChatInputView.h"

#import "DBYChatInfo.h"

#import "DBYProgressHUD+NJ.h"

#import "DBYPlaybackBottomView.h"

#import "DBYAnimateImageView.h"


@interface DBY1VNLiveViewController () <DBYSelectViewDelegate,UITableViewDelegate,UITableViewDataSource,DBYLiveManagerDelegate,DBYChatInputViewDelegate>

@property(nonatomic,strong)DBYLiveManager* liveManager;

@property(nonatomic,weak)UIView* pptView;
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
//隐藏ppt底部view 按钮
@property(nonatomic,weak)UIButton* pptBottomHideButton;

@property(nonatomic,weak)DBYPlaybackBottomView* playbackBottomView;

@property(nonatomic,weak)UIButton*chatButton;
//举手按钮
@property(nonatomic,weak)UIButton*raiseHandButton;
//发言状态view
@property(nonatomic,weak)DBYAnimateImageView* speakStateView;
//是否正在发言
@property(nonatomic,assign)BOOL isSpeaking;
//全屏 导航栏
@property(nonatomic,weak)DBYFullScreenNavView* fullScreenNavView;

@property(nonatomic,weak)DBYFullScreenBottomView * fullScreenBottomView;
//全屏隐藏导航栏 按钮
@property(nonatomic,weak)UIButton* fullScreenHideButton;

@property(nonatomic,weak)DBYChatInputView* chatInputView;

@property(nonatomic,weak)UIView* videoView;

@property(nonatomic,weak)UIButton* videoFullScreenBtn;



@property(nonatomic,assign)BOOL firstToLandScape;

@property(nonatomic,assign)BOOL firstInView;

//是否在重連
@property(nonatomic,assign)BOOL isConnecting;


@end


@implementation DBY1VNLiveViewController

#pragma mrak - style
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
#pragma mark - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.firstInView = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:26/255.0 green:25/255.0 blue:31/255.0 alpha:1]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//    self.navigationController.navigationBar.backIndicatorImage = [DBYUIUtils bundleImageWithImageName:@"Back Arrow"];
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [DBYUIUtils bundleImageWithImageName:@"Back Arrow"];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.title = @"直播";
    
    
    self.firstToLandScape = YES;
    
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //
    //    self.navigationItem.leftBarButtonItem = backItem;
    
    /*
     //返回按钮样式
     UIImage *backImage = [UIImage imageNamed:@"Back Arrow"];
     UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [backButton setImage:backImage forState:UIControlStateNormal];
     [backButton setTitle:@"返回" forState:UIControlStateNormal];
     backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
     backButton.titleLabel.font = [UIFont systemFontOfSize:16];
     backButton.frame = (CGRect) {
     .size.width = 60,
     .size.height = 30,
     };
     [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *backBarButton= [[UIBarButtonItem alloc] initWithCustomView:backButton];
     self.navigationItem.leftBarButtonItem = backBarButton;
     */
    
    UIView*pptView = [[UIView alloc]init];
    [self.view addSubview:pptView];
    self.pptView = pptView;
    
    
    
    UIButton*pptBottomHideButton = [[UIButton alloc]init];
    [pptBottomHideButton addTarget:self action:@selector(clickPPTBottomViewHide:) forControlEvents:UIControlEventTouchDown];
    [pptView addSubview:pptBottomHideButton];
    self.pptBottomHideButton = pptBottomHideButton;
    
    
    UIView*videoView = [[UIView alloc]init];
    [pptBottomHideButton addSubview:videoView];
    self.videoView = videoView;
    
    UIButton*videoFullScreenBtn = [[UIButton alloc]init];
    [videoFullScreenBtn addTarget:self action:@selector(clickVideoFullScreenBtn:) forControlEvents:UIControlEventTouchDown];
    [videoView addSubview:videoFullScreenBtn];
    self.videoFullScreenBtn = videoFullScreenBtn;
    
    
    
    __weak typeof(self) weakSelf = self;
    
    DBYPlaybackBottomView*playbackBottomView = [[DBYPlaybackBottomView alloc]init];
    [pptView addSubview:playbackBottomView];
    playbackBottomView.mode = DBYPlaybackBottomViewModeLive;
    playbackBottomView.clickFullScreenHandler = ^{
        [weakSelf clickFullScreen];
    };
    self.playbackBottomView = playbackBottomView;
    
    DBYSelectView *selectView = [[DBYSelectView alloc]initWithTitles:@[@"全部聊天",@"只看老师"]];
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

    
    
    UIButton*chatButton = [[UIButton alloc]init];
    [chatButton setImage:[DBYUIUtils bundleImageWithImageName:@"Comment"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(clickChatButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatButton];
    self.chatButton = chatButton;
    
    if (self.allowRaiseHand) {
        UIButton*raiseHandButton = [[UIButton alloc]init];
        [raiseHandButton setImage:[DBYUIUtils bundleImageWithImageName:@"hand"] forState:UIControlStateNormal];
        [raiseHandButton setBackgroundImage:[DBYUIUtils createImageWithColor:DBYColorFromRGBA(0, 0, 0, 0.6)] forState:UIControlStateNormal];
        raiseHandButton.layer.masksToBounds = YES;
        raiseHandButton.layer.cornerRadius = 4;
        [raiseHandButton addTarget:self action:@selector(clickRaiseHand:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:raiseHandButton];
        self.raiseHandButton = raiseHandButton;
        
        DBYAnimateImageView*speakStateView = [[DBYAnimateImageView alloc]init];
        speakStateView.layer.masksToBounds = YES;
        speakStateView.layer.cornerRadius = 4;
        speakStateView.backgroundColor = DBYColorFromRGBA(0, 0, 0, 0.6);
        NSArray*images = @[[DBYUIUtils bundleImageWithImageName:@"01"],[DBYUIUtils bundleImageWithImageName:@"02"],[DBYUIUtils bundleImageWithImageName:@"03"],[DBYUIUtils bundleImageWithImageName:@"04"]];
        [speakStateView.images addObjectsFromArray:images];
        [self.view addSubview:speakStateView];
        self.speakStateView = speakStateView;

    }
    
    
    
    DBYChatInputView*chatInputView = [[DBYChatInputView alloc]init];
    [self.view addSubview:chatInputView];
    self.chatInputView = chatInputView;
    chatInputView.delegate = self;
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
    fullScreenBottomView.mode = DBYFullScreenBottomViewModeLive;
    fullScreenBottomView.hidden = YES;
    [self.view addSubview:fullScreenBottomView];
    self.fullScreenBottomView = fullScreenBottomView;
    fullScreenBottomView.clickQuitFullScreenButtonHandler = ^(){
        [weakSelf clickQuitButton];
    };
    
    //liveManager
    if (self.appkey.length > 0 && self.partnerID.length > 0 ) {
        self.liveManager = [[DBYLiveManager alloc]initWithPartnerId:self.partnerID withAppKey:self.appkey];
    } else {
        self.liveManager = [[DBYLiveManager alloc]init];
    }
    
   
    [self.liveManager setTeacherViewWith:self.videoView];
    [self.liveManager setPPTViewWithView:self.pptView];
    
    self.liveManager.delegate = self;

    [self.liveManager setPPTViewBackgroundImage:[UIImage imageNamed:@"black-board"]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(active:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordWillChangeFrame:)name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enterClassRoom];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self quitClassRoom];
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.firstInView) {
        
    CGRect frame = self.view.frame;
    if (frame.size.height > frame.size.width) {
        [self rotateToPortrait];
    } else {
        [self rotateToLandScape];
    }
        self.firstInView = NO;
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - private
- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideFullScreenView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.fullScreenNavView.hidden = YES;
        self.fullScreenBottomView.hidden = YES;
        self.fullScreenHideButton.selected = NO;
    }];
}
#pragma mark - classRoom methods
-(void)enterClassRoom
{
    [DBYProgressHUD showMessage:@"正在连接"];

    if (self.enterURLString) {
        [self.liveManager enterRoomWithUrl:self.enterURLString completeHandler:^(NSString *errorMsg, DBYLiveManagerEnterRoomErrorType error) {
            
            if (error == DBYLiveManagerEnterRoomErrorTypeNoError) {
                
            } else {
                NSString*msg = [DBYLiveManager enterRoomErrorMessageWithErrorType:error];
                [DBYProgressHUD hideHUD];
                [DBYProgressHUD showError:msg];
                
            }
            
        }];
    } else if (self.inviteCode) {
        [self.liveManager enterRoomWithInviteCodeWith:self.inviteCode nickName:self.nickName completeHandler:^(NSString *errorMsg, DBYLiveManagerEnterRoomErrorType error) {
            
            if (error == DBYLiveManagerEnterRoomErrorTypeNoError) {
                
            } else {
                NSString*msg = [DBYLiveManager enterRoomErrorMessageWithErrorType:error];
                [DBYProgressHUD hideHUD];
                [DBYProgressHUD showError:msg];
                
            }

        }];
    } else {
        
        if (self.roomID.length == 0) {
            [DBYProgressHUD hideHUD];
            [DBYProgressHUD showError:@"roomID为空，进入课程失败"];
            [self backButtonPressed];
            return;
        }
        
        [self.liveManager enterRoomWithRoomID:self.roomID uid:self.userID nickName:self.nickName userRole:DBYLiveManagerUserRoleTypeStudent completeHandler:^(NSString *errorMsg ,DBYLiveManagerEnterRoomErrorType error) {
            
            
            if (error == DBYLiveManagerEnterRoomErrorTypeNoError) {
                
            } else {
                NSString*msg = [DBYLiveManager enterRoomErrorMessageWithErrorType:error];
                [DBYProgressHUD hideHUD];
                [DBYProgressHUD showError:msg];
                
            }
        }];
    }
    
    
}
-(void)quitClassRoom
{
    [self.speakStateView clear];
    [self.liveManager quitClassRoomWithCompleteHandler:^{
        
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
    
    
    
    if (self.videoView.superview != self.pptBottomHideButton && self.videoView.superview) {
        [self.videoView removeFromSuperview];
        
        [self.pptBottomHideButton addSubview:self.videoView];
    }
    self.videoView.frame = CGRectMake(0,  self.pptView.frame.size.height*(1-0.4), self.pptView.frame.size.height*0.4 / 3 * 4, self.pptView.frame.size.height*0.4);
    self.videoFullScreenBtn.frame = self.videoView.bounds;
    self.videoFullScreenBtn.selected = NO;
    
    self.pptBottomHideButton.frame = self.pptView.bounds;
    
    self.pptBottomHideButton.hidden = NO;
    self.pptBottomHideButton.selected = NO;
    
    
    
    CGFloat playBackBottomViewHeight = 68;
    self.playbackBottomView.frame = CGRectMake(0, CGRectGetHeight(self.pptView.frame) - playBackBottomViewHeight, self.pptView.frame.size.width, playBackBottomViewHeight);
    self.playbackBottomView.hidden = NO;
    
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
    
    CGFloat chatButtonMargin = 12;
    CGFloat chatButtonW = 42;
    CGFloat chatButtonH = chatButtonW;
    CGFloat chatButtonX = self.view.frame.size.width - chatButtonW - chatButtonMargin;
    CGFloat chatButtonY = self.view.frame.size.height - chatButtonH - chatButtonMargin;
    self.chatButton.frame = CGRectMake(chatButtonX, chatButtonY, chatButtonW, chatButtonH);
    self.chatButton.hidden = NO;
    
    CGFloat raiseHandButtonW = chatButtonW;
    CGFloat raiseHandButtonH = chatButtonH;
    CGFloat raiseHandButtonX = chatButtonX;
    CGFloat raiseHandButtonY = chatButtonY - raiseHandButtonH - chatButtonMargin;
    self.raiseHandButton.frame = CGRectMake(raiseHandButtonX, raiseHandButtonY, raiseHandButtonW, raiseHandButtonH);
    self.raiseHandButton.hidden = self.isSpeaking;
    
    self.speakStateView.frame = self.raiseHandButton.frame;
    self.speakStateView.hidden = !self.isSpeaking;
    
    
    self.chatInputView.hidden = YES;
    self.chatInputView.frame  = CGRectMake(0, CGRectGetHeight(self.view.frame), self.view.frame.size.width, 112);
    
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
    
    
    if (self.videoView.superview != self.fullScreenHideButton && self.videoView.superview) {
        [self.videoView removeFromSuperview];
        
        [self.fullScreenHideButton addSubview:self.videoView];
    }
    
    
    self.videoView.frame = CGRectMake(pptViewX,  self.pptView.frame.size.height*(1-0.4), self.pptView.frame.size.height*0.4 / 3 * 4, self.pptView.frame.size.height*0.4);
    self.videoFullScreenBtn.frame = self.videoView.bounds;
    self.videoFullScreenBtn.selected = NO;
    
    
    self.playbackBottomView.hidden = YES;
    self.pptBottomHideButton.hidden = YES;
    
    self.chatView.hidden = YES;
    

    self.chatButton.hidden = YES;
    self.raiseHandButton.hidden = YES;
    self.speakStateView.hidden = YES;
    
    
    self.lineView.hidden = YES;
    self.selectView.hidden = YES;
    
    self.chatInputView.hidden = YES;
    [self.chatInputView endEdit];
    
    self.fullScreenHideButton.hidden = NO;
    self.fullScreenHideButton.frame = self.view.bounds;
    self.fullScreenHideButton.selected = YES;
    
    self.fullScreenNavView.hidden = NO;
    self.fullScreenNavView.frame = CGRectMake(0, 0, self.view.frame.size.width, 68);
    

    self.fullScreenBottomView.hidden = NO;
    self.fullScreenBottomView.frame = CGRectMake(0, self.view.frame.size.height - 68, self.view.frame.size.width, 68);
    
    
    
    
    
    if (self.firstToLandScape) {
        [self performSelector:@selector(hideFullScreenView) withObject:nil afterDelay:5];
        self.firstToLandScape = NO;
    }
}
#pragma mark - Notification methods
- (void)active:(NSNotification*)noti
{
    NSLog(@"active");
    
    if (self.liveManager) {
        [self.liveManager recoverLive];
    }
}
- (void)resignActive:(NSNotification*)noti
{
    NSLog(@"resignActive");
    
    if (self.liveManager) {
        [self.liveManager pauseLive];
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
-(void)keybordWillChangeFrame:(NSNotification*)noti
{
    NSDictionary*userInfo = noti.userInfo;
    
    float duration = [[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    
    CGFloat keybordHeight = 0;
    if ([userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"]) {
        keybordHeight =[[userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"]CGRectValue].size.height;
    } else {
         keybordHeight =[[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue].size.height;
    }
    
    CGFloat keybordEndY =0;
    if ([userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]) {
        keybordEndY = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue].origin.y;
    }
    
    CGRect chatInputViewFrame = self.chatInputView.frame;
    
    if (keybordEndY == self.view.frame.size.height) {
        //键盘收起
        chatInputViewFrame.origin.y = self.view.frame.size.height;
    } else {
        //键盘显示
        chatInputViewFrame.origin.y = self.view.frame.size.height - keybordHeight - chatInputViewFrame.size.height;
    }
    [UIView animateWithDuration:duration animations:^{
        self.chatInputView.frame = chatInputViewFrame;
        
        
    }];
}
#pragma mark - action methods

- (void)clickVideoFullScreenBtn:(UIButton*)btn
{
    if (!btn.isSelected) {
        
        if (self.videoView.superview == self.pptBottomHideButton) {
            self.videoView.frame = self.pptView.bounds;
            
        }
        if (self.videoView.superview == self.fullScreenHideButton) {
            self.videoView.frame = self.pptView.frame;
        }
        
    } else {
        if (self.videoView.superview == self.pptBottomHideButton) {
            self.videoView.frame = CGRectMake(0,  self.pptView.frame.size.height*(1-0.4), self.pptView.frame.size.height*0.4 / 3 * 4, self.pptView.frame.size.height*0.4);
        }
        
        if (self.videoView.superview == self.fullScreenHideButton) {
             self.videoView.frame = CGRectMake(self.pptView.frame.origin.x,  self.pptView.frame.size.height*(1-0.4), self.pptView.frame.size.height*0.4 / 3 * 4, self.pptView.frame.size.height*0.4);
        }
        
    }
    self.videoFullScreenBtn.frame = self.videoView.bounds;
    
    btn.selected = !btn.isSelected;
}
-(void)back
{
    NSLog(@"click back button");
    
    if (self.navigationController.viewControllers.count >= 2) {
        
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)clickHideFullScreen:(UIButton*)button
{
    //选中状态 隐藏全屏导航栏
    self.fullScreenBottomView.hidden = button.isSelected;
    self.fullScreenNavView.hidden  = button.isSelected;
    
    button.selected = !button.isSelected;
}
-(void)clickChatButton:(UIButton*)button
{
    
//    self.chatInputView.frame = CGRectMake(0, 0, self.chatInputView.frame.size.width, self.chatInputView.frame.size.height);
    [self.chatInputView beginEdit];
    self.chatInputView.hidden = NO;
}
-(void)clickRaiseHand:(UIButton*)button
{
    [DBYProgressHUD showMessage:@"发送举手请求"];
    button.enabled = NO;
    [self.liveManager requestRaiseHandWithCompleteHandler:^(NSString *errorMsg) {
        [DBYProgressHUD hideHUD];
        if (errorMsg.length) {
            [DBYProgressHUD showError:errorMsg];
            button.enabled = YES;
            return ;
        }
        [DBYProgressHUD showSuccess:@"已发送举手" toView:self.view];
    }];
    
}

-(void)clickPPTBottomViewHide:(UIButton*)button
{
    button.selected = !button.isSelected;
    self.playbackBottomView.hidden = button.isSelected;
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
#pragma mark - DBYChatInputViewDelegate
-(void)chatInputView:(DBYChatInputView *)chatInputView didClickSendWithMessage:(NSString *)msg
{
    [self.view endEditing:YES];
    [self.liveManager sendChatMessageWith:msg completeHandler:^(NSString *errorMsg) {
        if (errorMsg.length) {
            [DBYProgressHUD showError:errorMsg];
        } else {
            [chatInputView clearMsg];
        }
    }];
}
#pragma mark - DBYLiveManagerDelegate
-(void)liveManager:(DBYLiveManager *)manager hasChatMessageWithChatArray:(NSArray *)chatDictArray
{
    [self.allChatView reloadData];
    
    [self.selectView setButtonTitle:[NSString stringWithFormat:@"全部聊天(%lu)",(unsigned long)chatDictArray.count] atIndex:0];
    
}
-(void)liveManager:(DBYLiveManager *)manager teacherHasChatMessageWithChatArray:(NSArray *)chatDictArray
{
    [self.teacherChatView reloadData];
    [self.selectView setButtonTitle:[NSString stringWithFormat:@"只看老师(%lu)",(unsigned long)chatDictArray.count] atIndex:1];
}
-(void)liveManagerDidKickedOff:(DBYLiveManager *)manager
{
    [DBYProgressHUD showError:@"您被踢了"];
}
-(void)liveManagerSendChatFail:(DBYLiveManager *)manager
{
    [DBYProgressHUD showError:@"发送消息失败"];
}
-(void)liveManagerDidFailLoadPPT:(DBYLiveManager *)manager
{
    [DBYProgressHUD showError:@"打开ppt失败"];
}
-(void)liveManagerTeacherDownHands:(DBYLiveManager *)manager
{
    [DBYProgressHUD showMessage:@"老师取消举手" toView:self.view];
    //老师点击取消举手
    self.raiseHandButton.enabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DBYProgressHUD hideHUDForView:self.view];
    });
}
-(void)liveManager:(DBYLiveManager *)manager studentCanSpeak:(BOOL)canSpeak
{
    if (canSpeak) {
        //学生可以说话
        self.isSpeaking = YES;
        
        [self.speakStateView start];
    } else {
        self.isSpeaking = NO;
        [self.speakStateView stop];
    }
}
-(void)liveManager:(DBYLiveManager *)manager statusChangeWith:(DBYLiveManagerStatusType)statusType
{
    
}
-(void)liveManagerHasNetErrorWith:(DBYLiveManager *)manager
{
    
    self.isConnecting = YES;
    [DBYProgressHUD showMessage:@"网络不稳定，尝试重连"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DBYProgressHUD hideHUD];
        
        if (self.isConnecting) {
            UIAlertController*alertVC = [UIAlertController alertControllerWithTitle:@"连接失败" message:@"无法连接到网络，点击退出" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:action];
            
            [self presentViewController:alertVC animated:YES completion:NULL];
        }
    });
}

-(void)liveManagerNetOKWith:(DBYLiveManager *)manager
{
    self.isConnecting = NO;
    [DBYProgressHUD hideHUD];
//    [DBYProgressHUD showSuccess:@"连接恢复"];
}

-(void)liveManagerFirstConnectSucess:(DBYLiveManager *)manager
{
    self.isConnecting = NO;
    [DBYProgressHUD hideHUD];
    [DBYProgressHUD showSuccess:@"连接成功"];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.liveManager) {
        if (tableView == self.allChatView) {
            return self.liveManager.chatDictArray.count;
        }
        if (tableView == self.teacherChatView) {
            return  self.liveManager.teacherChatDictArray.count;
        }
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBYBaseChatTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:kDBYBaseChatTableViewCellReuseID];
    
    NSDictionary*chatDict;
    if (tableView == self.allChatView) {
//        chatDict = [self.liveManager.chatDictArray objectAtIndex:self.liveManager.chatDictArray.count - 1 - indexPath.row];
         chatDict = [self.liveManager.chatDictArray objectAtIndex:self.liveManager.chatDictArray.count - 1 - indexPath.row];
    }
    if (tableView == self.teacherChatView) {
        chatDict = [self.liveManager.teacherChatDictArray objectAtIndex:self.liveManager.teacherChatDictArray.count - 1 -indexPath.row];
    }
    
    
    DBYChatInfo*chatInfo = [DBYChatInfo chatInfoWithDict:chatDict];
    
    cell.chatInfo = chatInfo;
    
    
    return cell;
}
#pragma mark - setter
-(void)setIsSpeaking:(BOOL)isSpeaking
{
    _isSpeaking = isSpeaking;
    
    if ([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationPortrait) {
        self.speakStateView.hidden = !isSpeaking;
        self.raiseHandButton.hidden = isSpeaking;
        self.raiseHandButton.enabled = !isSpeaking;
    }
    
}
@end
