//
//  FirstpageViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/27.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "FirstpageViewController.h"
#import "MJRefresh.h"
#import "FirstPageHeadTableViewCell.h"
#import "FirstpageModulesTableViewCell.h"
#import "CourseCalendarViewController.h"
#import "WrongQuestionsViewController.h"
#import "DailyPracticeViewController.h"
#import "MockExamContestViewController.h"
#import "QuestionTableViewCell.h"
#import "CollectionQuestionViewController.h"
#import "NoteQuestionViewController.h"
#import "ExerciseHositoryViewController.h"
#import "ErrorAnalysisViewController.h"
#import "OutlineModel.h"
#import "ExaminationTitleModel.h"
#import "ExamDetailModel.h"
#import "FirstAdModel.h"
#import "SpecialExercisesViewController.h"
#import "ExaminationPaperViewController.h"
#import "DataReportViewController.h"
#import "SearchTitleViewController.h"
#import "MineMessageViewController.h"
#import "RemoteMessageModel.h"
#import "EveryDayExamTableViewCell.h"
#import "WebViewController.h"
#import "ZhaopinViewController.h"
#import "DataBaseManager.h"
#import "NewsViewController.h"
#import "FirstPageAdScrollTableViewCell.h"
#import "HomeVideoListTableViewCell.h"
#import "LianxiHisViewController.h"
#import "BBAlertView.h"
#import "InformationViewController.h"
#import "FirstpageModule.h"
#import "InviteTableViewCell.h"
#import "VideoTypeModel.h"
#import "VideoViewController.h"
#import "SignViewController.h"
#import "InviteJobModel.h"
#import <WebKit/WebKit.h>
#import "WebViewController.h"
#import "HomeVideoViewController.h"
#define kHeadScrollHeight 150

@interface FirstpageViewController ()<UITableViewDelegate, UITableViewDataSource, FirstTableCellHeadFunctionBtnFunc, FirstpageModulesFunctionBtnFunc, UISearchBarDelegate, UIWebViewDelegate, WSPageViewDataSource, WSPageViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, copy) NSMutableArray *moduleList;//首页的8个图标
@property (nonatomic, strong) NSMutableArray *typeList;//获取视频list
@property (nonatomic, strong) NSMutableArray *inviteJobList;//获取招聘list
@property (nonatomic, assign) NSInteger tempOutLineCellNumber;
@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong)  dispatch_queue_t queue;
@property (nonatomic, strong) UIButton *signBtn;

@end

@implementation FirstpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.group = dispatch_group_create();
       self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    [self drawViews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorBarGrayBackground;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self setupTableViewRefresh];
    [self.view addSubview:self.signBtn];
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).offset(-5);
        make.width.mas_equalTo(43);
        make.height.mas_equalTo(43);
    }];
    [self getNetWork];
}

-(void)getNetWork{
    dispatch_group_async(self.group, self.queue, ^{
                [self NetworkGetFavoriteType];
    });
    dispatch_group_async(self.group, self.queue, ^{
            [self NetworkGetFirstExaminPaper];
       });
    
    dispatch_group_async(self.group, self.queue, ^{
                 [self NetworkGetAllAdByIndex:9999];
    });
    dispatch_group_async(self.group, self.queue, ^{
            [self requestdoGetApplication];
    });
    dispatch_group_async(self.group, self.queue, ^{
              [self NetworkGetFirstPageModule];
        });
    dispatch_group_async(self.group, self.queue, ^{
                [self NetworkGetVideoTypes];
        });
      dispatch_group_notify(self.group, self.queue, ^{
          dispatch_async(dispatch_get_main_queue(), ^{
              [self endTableRefreshing];
              [self.tableView reloadData];
          });
      });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIColor colorWithHex:@"#FFFFFF"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews{
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-120, 25)];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBtn.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
    searchBtn.layer.cornerRadius = 12.5;
    [searchBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索题目" forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    searchBtn.layer.cornerRadius = 6;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchBtn;
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_search"]];
    searchImageView.frame = CGRectMake(6, 0, 15, 15);
    [searchBtn addSubview:searchImageView];
    searchImageView.centerY = searchBtn.centerY;
    
    float offset = 0;
    if(iPhone6||iPhone5){
        offset = 3.f;
    }else if(iPhone6Plus){
        offset = 5.f;
    }else if(IS_iPhoneX){
        offset = 3.f;
    }else if(IS_IPAD){
        offset = 8.f;
    }
    
    UIView *ContactServiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 40)];
    UILabel *ContactServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(-offset, 30, 34, 10)];
    ContactServiceLabel.backgroundColor = [UIColor clearColor];
    ContactServiceLabel.textColor = [UIColor whiteColor];
    ContactServiceLabel.font = [UIFont systemFontOfSize:10];
    ContactServiceLabel.textAlignment = NSTextAlignmentCenter;
    ContactServiceLabel.text = @"客服";
    [ContactServiceView addSubview:ContactServiceLabel];
    
    UIButton *ContactServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ContactServiceButton.frame = CGRectMake(7.0f-offset, 5.0f, 20.0f, 20.0f);
    [ContactServiceButton setImage:[UIImage imageNamed:@"zhibo_btn_zixun"] forState:UIControlStateNormal];
    [ContactServiceButton addTarget:self action:@selector(ContactServiceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [ContactServiceView addSubview:ContactServiceButton];
    
    UIBarButtonItem *ContactServiceViewBar = [[UIBarButtonItem alloc] initWithCustomView:ContactServiceView];
    
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer1.width = -7;
    if(IS_IPAD||IS_IOS9||IS_IOS10){
        self.navigationItem.leftBarButtonItem = ContactServiceViewBar;
    }else{
        self.navigationItem.leftBarButtonItems = @[negativeSpacer1, ContactServiceViewBar];
    }
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 40)];
    _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageButton.frame = CGRectMake(offset, 0.0f, 34.0f, 30.0f);
    [_messageButton setImage:[UIImage imageNamed:@"icn_message"] forState:UIControlStateNormal];
    _messageButton.contentMode = UIViewContentModeScaleToFill;
    [_messageButton addTarget:self action:@selector(messageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:_messageButton];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_messageButton.frame)-16, _messageButton.frame.origin.y+3, 13, 13)];
    messageLabel.backgroundColor = [UIColor redColor];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:10];
    messageLabel.layer.cornerRadius = 7.5;
    messageLabel.layer.masksToBounds = YES;
    messageLabel.hidden = YES;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = @"";
    [messageView addSubview:messageLabel];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:messageView], negativeSpacer1];
}

- (void)ContactServiceButtonPressed
{
    NSString *qq = @"3004628600";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qq]]];
    }
    else
    {
        ZB_Toast(@"尚未检测到相关客户端，咨询失败");
    }
}

- (void)messageButtonPressed{
    MineMessageViewController *vc = [[MineMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    for(UIView *subview in _messageButton.subviews)
    {
        if(subview.tag == 999)
        {
            [subview removeFromSuperview];
        }
    }
    
}

- (void)searchBtnAction
{
    SearchTitleViewController *vc = [[SearchTitleViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self performSelector:@selector(searchBarBecomeFirstResponder:) withObject:vc afterDelay:0.3];
}

- (void)searchBarBecomeFirstResponder:(SearchTitleViewController *)vc{
    [vc.searchBar becomeFirstResponder];
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(WSPageView *)flowView {
    return CGSizeMake(kScreenWidth - 84, kHeadScrollHeight);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    [self FirstPageAdScrollImageTap:subIndex];
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(WSPageView *)flowView {
    return [LdGlobalObj sharedInstanse].advList.count;
}

- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
    WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 84, kHeadScrollHeight)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    if(index > [LdGlobalObj sharedInstanse].advList.count - 1)
    {
        return nil;
    }
    
    if([LdGlobalObj sharedInstanse].advList.count == 0)
    {
        return nil;
    }
    
    FirstAdModel *imageModel = [[LdGlobalObj sharedInstanse].advList objectAtIndex:index];
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp,imageModel.img]] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSPageView *)flowView {
    
    FirstPageAdScrollTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.upPageControl.currentPage = pageNumber;
}

#pragma -mark tableViewCell delegate functions
- (void)FirstTableCellHeadImageTap:(NSInteger)index
{
    FirstAdModel *adModel = [[LdGlobalObj sharedInstanse].advList objectAtIndex:index];
    RemoteMessageModel *model = [RemoteMessageModel model];
    model.msg = @"";
    model.mType = adModel.title;
    model.linkId = adModel.path;
    [[LdGlobalObj sharedInstanse] processRemoteMessage:model];
}

- (void)FirstPageAdScrollImageTap:(NSInteger)index
{
    FirstAdModel *adModel = [[LdGlobalObj sharedInstanse].advList objectAtIndex:index];
    
    RemoteMessageModel *model = [RemoteMessageModel model];
    model.msg = @"";
    model.mType = adModel.title;
    model.linkId = adModel.path;
    [[LdGlobalObj sharedInstanse] processRemoteMessage:model];
}

/*
 每日一练：mryl
 历年真题：lnzt
 独家密卷： djmj
 模考大赛：mkds

 首页中部的按钮动态配置功能，可以通过后台设置8个按钮，包括：招聘信息【链接银行招聘网】、最新校招【资讯】、每日一练、历年真题、独家密卷、模块大赛、图书资料【东吴教育有赞商城】、报考指南【资讯】
 */
- (void)FirstTableCellHeadFunctionBtnPressed:(NSInteger)index
{
    FirstpageModule *model = self.moduleList[index];
    NSString *url = model.url;
    if([model.url_type isEqualToString:@"2"]){
        NewsViewController *vc = [[NewsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = model.title;
        vc.urlString = model.url;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([url isEqualToString:@"mryl"])
    {//每日一练
        ExaminationPaperViewController *vc = [[ExaminationPaperViewController alloc] init];
        vc.examinationPaperType = ExaminationPaperDailyPracticeType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([url isEqualToString:@"lnzt"])
    {
        ExaminationPaperViewController *vc = [[ExaminationPaperViewController alloc] init];
        vc.examinationPaperType = ExaminationPaperOldExamType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([url isEqualToString:@"djmj"])
    {
        //每日一练
        //ExaminationPaperOldExamType,            //历年真题
        //ExaminationPaperExclusivePaperType      //独家密卷
        ExaminationPaperViewController *vc = [[ExaminationPaperViewController alloc] init];
        vc.examinationPaperType = ExaminationPaperExclusivePaperType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([url isEqualToString:@"mkds"])
    {//模考大赛
        MockExamContestViewController *vc = [[MockExamContestViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //报考指南
    else if ([url isEqualToString:@"bkzn"]||[url isEqualToString:@"zxxz"])
    {//最新校招
        InformationViewController *vc = [[InformationViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (NSInteger)getRowOfOutLinesByModel:(OutlineModel *)model
{
    if(model.list_outlineinfo.count == 0)
    {
        return 1;
    }
    
    NSInteger index = 1;
    if(model.isSpread)
    {
        for(OutlineModel *subModel in model.list_outlineinfo)
        {
            index++;
            if(subModel.isSpread)
            {
                for(OutlineModel *subSubModel in subModel.list_outlineinfo)
                {
                    index++;
                    if(subSubModel.isSpread)
                    {
                        for(OutlineModel *subSubSubModel in subSubModel.list_outlineinfo)
                        {
                            index++;
                            if(subSubSubModel.isSpread)
                            {
                                for(OutlineModel *subSubSubSubModel in subSubSubModel.list_outlineinfo)
                                {
                                    index++;
                                    if(subSubSubSubModel.isSpread)
                                    {
                                        for(OutlineModel *subSubSubSubSubModel in subSubSubSubModel.list_outlineinfo)
                                        {
                                            index++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    return index;
}


#pragma -mark UITableView Delegate
#pragma mark 开始进入刷新状态
- (void)setupTableViewRefresh{
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
       self.tableView.mj_header = header;
    
}

- (void)headerRereshing{
    [self.inviteJobList removeAllObjects];
    [self getNetWork];
}



- (void)endTableRefreshing{
   
        [self.tableView.mj_header endRefreshing];
    
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
    
   
}

- (void)refreshTableView:(NSArray *)array{
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     if(section == 2){
           return 154.5;
       }else if (section == 3){
           return 131.5;
       }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 1) {
        UIView *Headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 154)];

        Headview.backgroundColor = [UIColor colorWithHex:@"#F5F5F5"];
    NSString *advStr = section == 2 ? @"sectionone": @"sectiontwo";
        UIImageView *advImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:advStr]];
        [Headview addSubview:advImg];
        advImg.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(expandClick:)];
            [advImg addGestureRecognizer:tap];
        advImg.tag = section+1000;
    [advImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(Headview);
        make.left.equalTo(Headview).offset(16);
        make.right.equalTo(Headview).offset(-16);
        make.top.equalTo(Headview).offset(10);
        make.height.mas_equalTo(section == 2 ? 83 : 60);
    }];
    UIView *moreView = [[UIView alloc] init];
    moreView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
    [Headview addSubview:moreView];
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(Headview);
        make.top.equalTo(advImg.mas_bottom).offset(10);
        make.height.mas_equalTo(50.5);
    }];
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        label1.textColor = kColorBlackText;
        label1.text = section == 2 ? @"精选免费视频":@"最新招聘信息";
        [moreView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(moreView).offset(15);
    }];
    
     UIImageView *rightImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calendar_btn_arrow_right"]];
        [moreView addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.size.mas_equalTo(CGSizeMake(6, 11));
        make.right.equalTo(moreView).offset(-12);
    }];
        
      UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [moreBtn setTitleColor: [UIColor colorWithHex:@"#999999"]forState:0];
        [moreBtn setTitle:@"更多精彩" forState:0];
        moreBtn.tag = section+2000;
        [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImg.mas_left).offset(-6.5);
        make.centerY.equalTo(label1);
    }];
        return Headview;
    }
    return nil;
}

-(void)moreClick:(UIButton *)sender{
    if (sender.tag == 2003) {
        WebViewController *webVc = [WebViewController new];
        webVc.urlString = @"http://m.yinhangzhaopin.com/";
        webVc.title = @"招聘信息";
        webVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVc animated:YES];
    }
    if (sender.tag == 2002) {
        HomeVideoViewController * videoVc = [[HomeVideoViewController alloc]initWithNibName:@"HomeVideoViewController" bundle:nil];
        videoVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoVc animated:YES];
    }
}

-(void)expandClick:(UITapGestureRecognizer *)ges{
    UIImageView * img = (UIImageView *)ges.view;
    switch (img.tag-1000) {
        case 2:{
            self.tabBarController.selectedIndex =2;
        }
            break;
        case 3:{
            InformationViewController *vc = [[InformationViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"报考指南";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
            return 150;
    }else if(indexPath.section == 1){
            return 90+72*((self.moduleList.count-1)/4);
    }else if(indexPath.section == 2){
        return 118.5;
    }else{
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section <= 2){
        return 1;
    }else{
        return self.inviteJobList ? self.inviteJobList.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
            FirstPageAdScrollTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, FirstPageAdScrollTableViewCell, @"FirstPageAdScrollTableViewCell");
            
            loc_cell.upImages = [LdGlobalObj sharedInstanse].advList;
            loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(loc_cell.upImages.count > 0)
            {
                [loc_cell setupImagesPage:nil];
                [LdGlobalObj sharedInstanse].pageView.delegate = self;
                [LdGlobalObj sharedInstanse].pageView.dataSource = self;
            }
            return loc_cell;
        }else if(indexPath.section == 1){
            FirstpageModulesTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, FirstpageModulesTableViewCell, @"FirstpageModulesTableViewCell");
            
            loc_cell.functionBtnDictLists = self.moduleList;
            loc_cell.delegate = self;
            loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [loc_cell setupFunctionsPage:nil];
            
            return loc_cell;
        }else if(indexPath.section == 2){
            HomeVideoListTableViewCell *loc_cell =[tableView dequeueReusableCellWithIdentifier:@"HomeVideoListTableViewCell"];
            if (!loc_cell) {
               loc_cell = [[HomeVideoListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeVideoListTableViewCell"];
            }
            if (self.typeList.count) {
                loc_cell.dataArr = self.typeList;
            }
          MJWeakSelf
            loc_cell.PlayBlock = ^(VideoTypeModel *model) {
                VideoViewController *vc = [[VideoViewController alloc] init];
                vc.typeModel = model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                vc.hidesBottomBarWhenPushed = YES;
            };
           loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return loc_cell;
        }else{
       InviteTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, InviteTableViewCell, @"InviteTableViewCell");
            if (self.inviteJobList.count) {
                InviteJobModel *model  = self.inviteJobList[indexPath.row];
                loc_cell.titleLab.text = model.title;
            }
        loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 return loc_cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section > 2) {
        InviteJobModel *model  = self.inviteJobList[indexPath.row];
        WebViewController *webVc = [WebViewController new];
        webVc.urlString = model.h5Url;
        webVc.title = @"招聘信息";
        webVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVc animated:YES];
    }
    
   
}
-(void)signClick{
    SignViewController * signVC = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
    signVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signVC animated:YES];
}

/**
 获取首页的大试卷，添加到已购买的数据库
 */
- (void)NetworkGetFirstExaminPaper
{
    [LLRequestClass requestdoGetExaminByTypeInfo:@"首页" Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSString *IsGet = contentDict[@"IsGet"];
                [LdGlobalObj sharedInstanse].firstExaminPaperEID = contentDict[@"ID"];
//                if(![IsGet isEqualToString:@"是"])
//                {
                    [self NetworkSendZeroPaySuccessByLinkID:contentDict[@"ID"] PaperName:contentDict[@"Name"]];
//                }
                return;
            }
        }
    } failure:^(NSError *error) {
        [self endTableRefreshing];
        //ZB_Toast(@"失败");
    }];
}

/**
 提交支付信息  做题、提纲的一张大试卷，添加到已购买的数据库
 */
- (void)NetworkSendZeroPaySuccessByLinkID:(NSString *)LinkID PaperName:(NSString *)PaperName
{
    [LLRequestClass requestSendZeroPaySuccessByLinkID:LinkID PType:@"试卷" Abstract:PaperName Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {}
        }
//        ZB_Toast(@"首页试卷没有自动购买成功");
    } failure:^(NSError *error) {
        ZB_Toast(@"失败");
    }];
}


- (void)NetworkGetFavoriteType
{
    [LLRequestClass requestGetTypeByIType:@"收藏类别" success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [LdGlobalObj sharedInstanse].favoriteTypeArray = [NSMutableArray arrayWithArray:contentArray];
            }
        }
        
        [self endTableRefreshing];
    } failure:^(NSError *error) {
        [self endTableRefreshing];
        //ZB_Toast(@"失败");
    }];
}



/**
 获取所有广告
 */
- (void)NetworkGetAllAdByIndex:(NSInteger)index
{
    [[LdGlobalObj sharedInstanse].advList removeAllObjects];
    [LLRequestClass requestGetAllAdBySuccess:^(id jsonData) {
        NSDictionary *contentDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        NSString *result = [contentDict objectForKey:@"result"];
        if([result isEqualToString:@"success"])
        {
            NSArray *list = contentDict[@"list"];
            for(NSDictionary *dict in list)
            {
                FirstAdModel *model = [FirstAdModel model];
                [model setDataWithDic:dict];
                [[LdGlobalObj sharedInstanse].advList addObject:model];
            }
            [self.tableView reloadData];
            
            if(index != 9999)
            {
                [self FirstPageAdScrollImageTap:index];
            }
        }
        [self endTableRefreshing];
    } failure:^(NSError *error) {
        [self endTableRefreshing];
        //ZB_Toast(@"失败");
    }];
}
/**
 首页icon获取模块
 */
- (void)NetworkGetFirstPageModule{
    dispatch_group_enter(self.group);
    [LLRequestClass requestGetFirstPageModuleBySuccess:^(id jsonData) {
        NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        NSString *result = contentDict[@"result"];
        if([result isEqualToString:@"success"])
        {
            NSArray *contentArray = [contentDict objectForKey:@"list"];
            NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
            for(NSDictionary *dict in contentArray)
            {
                FirstpageModule *model = [FirstpageModule model];
                [model setDataWithDic:dict];
                [list addObject:model];
            }
            
            self.moduleList = [NSMutableArray arrayWithArray:list];
            dispatch_group_leave(self.group);
        }
    } failure:^(NSError *error) {
        dispatch_group_leave(self.group);

    }];
}

//获取招聘信息
- (void)requestdoGetApplication{
    dispatch_group_enter(self.group);
    [LLRequestClass requestdoGetApplicationBySuccess:^(id jsonData) {
        NSDictionary *contentDic=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        if([contentDic[@"code"]intValue] == 200){
            NSArray * arr = contentDic[@"data"][@"response"][@"zhaopins"];
            if (arr) {
                for(NSDictionary *dict in arr)
                {
                    InviteJobModel *model = [InviteJobModel new];
                    [model setDataWithDic:dict];
                    [self.inviteJobList addObject:model];
                }
                
            }

        }
        [self.tableView reloadData];
        [self endTableRefreshing];
        dispatch_group_leave(self.group);
    } failure:^(NSError *error) {
        dispatch_group_leave(self.group);
        [self endTableRefreshing];
    }];
}


//获取推荐的视频
- (void)NetworkGetVideoTypes{
    dispatch_group_enter(self.group);
    self.typeList = [NSMutableArray arrayWithCapacity:9];
    [LLRequestClass requestGetVideoTypeBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0){
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                for(NSDictionary *dict in contentArray)
                {
                    VideoTypeModel *model = [VideoTypeModel model];
                    [model setDataWithDic:dict];
                    [self.typeList addObject:model];
                }
                
            }

        }
        dispatch_group_leave(self.group);
    } failure:^(NSError *error) {
        dispatch_group_leave(self.group);
    }];
}

- (UIButton *)signBtn {
    if (!_signBtn) {
        _signBtn = [[UIButton alloc] init];
        [_signBtn setBackgroundImage:[UIImage imageNamed:@"签到"] forState:0];
        [_signBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signBtn;
}
-(NSMutableArray *)inviteJobList{
    if (!_inviteJobList) {
        _inviteJobList = [NSMutableArray array];
    }
    return _inviteJobList;
}
@end
