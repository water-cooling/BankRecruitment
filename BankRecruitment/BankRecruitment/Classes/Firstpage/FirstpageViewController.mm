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
#import "VideoSelectTableViewCell.h"
#import "EverydaySignViewController.h"
#import "LianxiHisViewController.h"
#import "BBAlertView.h"
#import "InformationViewController.h"
#import "FirstpageModule.h"
#import "InviteTableViewCell.h"
#import "VideoTypeModel.h"
#define kHeadScrollHeight 150

@interface FirstpageViewController ()<UITableViewDelegate, UITableViewDataSource, FirstTableCellHeadFunctionBtnFunc, FirstpageModulesFunctionBtnFunc, UISearchBarDelegate, UIWebViewDelegate, WSPageViewDataSource, WSPageViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, copy) NSMutableArray *moduleList;
@property (nonatomic, strong) NSMutableArray *outLineList;
@property (nonatomic, strong) NSMutableArray *typeList;//获取视频list
@property (nonatomic, assign) NSInteger tempOutLineCellNumber;
@property (nonatomic, assign) NSInteger FirstCnt; //获取首页做题n题：FirstCnt   ；客户端限制取得的数量显示出来
@property (nonatomic, assign) NSInteger OutlineCnt; //首页提纲n题：OutlineCnt
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong)  dispatch_queue_t queue;
@end

@implementation FirstpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.group = dispatch_group_create();
       self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.moduleList = [NSMutableArray arrayWithCapacity:9];
    self.outLineList = [NSMutableArray arrayWithCapacity:9];
    self.FirstCnt = 20;
    self.OutlineCnt = 20;
    self.selectedIndexPath = nil;
    
    [self drawViews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorBarGrayBackground;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self setupTableViewRefresh];
    [self getNetWork];
}

-(void)getNetWork{
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
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews{
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-120, 29)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"home_search_inputbox"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBtn.titleLabel.textColor = [UIColor whiteColor];
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
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_messageButton.frame)-6.5, _messageButton.frame.origin.y-6.5, 13, 13)];
    messageLabel.backgroundColor = [UIColor redColor];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:10];
    messageLabel.layer.cornerRadius = 10;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = @"2";
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
    {
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
        ExaminationPaperViewController *vc = [[ExaminationPaperViewController alloc] init];
        vc.examinationPaperType = ExaminationPaperExclusivePaperType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([url isEqualToString:@"mkds"])
    {
        MockExamContestViewController *vc = [[MockExamContestViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([url isEqualToString:@"bkzn"]||[url isEqualToString:@"zxxz"])
    {
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

- (OutlineModel *)getModelOfOutLineSection:(NSInteger)section andRow:(NSInteger)row
{
    OutlineModel *sctionModel = self.outLineList[section-1];
    if(row == 0)
    {
        sctionModel.ceng = 0;
        return sctionModel;
    }
    
    NSInteger index = 1;
    for(OutlineModel *model in sctionModel.list_outlineinfo)
    {
        if(row == index)
        {
            model.ceng = 1;
            return model;
        }
        
        index++;
        if(model.isSpread)
        {
            for(OutlineModel *subModel in model.list_outlineinfo)
            {
                if(row == index)
                {
                    subModel.ceng = 2;
                    return subModel;
                }
                
                index++;
                if(subModel.isSpread)
                {
                    for(OutlineModel *subSubModel in subModel.list_outlineinfo)
                    {
                        if(row == index)
                        {
                            subSubModel.ceng = 3;
                            return subSubModel;
                        }
                        
                        index++;
                        if(subSubModel.isSpread)
                        {
                            for(OutlineModel *subSubSubModel in subSubModel.list_outlineinfo)
                            {
                                if(row == index)
                                {
                                    subSubSubModel.ceng = 4;
                                    return subSubSubModel;
                                }
                                
                                index++;
                                if(subSubSubModel.isSpread)
                                {
                                    for(OutlineModel *subSubSubSubModel in subSubSubModel.list_outlineinfo)
                                    {
                                        if(row == index)
                                        {
                                            subSubSubSubModel.ceng = 5;
                                            return subSubSubSubModel;
                                        }
                                        
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
    
    return nil;
}

- (void)outLineCellAction:(UIButton *)button{
    OutlineModel *model = [self getModelOfOutLineSection:button.tag/10000 andRow:button.tag%10000];
    model.isSpread = !model.isSpread;
    [self.tableView reloadData];
}

#pragma -mark UITableView Delegate
#pragma mark 开始进入刷新状态
- (void)setupTableViewRefresh{
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf footerRereshing];
    }];
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf headerRereshing];
    }];
    
    [self headerRereshing];
    self.tableView.footer.hidden = YES;
}

- (void)headerRereshing{
    [self NetworkGetParam];
    [self NetworkGetFavoriteType];
    [self NetworkGetFirstContentsOutline];
    [self NetworkGetAllAdByIndex:9999];
}

- (void)footerRereshing
{
}

- (void)endTableRefreshing
{
    if(self.tableView.header.isRefreshing)
    {
        [self.tableView.header endRefreshing];
    }
    
    if(self.tableView.footer.isRefreshing)
    {
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
    }
    
    //self.tableView.footer.loadMoreButton.hidden = YES;
}

- (void)refreshTableView:(NSArray *)array
{
    [self.tableView reloadData];
}

- (void)refreshSelectedBy:(OutlineModel *)refreshModel{
    OutlineModel *selectedModel = [self getModelOfOutLineSection:self.selectedIndexPath.section andRow:self.selectedIndexPath.row];
    if([refreshModel.ID isEqualToString:selectedModel.ID])
    {
        selectedModel.doCount = refreshModel.doCount;
        selectedModel.noCount = refreshModel.noCount;
        selectedModel.okCount = refreshModel.okCount;
        selectedModel.errCount = refreshModel.errCount;
    }
    
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
    NSString *advStr = section == 1 ? @"sectionone": @"sectiontwo";
        UIImageView *advImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:advStr]];
        [Headview addSubview:advImg];
    [advImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(Headview);
        make.left.equalTo(Headview).offset(16);
        make.right.equalTo(Headview).offset(-16);
        make.top.equalTo(Headview).offset(10);
        make.height.mas_equalTo(section == 1 ? 83 : 60);
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
        label1.text = section == 1 ? @"精选免费视频":@"最新招聘信息";
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
        
      UILabel *label2 = [[UILabel alloc] init];
        label2.font = [UIFont systemFontOfSize:12];
        label2.textAlignment = NSTextAlignmentRight;
        label2.textColor = [UIColor colorWithHex:@"#999999"];
        label2.text = @"更多精彩";
        [moreView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImg.mas_left).offset(-6.5);
        make.centerY.equalTo(label1);
    }];
        
        return Headview;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
            return 120;
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
        return 4;
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
           VideoSelectTableViewCell *loc_cell = (VideoSelectTableViewCell *)ldGetTableCellWithStyle(tableView, @"VideoSelectTableViewCell", UITableViewCellStyleDefault);
           loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return loc_cell;
        }else{
       InviteTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, InviteTableViewCell, @"InviteTableViewCell");
        loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 return loc_cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section != 0)
    {
        OutlineModel *model = [self getModelOfOutLineSection:indexPath.section andRow:indexPath.row];
        if([[DataBaseManager sharedManager] getExamOperationListByOID:model.ID isFromOutLine:@"是"])
        {
            NSArray *examList = [[DataBaseManager sharedManager] getExamDetailListByOID:model.ID];
            if(examList.count > 0)
            {
                DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.OID = model.ID;
                vc.title = model.Name;
                vc.isSaveUserOperation = YES;
                [self.navigationController pushViewController:vc animated:YES];
                self.selectedIndexPath = indexPath;
            }
            else
            {
                [self NetworkGetOutlineTitleByOID:model.ID ExamTitle:model.Name];
                self.selectedIndexPath = indexPath;
            }
        }
        else
        {
            [self NetworkGetOutlineTitleByOID:model.ID ExamTitle:model.Name];
            self.selectedIndexPath = indexPath;
        }
    }
}

#pragma -mark Network
- (void)NetworkGetParam
{
    [LLRequestClass requestGetParamBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSString *OutlineCntString = contentDict[@"OutlineCnt"];
                self.OutlineCnt = OutlineCntString.integerValue;
                NSString *FirstCntString = contentDict[@"FirstCnt"];
                self.FirstCnt = FirstCntString.integerValue;
            }
        }
        
    } failure:^(NSError *error) {
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

//教材提纲类别
- (void)NetworkGetOutlineType
{
    [LLRequestClass requestGetTypeByIType:@"教材提纲" success:^(id jsonData) {
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
 获取提纲目录
 */
- (void)NetworkGetFirstContentsOutline
{
    [LLRequestClass requestdoGetFirstBySuccess:^(id jsonData) {
        NSDictionary *contentDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        NSString *result = contentDict[@"result"];
        if([result isEqualToString:@"success"])
        {
            [self.outLineList removeAllObjects];
            NSArray *array = contentDict[@"list"];
            for(NSDictionary *dict in array)
            {
                OutlineModel *model = [OutlineModel model];
                [model setDataWithDic:dict];
                [self.outLineList addObject:model];
            }
            
            [self.tableView reloadData];
        }
        
        [self endTableRefreshing];
    } failure:^(NSError *error) {
        [self endTableRefreshing];
        //ZB_Toast(@"失败");
    }];
}

/**
 根据试卷ID获取试题的标题列表

 @param EID 试卷ID
 */
- (void)NetworkGetExamTitlesByEID:(NSString *)EID ExamTitle:(NSString *)title
{
    NSLog(@"DailyPracticeViewController");
    [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetExamTitleExByEID:EID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                //先过滤掉正确的，如果全部正确就全部显示，再判断是否小于FirstCnt
                NSMutableArray *titleList = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    ExaminationTitleModel *model = [ExaminationTitleModel model];
                    [model setDataWithDic:dict];
                    if(![model.isOK isEqualToString:@"是"])
                    {
                        [titleList addObject:model];
                    }
                }
                
                if(titleList.count == 0)
                {
                    for(NSDictionary *dict in contentArray)
                    {
                        ExaminationTitleModel *model = [ExaminationTitleModel model];
                        [model setDataWithDic:dict];
                        [titleList addObject:model];
                    }
                }
                
                NSInteger limit = self.FirstCnt>titleList.count ? titleList.count : self.FirstCnt;
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
                for(int index=0; index<limit; index++)
                {
                    ExaminationTitleModel *model = titleList[index];
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
                    [list addObject:dict];
                }
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:title OID:nil];
                [self endTableRefreshing];
                return;
            }
        }
        [self endTableRefreshing];
        [SVProgressHUD dismiss];
        ZB_Toast(@"没有找到试卷");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
        [self endTableRefreshing];
        [SVProgressHUD dismiss];
    }];
}

/**
 根据提纲ID获取试题的标题列表
 
 @param OID 提纲ID
 */
- (void)NetworkGetOutlineTitleByOID:(NSString *)OID ExamTitle:(NSString *)title
{
    [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetOutlineTitleExByOID:OID tCount:(int)self.OutlineCnt*5 Success:^(id jsonData) {
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
                    if(![model.isOK isEqualToString:@"是"])
                    {
                        [titleList addObject:model];
                    }
                }
                
                if(titleList.count == 0)
                {
                    for(NSDictionary *dict in contentArray)
                    {
                        ExaminationTitleModel *model = [ExaminationTitleModel model];
                        [model setDataWithDic:dict];
                        [titleList addObject:model];
                    }
                }
                
                NSInteger limit = self.OutlineCnt>titleList.count ? titleList.count : self.OutlineCnt;
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
                for(int index=0; index<limit; index++)
                {
                    ExaminationTitleModel *model = titleList[index];
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
                    [list addObject:dict];
                }
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:title OID:OID];
                [self endTableRefreshing];
                return;
            }
        }
        [self endTableRefreshing];
        [SVProgressHUD dismiss];
        ZB_Toast(@"没有找到试卷");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
        [self endTableRefreshing];
        [SVProgressHUD dismiss];
    }];
}

/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList ExamTitle:(NSString *)title OID:(NSString *)OID
{
    NSLog(@"DailyPracticeViewController");
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
                NSLog(@"DailyPracticeViewController");
                DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.OID = OID;
                vc.title = title;
                vc.isSaveUserOperation = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                ZB_Toast(@"没有找到试题");
                [SVProgressHUD dismiss];
            }
            [self endTableRefreshing];
            return;
        }
        [SVProgressHUD dismiss];
        [self endTableRefreshing];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
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
 做题按钮获取试题
 */
- (void)NetworkGetZUOTIExamin
{
    NSLog(@"DailyPracticeViewController");
    [LLRequestClass requestdoGetExaminByTypeInfo:@"首页" Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self NetworkGetExamTitlesByEID:contentDict[@"ID"] ExamTitle:@"做题"];
                return;
            }
        }
        ZB_Toast(@"暂时没有找到试题哦");
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


@end
