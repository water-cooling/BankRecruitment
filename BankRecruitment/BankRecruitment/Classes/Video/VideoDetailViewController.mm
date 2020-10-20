//
//  VideoDetailViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "DailyPracticeViewController.h"
#import "ExaminationTitleModel.h"
#import "ExamDetailModel.h"
#import "DataBaseManager.h"

@interface VideoDetailViewController ()
@property (nonatomic, strong) IBOutlet UIButton *examButton;
@property (nonatomic, strong) IBOutlet UIButton *preVideoButton;
@property (nonatomic, strong) IBOutlet UIButton *nextVideoButton;
@property (nonatomic, strong) UIWebView* videoPlayer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *videoTitleLabel;
@property (nonatomic, strong) UIButton *videoDetailButton;
@property (nonatomic, assign) float bottonCenterY;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lineTopConstraint;
@property (nonatomic, assign) CGSize knowlegePointSize;
@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bottonCenterY = 0;
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    
//    [self modifyAllPointsImageWidth];
    [self drawViews];
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *ContactServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ContactServiceButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [ContactServiceButton setImage:[UIImage imageNamed:@"zhibo_btn_zixun"] forState:UIControlStateNormal];
    [ContactServiceButton addTarget:self action:@selector(ContactServiceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [shareButton setImage:[UIImage imageNamed:@"zf"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:shareButton],[[UIBarButtonItem alloc] initWithCustomView:ContactServiceButton]];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 320+(IS_iPhoneX?24:0), Screen_Width, Screen_Height-320-44-TabbarSafeBottomMargin)];
    self.scrollView.clipsToBounds = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.directionalLockEnabled = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self showVideoDetailViewByIndex];
    
    self.bottonCenterY = Screen_Height-4-35/2.-TabbarSafeBottomMargin;
    
    self.examButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 95, 35)];
    self.examButton.backgroundColor = UIColorFromHex(0xf23030);
    [self.examButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.examButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.examButton setTitle:@"试题测试" forState:UIControlStateNormal];
    self.examButton.layer.cornerRadius = 4;
    self.examButton.layer.masksToBounds = YES;
    [self.examButton addTarget:self action:@selector(examButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.examButton];
    self.examButton.center = CGPointMake(kScreenWidth/2, self.bottonCenterY);
    
    self.preVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 95, 40)];
    self.preVideoButton.backgroundColor = [UIColor colorWithHex:@"#F79B39"];
    [self.preVideoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.preVideoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.preVideoButton setTitle:@"上一个知识点" forState:UIControlStateNormal];
    self.preVideoButton.layer.cornerRadius = 20;
    self.preVideoButton.layer.masksToBounds = YES;
    [self.preVideoButton addTarget:self action:@selector(preVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.preVideoButton];
    self.preVideoButton.center = CGPointMake(kScreenWidth/2, self.bottonCenterY);
    
    self.nextVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 95, 40)];
    [self.nextVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextVideoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.nextVideoButton.backgroundColor = KColorBlueText;
    [self.nextVideoButton setTitle:@"下一个知识点" forState:UIControlStateNormal];
    self.nextVideoButton.layer.cornerRadius = 20;
    self.nextVideoButton.layer.masksToBounds = YES;
    [self.nextVideoButton addTarget:self action:@selector(nextVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextVideoButton];
    self.nextVideoButton.center = CGPointMake(kScreenWidth/2, self.bottonCenterY);
    
    VideoModel *currentModel = self.videolist[self.videoIndex];
    if(strIsNullOrEmpty(currentModel.EID))
    {
        self.examButton.hidden = YES;
        
        if(self.videolist.count == 1)
        {
            self.preVideoButton.hidden = YES;
            self.nextVideoButton.hidden = YES;
            return;
        }
        
        if(self.videoIndex==self.videolist.count-1)
        {
            self.nextVideoButton.hidden = YES;
            self.preVideoButton.center = CGPointMake(kScreenWidth*0.5, self.bottonCenterY);
        }
        else if(self.videoIndex==0)
        {
            self.preVideoButton.hidden = YES;
            self.nextVideoButton.center = CGPointMake(kScreenWidth*0.5, self.bottonCenterY);
        }
        else
        {
            self.preVideoButton.center = CGPointMake(kScreenWidth/4, self.bottonCenterY);
            self.nextVideoButton.center = CGPointMake(kScreenWidth*0.75, self.bottonCenterY);
        }
    }
    else
    {
        if(self.videolist.count == 1)
        {
            self.preVideoButton.hidden = YES;
            self.nextVideoButton.hidden = YES;
            self.examButton.center = CGPointMake(kScreenWidth/2, self.bottonCenterY);
            return;
        }
        
        if(self.videoIndex==self.videolist.count-1)
        {
            self.nextVideoButton.hidden = YES;
            self.examButton.center = CGPointMake(kScreenWidth/4, self.bottonCenterY);
            self.preVideoButton.center = CGPointMake(kScreenWidth*0.75, self.bottonCenterY);
        }
        else if(self.videoIndex==0)
        {
            self.preVideoButton.hidden = YES;
            self.examButton.center = CGPointMake(kScreenWidth/4, self.bottonCenterY);
            self.nextVideoButton.center = CGPointMake(kScreenWidth*0.75, self.bottonCenterY);
        }
        else
        {
            self.examButton.center = CGPointMake(kScreenWidth/6, self.bottonCenterY);
            self.preVideoButton.center = CGPointMake(kScreenWidth/2, self.bottonCenterY);
            self.nextVideoButton.center = CGPointMake(kScreenWidth-kScreenWidth/6, self.bottonCenterY);
        }
    }
    
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ContactServiceButtonPressed
{
        UIAlertController * alerView = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *phoneAler = [UIAlertAction actionWithTitle:@"电话号码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13770690067"]]];

            }];
    [phoneAler setValue:[UIColor colorWithHex:@"#333333"] forKey:@"_titleTextColor"];

        [alerView addAction:phoneAler];
        UIAlertAction *wechatAler = [UIAlertAction actionWithTitle:@"微信号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = @"13770690067";
                    ZB_Toast(@"微信号复制成功");
            }];
            [wechatAler setValue:[UIColor colorWithHex:@"#333333"] forKey:@"_titleTextColor"];

            [alerView addAction:wechatAler];
    UIAlertAction *qqAler = [UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *qq = @"3004628600";
                       if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]]) {
                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]];
                       }
                       else
                       {
                           ZB_Toast(@"尚未检测到相关客户端，咨询失败");
                       }
               }];
               [alerView addAction:qqAler];
    [qqAler setValue:[UIColor colorWithHex:@"#333333"] forKey:@"_titleTextColor"];

        UIAlertAction *  cancel  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                       
        }];
        [alerView addAction:cancel];
    [cancel setValue:[UIColor colorWithHex:@"#333333"] forKey:@"_titleTextColor"];
        [self.navigationController presentViewController:alerView animated:YES completion:nil];

}

- (void)refreshVideoDetailView:(NSMutableAttributedString *)attributeString{
    VideoModel *currentModel = self.videolist[self.videoIndex];
    self.title = currentModel.Name;
    
    [self.scrollView removeAllSubviews];
    float lastBottom = 0;
    //    for(NSInteger index=0; index<(self.videoIndex+1); index++)
    //    {
    VideoModel *model = self.videolist[self.videoIndex];
    
    UILabel* videoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, lastBottom+10, Screen_Width-39-17, 21)];
    videoTitleLabel.font = [UIFont systemFontOfSize:14];
    videoTitleLabel.textColor = kColorDarkText;
    videoTitleLabel.text = model.Name;
    [self.scrollView addSubview:videoTitleLabel];
    
    UIButton* videoDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(16, videoTitleLabel.bottom+8, Screen_Width-32, self.knowlegePointSize.height+8)];
    videoDetailButton.backgroundColor = UIColorFromHex(0xf1f9ff);
    videoDetailButton.titleLabel.numberOfLines = 0;
    videoDetailButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    [videoDetailButton setAttributedTitle:attributeString forState:UIControlStateNormal];
    [self.scrollView addSubview:videoDetailButton];
    videoDetailButton.layer.cornerRadius = 4;
    videoDetailButton.layer.masksToBounds = YES;
    
    lastBottom = videoDetailButton.bottom;
    //    }
    self.scrollView.contentSize = CGSizeMake(Screen_Width, lastBottom);
    
    
    if (!self.videoPlayer) {
        float videoHeight = 209;
        if(IS_IPAD){
            videoHeight = 209*2;
        }
        self.lineTopConstraint.constant = videoHeight+80+(IS_iPhoneX?24:0);
        
        self.scrollView.frame = CGRectMake(0, videoHeight+111+(IS_iPhoneX?24:0), Screen_Width, Screen_Height-(videoHeight+111)-44-TabbarSafeBottomMargin);
        
        self.videoPlayer = [[UIWebView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, videoHeight)];
        self.videoPlayer.backgroundColor = [UIColor blackColor];
        self.videoPlayer.scalesPageToFit = YES;
        [self.view addSubview:self.videoPlayer];
    }
    [self.videoPlayer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://my.polyv.net/front/video/preview?vid=%@", currentModel.AFile]]]];
}

- (void)showVideoDetailViewByIndex
{
    LL_WEAK_OBJC(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        VideoModel *model = weakself.videolist[weakself.videoIndex];
        
//        NSString *test = @"空瓶换水：题目条件已知几个空瓶子可以换一瓶水，现给出部分空瓶子，求最终可以喝到多少瓶水的问题。解题思路：<img width='91' height='11' src='file://C:UsersADMINI~1AppDataLocalTempksohtmlwps9C95.tmp.png' />N<span>个空瓶换</span><span>1</span><span>瓶水 <img src='http://120.26.198.113/upload/KindEditor/20180706/93642eeabc8742f89e7d3d9a2a5645e5.png' alt='' />               </span><span>N-1</span><span>个空瓶喝</span><span>1</span><span>份水</span> 。<br />";
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithData:[model.Points dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                             options:options
                                                                                  documentAttributes:nil
                                                                                               error:nil];
        [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [attributeString length])];
        [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8c9fb0) range:NSMakeRange(0, [attributeString length])];
        weakself.knowlegePointSize = [LdGlobalObj sizeWithAttributedString:attributeString width:Screen_Width-40];
        
        [weakself performSelectorOnMainThread:@selector(refreshVideoDetailView:) withObject:attributeString waitUntilDone:NO];
    });
}

- (void)shareAction:(id)sender{
    VideoModel *currentModel = self.videolist[self.videoIndex];

    NSString *webpageUrl =  [NSString stringWithFormat:@"http://my.polyv.net/front/video/preview?vid=%@", currentModel.AFile];
            RecruitMentShareViewController * shareVc = [RecruitMentShareViewController new];
               shareVc.shareTitle = currentModel.Name;
            shareVc.hidesBottomBarWhenPushed = YES;

               shareVc.shareDesTitle = @"考银行就用银行易考";
            shareVc.shareWebUrl = webpageUrl;
            [self.navigationController presentViewController:shareVc animated:YES completion:nil];
    
}



- (IBAction)examButtonAction:(id)sender
{
    VideoModel *currentModel = self.videolist[self.videoIndex];
    if([[DataBaseManager sharedManager] getExamOperationListByEID:currentModel.EID isFromIntelligent:@"否"])
    {
        NSArray *examList = [[DataBaseManager sharedManager] getExamDetailListByEID:currentModel.EID isFromIntelligent:@"否"];
        if(examList.count > 0)
        {
            DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.practiceList = [NSMutableArray arrayWithArray:examList];
            vc.title = self.title;
            vc.isSaveUserOperation = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [self NetworkGetExamTitlesByEID:currentModel.EID ExamTitle:@"视频"];
        }
    }
    else
    {
        [self NetworkGetExamTitlesByEID:currentModel.EID ExamTitle:@"视频"];
    }
    
}

- (IBAction)preVideoButtonAction:(id)sender
{
    self.videoPlayer = nil;
    self.videoIndex--;
    [self showVideoDetailViewByIndex];
    
    self.nextVideoButton.hidden = NO;
    self.preVideoButton.hidden = NO;
    self.examButton.center = CGPointMake(kScreenWidth/6, self.bottonCenterY);
    self.preVideoButton.center = CGPointMake(kScreenWidth/2, self.bottonCenterY);
    self.nextVideoButton.center = CGPointMake(kScreenWidth-kScreenWidth/6, self.bottonCenterY);
    
    VideoModel *currentModel = self.videolist[self.videoIndex];
    if(strIsNullOrEmpty(currentModel.EID))
    {
        if(self.videoIndex==0)
        {
            self.preVideoButton.hidden = YES;
            self.examButton.hidden = YES;
            self.nextVideoButton.center = CGPointMake(kScreenWidth*0.5, self.bottonCenterY);
        }
        else
        {
            self.preVideoButton.center = CGPointMake(kScreenWidth*0.25, self.bottonCenterY);
            self.nextVideoButton.center = CGPointMake(kScreenWidth*0.75, self.bottonCenterY);
        }
    }
    else
    {
        if(self.videoIndex==0)
        {
            self.preVideoButton.hidden = YES;
            self.examButton.center = CGPointMake(kScreenWidth/4, self.bottonCenterY);
            self.nextVideoButton.center = CGPointMake(kScreenWidth*0.75, self.bottonCenterY);
        }
    }
}

- (IBAction)nextVideoButtonAction:(id)sender
{
    self.videoPlayer = nil;
    self.videoIndex++;
    [self showVideoDetailViewByIndex];
    
    self.nextVideoButton.hidden = NO;
    self.preVideoButton.hidden = NO;
    self.examButton.center = CGPointMake(kScreenWidth/6, self.bottonCenterY);
    self.preVideoButton.center = CGPointMake(kScreenWidth/2, self.bottonCenterY);
    self.nextVideoButton.center = CGPointMake(kScreenWidth-kScreenWidth/6, self.bottonCenterY);
    
    VideoModel *currentModel = self.videolist[self.videoIndex];
    if(strIsNullOrEmpty(currentModel.EID))
    {
        if(self.videoIndex==self.videolist.count-1)
        {
            self.nextVideoButton.hidden = YES;
            self.examButton.hidden = YES;
            self.preVideoButton.center = CGPointMake(kScreenWidth*0.5, self.bottonCenterY);
        }
        else
        {
            self.preVideoButton.center = CGPointMake(kScreenWidth*0.25, self.bottonCenterY);
            self.nextVideoButton.center = CGPointMake(kScreenWidth*0.75, self.bottonCenterY);
        }
    }
    else
    {
        if(self.videoIndex==self.videolist.count-1)
        {
            self.nextVideoButton.hidden = YES;
            self.examButton.center = CGPointMake(kScreenWidth/4, self.bottonCenterY);
            self.preVideoButton.center = CGPointMake(kScreenWidth*0.75, self.bottonCenterY);
        }
    }
    
}

/*
 （1）<span>简单剪绳问题：初始一根绳子，则绳子的段数</span>=<span>切口数</span><span>+1</span><span>。</span>锯木头、爬楼梯、植树问题（两端不植树）<span>折绳剪绳问题</span> <span>：一根绳子对折</span>N<span>次，剪</span><span>M</span><span>刀，则绳子被剪成</span><img src='http://120.26.198.113/upload/KindEditor/20180706/8ba53d21aece41389cff1375828e1702.png' alt='' />段。
 */
- (void)modifyAllPointsImageWidth
{
    for(VideoModel *videoModel in self.videolist)
    {
        if(!strIsNullOrEmpty(videoModel.Points))
        {
            NSString *tempString = videoModel.Points;
            NSRange range1 = [tempString rangeOfString:@"src='"];
            NSRange range2 = [tempString rangeOfString:@"' />"];
            if(range1.length != 5)
            {
                continue;
            }
            NSString *imageUrl1 = [tempString substringWithRange:NSMakeRange(range1.location+5, range2.location-range1.location-5)];
            NSString *imageUrl1Pre = imageUrl1;
            tempString = [tempString substringFromIndex:range2.location+range2.length];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl1 = [imageUrl1 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            videoModel.Points = [videoModel.Points stringByReplacingOccurrencesOfString:imageUrl1Pre withString:imageUrl1];
            
            NSRange range3 = [tempString rangeOfString:@"src='"];
            NSRange range4 = [tempString rangeOfString:@"' />"];
            if(range3.length != 5)
            {
                continue;
            }
            NSString *imageUrl2 = [tempString substringWithRange:NSMakeRange(range3.location+5, range4.location-range3.location-5)];
            NSString *imageUrl2Pre = imageUrl2;
            tempString = [tempString substringFromIndex:range4.location+range4.length];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl2 = [imageUrl2 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            videoModel.Points = [videoModel.Points stringByReplacingOccurrencesOfString:imageUrl2Pre withString:imageUrl2];
            
            NSRange range5 = [tempString rangeOfString:@"src='"];
            NSRange range6 = [tempString rangeOfString:@"' />"];
            if(range5.length != 5)
            {
                continue;
            }
            NSString *imageUrl3 = [tempString substringWithRange:NSMakeRange(range5.location+5, range6.location-range5.location-5)];
            NSString *imageUrl3Pre = imageUrl3;
            tempString = [tempString substringFromIndex:range6.location+range6.length];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl3 = [imageUrl3 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            videoModel.Points = [videoModel.Points stringByReplacingOccurrencesOfString:imageUrl3Pre withString:imageUrl3];
        }
    }
}

#pragma -mark Network
/**
 根据试卷ID获取试题的标题列表
 
 @param EID 试卷ID
 */
- (void)NetworkGetExamTitlesByEID:(NSString *)EID ExamTitle:(NSString *)title
{
    [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetExamTitleByEID:EID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *titleList = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    ExaminationTitleModel *model = [ExaminationTitleModel model];
                    [model setDataWithDic:dict];
                    [titleList addObject:model];
                }
                
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
                for(ExaminationTitleModel *model in titleList)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
                    [list addObject:dict];
                }
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:title];
                return;
            }
        }
        [SVProgressHUD dismiss];
        ZB_Toast(@"没有找到试卷");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList ExamTitle:(NSString *)title
{
    [LLRequestClass requestGetExamDetailsByTitleList:titleList Success:^(id jsonData) {
        NSDictionary *contentDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        NSString *result = contentDict[@"result"];
        if([result isEqualToString:@"success"])
        {
            NSArray *array = contentDict[@"list"];
            NSMutableArray *examList = [NSMutableArray arrayWithCapacity:9];
            for(NSDictionary *dict in array)
            {
                ExamDetailModel *model = [ExamDetailModel model];
                [model setDataWithDic:dict];
                [examList addObject:model];
            }
            
            if(examList.count > 0)
            {
                DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.title = title;
                vc.isSaveUserOperation = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [SVProgressHUD dismiss];
                ZB_Toast(@"没有找到试题");
            }
            return;
        }
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

@end
