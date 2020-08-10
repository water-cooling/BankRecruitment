//
//  DBY1V1LiveTestViewController.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/2/9.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBY1V1LiveTestViewController.h"
#import "DBYLiveManager.h"
#import "DBYProgressHUD+NJ.h"

@interface DBY1V1LiveTestViewController ()<DBYLiveManagerDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *pptView;
@property (weak, nonatomic) IBOutlet UIView *teacherView;
@property (weak, nonatomic) IBOutlet UIView *studentView;
@property (weak, nonatomic) IBOutlet UITableView *chatView;

@property(nonatomic,strong)DBYLiveManager* liveManager;
@end

@implementation DBY1V1LiveTestViewController
- (IBAction)clickResize:(id)sender {
    
//    self.studentView.frame = CGRectMake(0, 0, 160, 120);
    
//    [self.liveManager resizeCapturePreviewView];
    
    [self.liveManager setVideoOrientationWith:AVCaptureVideoOrientationLandscapeLeft];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"1V1";
    
//    self.liveManager = [[DBYLiveManager alloc]initWithPartnerId:@"20170413113446324332" withAppKey:@"7c90745eee8841b692fbaea6d9929b38"];
    self.liveManager = [[DBYLiveManager alloc]initWithPartnerId:@"20160823094027463138" withAppKey:@"befea096785949f4bd309bc4eea9c7fe"];
    
//    self.liveManager = [[DBYLiveManager alloc]initWithPartnerId:@"20170331213217324284" withAppKey:@"16f1e3890ad84ad4baebac5716a27617"];
    
    self.liveManager.delegate = self;
    
    [self.liveManager setTeacherViewWith:self.teacherView];
    
    [self.liveManager setStudentViewWith:self.studentView];
    
    [self.liveManager setPPTViewWithView:self.pptView];
    
    [self.liveManager setDrawLineWidthWith:2];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(active:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    UIBarButtonItem*backItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber *value;
    value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];

//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //设置课程类型
    self.liveManager.classRoomType = DBYLiveManagerClassRoomType1V1;
    
    
    
    [self.liveManager enterRoomWithRoomID:@"jz8b7849c468504a3a8cc25863b83aa5bd" uid:@"17720206406" nickName:@"Joe" userRole:DBYLiveManagerUserRoleTypeStudent completeHandler:^(NSString *errorMsg, DBYLiveManagerEnterRoomErrorType error) {
        NSLog(@"%@",errorMsg);
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    

    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.liveManager quitClassRoomWithCompleteHandler:^{
        
    }];
}

-(void)back:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


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

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.liveManager) {
        return self.liveManager.chatDictArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"chat"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"chat"];
    }
    
    if (self.liveManager) {
        NSDictionary*chatDict = [self.liveManager.chatDictArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",chatDict[@"userName"],chatDict[@"message"]];
    }
    return cell;
}
#pragma mark - DBYLiveManagerDelegate
-(void)liveManager:(DBYLiveManager *)manager hasChatMessageWithChatArray:(NSArray *)chatDictArray
{
    [self.chatView reloadData];
}
-(void)liveManager:(DBYLiveManager *)manager statusChangeWith:(DBYLiveManagerStatusType)statusType
{
    
}
-(void)liveManagerDidKickedOff:(DBYLiveManager *)manager
{
    NSLog(@"被踢了-----------");
}
-(void)liveManager:(DBYLiveManager *)manager didChooseIpAddress:(NSString *)ipAddress
{
    NSLog(@"---------------%@",ipAddress);
}
-(void)liveManagerDidAuthInfoSuccess:(DBYLiveManager *)manager
{
    NSLog(@"-----");
}

@end
