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
//课程安排
@property (nonatomic, strong) IBOutlet UIButton *courseIntroduceBtn;
//课程计划
@property (nonatomic, strong) IBOutlet UIButton *coursePlanBtn;
//老师安排
@property (nonatomic, strong) IBOutlet UIButton *teacherIntroduceBtn;
@property (nonatomic, strong) IBOutlet UIButton *BuyBtn;
@property (nonatomic, strong) IBOutlet UILabel *livePriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveBuyNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *liveLimitTimeLabel;
@property (nonatomic, strong) IBOutlet UIView *BuyBackView;
@property (weak, nonatomic) IBOutlet UIView *speatorView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

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
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIView *rightItems = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 57, 18)];
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
       contactButton.frame = CGRectMake(0.0f, 0.0f, 17.0f, 18.0f);
       [contactButton setImage:[UIImage imageNamed:@"zf"] forState:UIControlStateNormal];
       [contactButton addTarget:self action:@selector(zixunAction) forControlEvents:UIControlEventTouchUpInside];
       [contactButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [rightItems addSubview:contactButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(41.0f, 0.0f, 17.0f, 18.0f);
    [shareButton setImage:[UIImage imageNamed:@"shiti_icon_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [rightItems addSubview:shareButton];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItems];
    self.BuyBtn.layer.cornerRadius = 15;
    self.BuyBtn.layer.masksToBounds = YES;
    self.courseTitleLabel.text = self.liveModel.Name;
    self.coursePlanTimeLabel.text = [NSString stringWithFormat:@"%@至%@(%@课时)",self.liveModel.BegDate, self.liveModel.EndDate, self.liveModel.LCount];
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

    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.speatorView.mas_bottom);
        make.bottom.equalTo(self.BuyBackView.mas_top);
    }];
    
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

- (void)zixunAction{
    NSString *qq = @"3004628600";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]];
    }
    else
    {
        ZB_Toast(@"尚未检测到相关客户端，咨询失败");
    }
}
//课程介绍
- (IBAction)courseIntroduceBtnAction:(id)sender{
    self.courseIntroduceBtn.selected = YES;
   self.coursePlanBtn.selected = NO;
    self.teacherIntroduceBtn.selected = NO;
    self.lineView.xl_centerX = self.courseIntroduceBtn.xl_centerX;

    self.introduceWebViewHeight = nil;
    self.selectMainIndex = 0;
    [self.tableView reloadData];
}
//课程安排
- (IBAction)coursePlanBtnAction:(id)sender
{
    self.courseIntroduceBtn.selected = NO;
    self.coursePlanBtn.selected = YES;
     self.teacherIntroduceBtn.selected = NO;
     self.lineView.xl_centerX = self.coursePlanBtn.xl_centerX;
    self.selectMainIndex = 1;
    [self.tableView reloadData];
}
//老师介绍
- (IBAction)teacherIntroduceBtnAction:(id)sender
{
    self.courseIntroduceBtn.selected = NO;
    self.coursePlanBtn.selected = NO;
     self.teacherIntroduceBtn.selected = YES;
     self.lineView.xl_centerX = self.teacherIntroduceBtn.xl_centerX;
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
//设置网页地址
         NSString *webpageUrl = [NSString stringWithFormat:@"http://yk.yinhangzhaopin.com/bshWeb/liveclass/viewliveclass.jsp?LiveID=%@", self.liveModel.LID];
         RecruitMentShareViewController * shareVc = [RecruitMentShareViewController new];
        shareVc.hidesBottomBarWhenPushed = YES;

            shareVc.shareTitle = self.liveModel.Name;
            shareVc.shareDesTitle = @"考银行就用银行易考";
         shareVc.shareWebUrl = webpageUrl;
         [self.navigationController presentViewController:shareVc animated:YES completion:nil];
    
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
