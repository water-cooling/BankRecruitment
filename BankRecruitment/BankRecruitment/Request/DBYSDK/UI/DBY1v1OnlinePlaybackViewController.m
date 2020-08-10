//
//  DBY1v1OnlinePlaybackViewController.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 2017/8/31.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBY1v1OnlinePlaybackViewController.h"

#import "DBYPlaybackBottomView.h"

#import "DBYOnlinePlayBackManager.h"

#import "DBYProgressHUD+NJ.h"

#import "DBYBaseChatTableViewCell.h"

#import "DBYChatInfo.h"

@interface DBY1v1OnlinePlaybackViewController ()<UITableViewDelegate,UITableViewDataSource,DBYOnlinePlayBackManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *pptView;
@property (weak, nonatomic) IBOutlet DBYPlaybackBottomView *playbackBottomView;
@property (weak, nonatomic) IBOutlet UIView *studentView;
@property (weak, nonatomic) IBOutlet UIView *teacherView;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;


@property(nonatomic,strong)DBYOnlinePlayBackManager*playbackManager;
@end

@implementation DBY1v1OnlinePlaybackViewController
-(BOOL)shouldAutorotate
{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.playbackBottomView setFullScreenButtonHidden:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(active:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    self.playbackManager = [[DBYOnlinePlayBackManager alloc]initWithPartnerID:self.partnerID appKey:self.appkey];
    
    
    [self.playbackManager setPPTViewWithView:self.pptView];
    [self.playbackManager setStudentViewWith:self.studentView];
    [self.playbackManager setTeacherViewWith:self.teacherView];
    
    self.playbackManager.delegate = self;
    
    
    __weak typeof(self) weakSelf = self;
    self.playbackBottomView.beginPanHandler = ^(float progress){
        
    };
    self.playbackBottomView.endPanHandler = ^(float progress){
        
        [DBYProgressHUD showMessage:@"loading"];
        NSTimeInterval seekTime = weakSelf.playbackManager.totalTime*progress;
        
        [weakSelf.playbackBottomView setPlayButtonStateWith:NO];
        
        [weakSelf.playbackManager seekToTimeWith:seekTime completeHandler:^(NSString *errorMsg) {
            [DBYProgressHUD hideHUD];
            if (errorMsg.length) {
                [DBYProgressHUD showError:errorMsg];
            } else {
                [weakSelf.playbackBottomView setPlayButtonStateWith:YES];
            }
        }];
    };
    self.playbackBottomView.clickPlayButtonHandler = ^(BOOL isPlaying) {
        if (isPlaying) {
            [weakSelf.playbackManager resumePlay];
        } else {
            [weakSelf.playbackManager pausePlay];
        }
    };

    
    [self.chatTableView registerClass:[DBYBaseChatTableViewCell class] forCellReuseIdentifier:kDBYBaseChatTableViewCellReuseID];
    self.chatTableView.rowHeight = kDBYBaseChatTableViewCellHeight;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [DBYProgressHUD showMessage:@"loading"];
    
    [self.playbackManager startPlaybackWithRoomID:self.roomID uid:self.uid userName:self.nickName userRole:2 startTime:0 seekTime:0 completeHandler:^(NSString *error, DBYOnlinePlayBackManagerStartPlayBackErrorType errorCode) {
        [DBYProgressHUD hideHUD];
        if (errorCode != DBYOnlinePlayBackManagerStartPlayBackErrorTypeNoError) {
            //失败 设置播放按妞
            [self.playbackBottomView setPlayButtonStateWith:NO];
            
            [DBYProgressHUD showError:error];
        } else {
            [self.playbackBottomView setPlayButtonStateWith:YES];
        }
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self quitClassRoom];
}
-(void)quitClassRoom
{
    
    self.playbackManager.delegate = nil;
    
    [self.playbackManager stopPlayWithCompleteHandler:^{
        
    }];
}
#pragma mark - Notification methods
- (void)active:(NSNotification*)noti
{
    NSLog(@"active");
    
    if (self.playbackManager) {
        [self.playbackManager pausePlay];
    }
}
- (void)resignActive:(NSNotification*)noti
{
    NSLog(@"resignActive");
    
    if (self.playbackManager) {
        [self.playbackManager resumePlay];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.playbackManager) {
        if (tableView == self.chatTableView) {
            return self.playbackManager.chatDictArray.count;
        }
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBYBaseChatTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:kDBYBaseChatTableViewCellReuseID];
    
    NSDictionary*chatEventInfo;
    if (tableView == self.chatTableView) {
        chatEventInfo = [self.playbackManager.chatDictArray objectAtIndex:self.playbackManager.chatDictArray.count - 1 - indexPath.row];
    }
    
    DBYChatInfo*chatInfo = [DBYChatInfo chatInfoWithDict:chatEventInfo];
    cell.chatInfo = chatInfo;
    
    
    return cell;
}
#pragma mark - DBYOnlinePlayBackManagerDelegate
-(void)playBackManager:(DBYOnlinePlayBackManager *)manager playedAtTime:(NSTimeInterval)time
{
    //设置当前时间
    [self.playbackBottomView setProgressWith:time/manager.totalTime];
    [self.playbackBottomView setCurrentTimeLabelWithTime:time];
}
-(void)playBackManager:(DBYOnlinePlayBackManager *)manager totalTime:(NSTimeInterval)time
{
    //设置总时间
    [self.playbackBottomView setTotalTimeLabelWithTime:time];
}
-(void)playbackManagerDidPlayEnd:(DBYOnlinePlayBackManager *)manager
{
    [self.playbackBottomView setPlayButtonStateWith:NO];
}
-(void)playBackManagerDidDuplicateLogin:(DBYOnlinePlayBackManager *)manager
{
    [DBYProgressHUD showError:@"您被踢了"];
}
-(void)playbackManager:(DBYOnlinePlayBackManager *)manager hasChatMessageWithChatArray:(NSArray *)chatDictArray
{
    [self.chatTableView reloadData];
}

@end
