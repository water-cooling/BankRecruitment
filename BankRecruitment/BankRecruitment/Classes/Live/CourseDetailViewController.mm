//
//  CourseDetailViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CalendarTableViewCell.h"
#import "TeacherIntroduceTableViewCell.h"
#import "CourseIntroduceTableViewCell.h"
#import "LiveTecherModel.h"
#import "LiveClassScheduleModel.h"
#import "UIImageView+WebCache.h"
#import "BBAlertView.h"

@interface CourseDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UILabel *courseTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *coursePlanTimeLabel;
@property (nonatomic, strong) IBOutlet UIButton *collectionBtn;
@property (nonatomic, strong) IBOutlet UIButton *courseIntroduceBtn;
@property (nonatomic, strong) IBOutlet UIButton *coursePlanBtn;
@property (nonatomic, strong) IBOutlet UIButton *teacherIntroduceBtn;
@property (nonatomic, strong) IBOutlet UIButton *BuyBtn;
@property (nonatomic, strong) IBOutlet UILabel *livePriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveBuyNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveLimitTimeLabel;
@property (nonatomic, strong) IBOutlet UIView *BuyBackView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectMainIndex;
@property (nonatomic, strong) NSMutableArray *scheduleList;
@property (nonatomic, strong) NSMutableArray *teacherList;
@property (nonatomic, strong) NSMutableDictionary *teacherWebHeightDict;
@property (nonatomic, strong) NSNumber *introduceWebViewHeight;
@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.selectMainIndex = 0;
    self.scheduleList = [NSMutableArray arrayWithCapacity:9];
    self.teacherList = [NSMutableArray arrayWithCapacity:9];
    self.teacherWebHeightDict = [NSMutableDictionary dictionaryWithCapacity:9];
    [self drawViews];
    
    [self NetworkGetLiveScheduleList];
    [self NetworkGetLiveTecherInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if(self.liveModel.Price.floatValue == 0)
//    {
//        self.BuyBackView.hidden = YES;
//        self.tableView.height+=44;
//        [self.tableView reloadData];
//        
//        [self NetworkSendZeroPaySuccessByLinkID:self.liveModel.LID Abstract:self.liveModel.Name];
//    }
//    else
//    {
        [self NetworkGetDoIsPayByidByIsBuying:NO];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self courseIntroduceBtnAction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"课程详情";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [shareButton setImage:[UIImage imageNamed:@"shiti_icon_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    UIView *uplineView = [[UIView alloc] initWithFrame:CGRectMake(0, 161-18+(IS_iPhoneX?24:0), Screen_Width, 0.5)];
    uplineView.backgroundColor = kColorLineSepBackground;
    [self.view addSubview:uplineView];
    
    UIView *downlineView = [[UIView alloc] initWithFrame:CGRectMake(0, (161+27)+18+(IS_iPhoneX?24:0), Screen_Width, 0.5)];
    downlineView.backgroundColor = kColorLineSepBackground;
    [self.view addSubview:downlineView];
    
    self.BuyBtn.layer.cornerRadius = 3;
    self.BuyBtn.layer.masksToBounds = YES;
    
    self.courseIntroduceBtn.titleLabel.backgroundColor = [UIColor clearColor];
    self.courseIntroduceBtn.layer.cornerRadius = 13.5;
    self.courseIntroduceBtn.layer.masksToBounds = YES;
    
    self.coursePlanBtn.titleLabel.backgroundColor = [UIColor clearColor];
    self.coursePlanBtn.layer.cornerRadius = 13.5;
    self.coursePlanBtn.layer.masksToBounds = YES;
    
    self.teacherIntroduceBtn.titleLabel.backgroundColor = [UIColor clearColor];
    self.teacherIntroduceBtn.layer.cornerRadius = 13.5;
    self.teacherIntroduceBtn.layer.masksToBounds = YES;
    
    self.courseIntroduceBtn.backgroundColor = kColorNavigationBar;
    [self.courseIntroduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.coursePlanBtn.backgroundColor = [UIColor whiteColor];
    [self.coursePlanBtn setTitleColor:kColorDarkText forState:UIControlStateNormal];
    self.teacherIntroduceBtn.backgroundColor = [UIColor whiteColor];
    [self.teacherIntroduceBtn setTitleColor:kColorDarkText forState:UIControlStateNormal];
    
    self.courseTitleLabel.text = self.liveModel.Name;
    self.coursePlanTimeLabel.text = [NSString stringWithFormat:@"课程安排：%@至%@(%@课时)",self.liveModel.BegDate, self.liveModel.EndDate, self.liveModel.LCount];
    self.livePriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.liveModel.Price.floatValue];
    self.liveBuyNumberLabel.text = [NSString stringWithFormat:@"参与人数 %@",self.liveModel.PurchCount];
    int endNumber = dateNumberFromDateToToday(self.liveModel.EndDate);
    if(endNumber>0)
    {
        self.liveLimitTimeLabel.text = [NSString stringWithFormat:@"距停售时间还有%d天",endNumber];
    }
    else
    {
        self.liveLimitTimeLabel.text = @"已停售";
    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, downlineView.bottom, Screen_Width, Screen_Height-downlineView.bottom-44-TabbarSafeBottomMargin)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)zixunAction:(id)sender{
    NSString *qq = @"3004628600";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]];
    }
    else
    {
        ZB_Toast(@"尚未检测到相关客户端，咨询失败");
    }
}

- (IBAction)courseIntroduceBtnAction:(id)sender
{
    self.courseIntroduceBtn.backgroundColor = kColorNavigationBar;
    [self.courseIntroduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.coursePlanBtn.backgroundColor = [UIColor whiteColor];
    [self.coursePlanBtn setTitleColor:kColorDarkText forState:UIControlStateNormal];
    self.teacherIntroduceBtn.backgroundColor = [UIColor whiteColor];
    [self.teacherIntroduceBtn setTitleColor:kColorDarkText forState:UIControlStateNormal];
    
    self.introduceWebViewHeight = nil;
    self.selectMainIndex = 0;
    [self.tableView reloadData];
}

- (IBAction)coursePlanBtnAction:(id)sender
{
    self.courseIntroduceBtn.backgroundColor = [UIColor whiteColor];
    [self.courseIntroduceBtn setTitleColor:kColorDarkText forState:UIControlStateNormal];
    self.coursePlanBtn.backgroundColor = kColorNavigationBar;
    [self.coursePlanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.teacherIntroduceBtn.backgroundColor = [UIColor whiteColor];
    [self.teacherIntroduceBtn setTitleColor:kColorDarkText forState:UIControlStateNormal];
    
    self.selectMainIndex = 1;
    [self.tableView reloadData];
}

- (IBAction)teacherIntroduceBtnAction:(id)sender
{
    self.courseIntroduceBtn.backgroundColor = [UIColor whiteColor];
    [self.courseIntroduceBtn setTitleColor:kColorDarkText forState:UIControlStateNormal];
    self.coursePlanBtn.backgroundColor = [UIColor whiteColor];
    [self.coursePlanBtn setTitleColor:kColorDarkText forState:UIControlStateNormal];
    self.teacherIntroduceBtn.backgroundColor = kColorNavigationBar;
    [self.teacherIntroduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.selectMainIndex = 2;
    [self.teacherWebHeightDict removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)buyAction:(id)sender
{
    if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
    {
        if(self.liveModel.Price.floatValue == 0)
        {
            [self NetworkSendZeroPaySuccessByLinkID:self.liveModel.LID Abstract:self.liveModel.Name];
        }
        else
        {
            [[LdGlobalObj sharedInstanse] payActionByType:@"直播课" payID:self.liveModel.LID];
            [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
                [self paySuccessAction];
            };
        }
        
    }
    else
    {
        BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"直接购买，会为当前设备购买直播课；您可以去我的页面先注册再购买" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"游客身份购买"];
        LL_WEAK_OBJC(self);
        [alertView setConfirmBlock:^{
            if(weakself.liveModel.Price.floatValue == 0)
            {
                [weakself NetworkSendZeroPaySuccessByLinkID:weakself.liveModel.LID Abstract:weakself.liveModel.Name];
            }
            else
            {
                [[LdGlobalObj sharedInstanse] payActionByType:@"直播课" payID:weakself.liveModel.LID];
                [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
                    [weakself paySuccessAction];
                };
            }
        }];
        [alertView show];
    }
    
}

- (void)paySuccessAction
{
    if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
    {
        ZB_Toast(@"购买成功，请到我的课程中查看");
    }
    else
    {
        ZB_Toast(@"购买成功，请到我的页面登录或注册，迁移权益");
    }
    
    self.BuyBackView.hidden = YES;
    self.tableView.height+=44;
    [self.tableView reloadData];
}

- (void)shareAction:(id)sender
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareToPlatformType:platformType];
    }];
}

- (void)shareToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.liveModel.Name descr:@"考银行就用银行易考！" thumImage:[UIImage imageNamed:@"shareIcon.png"]];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://yk.yinhangzhaopin.com/bshWeb/liveclass/viewliveclass.jsp?LiveID=%@", self.liveModel.LID];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            ZB_Toast(@"分享失败");
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            ZB_Toast(@"分享成功");
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
    footerView.backgroundColor = kColorBarGrayBackground;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectMainIndex == 0)
    {
        if(self.introduceWebViewHeight)
        {
            return self.introduceWebViewHeight.floatValue;
        }
        else
        {
            return 40;
        }
    }
    else if(self.selectMainIndex == 1)
    {
        return 70;
    }
    else
    {
        NSNumber *webheight = self.teacherWebHeightDict[[NSNumber numberWithInteger:indexPath.row]];
        if(webheight)
        {
            return webheight.floatValue+57;
        }
        else
        {
            return 100;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selectMainIndex == 0)
    {
        return 1;
    }
    else if(self.selectMainIndex == 1)
    {
        return self.scheduleList.count;
    }
    else
    {
        return self.teacherList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectMainIndex == 0)
    {
        CourseIntroduceTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, CourseIntroduceTableViewCell, @"CourseIntroduceTableViewCell");
        
        NSString *html = [NSString stringWithFormat:@"<html> \n"
         "<head> \n"
         "<style type=\"text/css\"> \n"
         "body {font-size:15px;}\n"
         "</style> \n"
         "</head> \n"
         "<body>"
         "<script type='text/javascript'>"
         "window.onload = function(){\n"
         "var $img = document.getElementsByTagName('img');\n"
         "for(var p in  $img){\n"
         " $img[p].style.width = '100%%';\n"
         "$img[p].style.height ='auto'\n"
         "}\n"
         "}"
         "</script>%@"
         "</body>"
         "</html>",self.liveModel.AllScreen];
        [loc_cell.webView loadHTMLString:html baseURL:nil];
        if(!self.introduceWebViewHeight)
        {
            loc_cell.courseIntroduceWebViewHeightRefreshBlock = ^(float height){
                self.introduceWebViewHeight = [NSNumber numberWithFloat:height];
                [self.tableView reloadData];
            };
        }
        return loc_cell;
    }
    else if (self.selectMainIndex == 1)
    {
        CalendarTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, CalendarTableViewCell, @"CalendarTableViewCell");
        loc_cell.accessoryType = UITableViewCellAccessoryNone;
        LiveClassScheduleModel *model = self.scheduleList[indexPath.row];
        loc_cell.calendarTitleLabel.text = model.Intro;
        NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDateFormatter* dateFmt1 = [[NSDateFormatter alloc] init];
        dateFmt1.dateFormat = @"HH:mm";
//        NSDate *BegDate = [dateFmt dateFromString:model.BegDate];
        NSDate *EndDate = [dateFmt dateFromString:model.EndDate];
        loc_cell.calendarTimeLabel.text = [NSString stringWithFormat:@"%@-%@",model.BegDate, [dateFmt1 stringFromDate:EndDate]];
        loc_cell.lineView.backgroundColor = kColorLineSepBackground;
        return loc_cell;
    }
    else
    {
        TeacherIntroduceTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, TeacherIntroduceTableViewCell, @"TeacherIntroduceTableViewCell");
        LiveTecherModel *model = self.teacherList[indexPath.row];
        [loc_cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp, model.TecheAFile]] placeholderImage:kDefaultSquareImage];
        loc_cell.teacherNameLabel.text = model.TecheName;
        loc_cell.index = indexPath.row;
        
        NSString *resume = model.Resume;
        resume = [resume stringByReplacingOccurrencesOfString:@"<img" withString:@"<img  width='100%' "];
        [loc_cell.teacherDetailWebView loadHTMLString:resume baseURL:nil];
        NSNumber *webheight = self.teacherWebHeightDict[[NSNumber numberWithInteger:indexPath.row]];
        if(!webheight)
        {
            loc_cell.teacherIntroduceWebViewHeightRefreshBlock = ^(float height, int index){
                [self.teacherWebHeightDict setObject:[NSNumber numberWithFloat:height] forKey:[NSNumber numberWithFloat:index]];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
        }
        return loc_cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma -mark Network
//获取直播课课程表
- (void)NetworkGetLiveScheduleList
{
    [LLRequestClass requestGetLiveScheduleListByLID:self.liveModel.LID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                for(NSDictionary *dict in contentArray)
                {
                    LiveClassScheduleModel *model = [LiveClassScheduleModel model];
                    [model setDataWithDic:dict];
                    [self.scheduleList addObject:model];
                }
            }
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

// 获取直播课老师信息
- (void)NetworkGetLiveTecherInfo
{
    [self.teacherList removeAllObjects];
    [LLRequestClass requestGetLiveTecherInfoByLID:self.liveModel.LID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                for(NSDictionary *dict in contentArray)
                {
                    LiveTecherModel *model = [LiveTecherModel model];
                    [model setDataWithDic:dict];
                    [self.teacherList addObject:model];
                }
            }
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

- (void)NetworkGetDoIsPayByidByIsBuying:(BOOL)buyFlag
{
    [LLRequestClass requestGetDoIsPayByid:self.liveModel.LID type:@"直播课" Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.BuyBackView.hidden = YES;
                self.tableView.height+=44;
                [self.tableView reloadData];
                return;
            }
            else
            {
                self.BuyBackView.hidden = NO;
            }
        }
        
//        int endNumber = dateNumberFromDateToToday(self.liveModel.EndDate);
//        if(endNumber<=0)
//        {
//            self.BuyBackView.hidden = YES;
//            self.tableView.height+=44;
//            [self.tableView reloadData];
//            
//            [self NetworkSendZeroPaySuccessByLinkID:self.liveModel.LID Abstract:self.liveModel.Name];
//        }
        
        if(buyFlag)
        {
            if(self.BuyBackView.hidden)
            {
                ZB_Toast(@"已购买");
            }
            else
            {
                [self buyAction:nil];
            }
        }
        
    } failure:^(NSError *error) {
    }];
}

/**
 提交支付信息  价格为零时，添加到已购买的数据库
 */
- (void)NetworkSendZeroPaySuccessByLinkID:(NSString *)LinkID Abstract:(NSString *)Abstract
{
    [LLRequestClass requestSendZeroPaySuccessByLinkID:LinkID PType:@"直播课" Abstract:Abstract Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self paySuccessAction];
                return;
            }
        }
    } failure:^(NSError *error) {
        ZB_Toast(@"失败");
    }];
}

@end
