//
//  LiveViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/27.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "LiveViewController.h"
#import "LiveTableViewCell.h"
#import "MyLiveTableViewCell.h"
#import "MyLiveCommonTableViewCell.h"
#import "CourseCalendarViewController.h"
#import "CourseDetailViewController.h"
#import "LiveModel.h"
#import "MyCourseTableViewCell.h"
#import "TimetablesViewController.h"
#import "VideoTypeModel.h"
#import "VideoSelectTableViewCell.h"
#import "VideoViewController.h"
#import "MyCoursesViewController.h"
#import "SignViewController.h"
@interface LiveViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *mainBottomView;
@property (nonatomic, assign) NSInteger selectMainIndex;
@property (nonatomic, strong)  UIButton*liveBtn;
@property (nonatomic, strong)  UIButton*videoBtn;
@property (nonatomic, strong)  UIView*lineView;
@property (nonatomic, strong) NSMutableArray *liveList;
@property (nonatomic, strong) NSMutableArray *typeList;
@property (nonatomic, strong) UIButton *signBtn;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectMainIndex = 100;
    self.view.backgroundColor = [UIColor whiteColor];
    self.liveList = [NSMutableArray arrayWithCapacity:9];
    self.typeList = [NSMutableArray arrayWithCapacity:9];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self NetworkGetVideoTypes];
    [self NetworkGetAllLiveList];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{

UIButton *myCourseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myCourseButton setTitle:@"我的课程" forState:UIControlStateNormal];
    [myCourseButton setTitleColor:kColorBlackText forState:0];
    myCourseButton.titleLabel.font =[UIFont systemFontOfSize:12];
   [myCourseButton addTarget:self action:@selector(courseClick) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:myCourseButton];
[myCourseButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view).offset(-12);
    make.top.equalTo(self.view).offset(StatusBarHeight+15);
}];
 
[self.view addSubview:self.videoBtn];
[self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view.mas_centerX).offset(-47);
    make.top.equalTo(self.view).offset(StatusBarHeight+15);
}];
[self.view addSubview:self.liveBtn];
[self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view.mas_centerX).offset(47);
      make.top.equalTo(self.view).offset(StatusBarHeight+15);
  }];
self.lineView = [[UIView alloc]init];
self.lineView.backgroundColor = KColorBlueText;
[self.view addSubview:self.lineView];
[self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.videoBtn);
    make.top.equalTo(self.videoBtn.mas_bottom).offset(2);
    make.size.mas_equalTo(CGSizeMake(12, 2));
}];
    
    UIView *speatorView = [[UIView alloc]init];
    speatorView.backgroundColor = kColorBarGrayBackground;
    [self.view addSubview:speatorView];
    [speatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(StatusBarAndNavigationBarHeight);
        make.size.mas_equalTo(CGSizeMake(Screen_Width, 1));
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, Screen_Height-TabbarHeight-StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.signBtn];
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).offset(-5);
        make.width.mas_equalTo(43);
        make.height.mas_equalTo(43);
    }];
}

-(void)courseClick{
    MyCoursesViewController * coureseVc = [MyCoursesViewController new];
    coureseVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coureseVc animated:YES];
}

-(void)signClick{
    SignViewController * signVC = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
    signVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signVC animated:YES];
}


- (void)mainButtonAction:(UIButton *)btn{
    NSInteger index = btn.tag;
    if (btn.tag == self.selectMainIndex) {
        return;
    }
    UIButton * lastBtn = [self.view viewWithTag:self.selectMainIndex];
    lastBtn.selected = NO;
    btn.selected = YES;
    self.selectMainIndex = index;
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.xl_centerX = btn.xl_centerX;
    }];
   
    [self.tableView reloadData];
}

- (void)searchButtonPressed
{
    
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
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 120;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.selectMainIndex == 101)
    {
        return self.liveList.count;
    }
    else
    {
        return self.typeList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectMainIndex == 101)
    {
        LiveTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, LiveTableViewCell, @"LiveTableViewCell");
        LiveModel *model = self.liveList[indexPath.section];
        loc_cell.liveTitleLabel.text = model.Name;
        int endNumber = dateNumberFromDateToToday(model.EndDate);
        if(endNumber>0){
            [loc_cell.enterBtn setTitle:@"进入详情" forState:0];
            [loc_cell.enterBtn setBackgroundColor:KColorBlueText];
               }
        else{
            [loc_cell.enterBtn setTitle:@"已停售" forState:0];
            [loc_cell.enterBtn setBackgroundColor:[UIColor colorWithHex:@"#EFEFEF"]];

        }
        [loc_cell.enterBtn addTarget:self action:@selector(enterClcik:) forControlEvents:UIControlEventTouchUpInside];
        loc_cell.enterBtn.tag = indexPath.section;
        
        loc_cell.liveBuyNumberLabel.text = [NSString stringWithFormat:@"%@已购",model.PurchCount];
        loc_cell.liveClassPlanLabel.text = [NSString stringWithFormat:@"%@至%@",model.BegDate, model.EndDate];
        loc_cell.classTImeLab.text = [NSString stringWithFormat:@"%@课时",model.LCount];
        return loc_cell;
    }
    else{
      VideoSelectTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, VideoSelectTableViewCell, @"VideoSelectTableViewCell");
      VideoTypeModel *model = self.typeList[indexPath.section];
      cell.videoTypeLabel.text = model.VType;
      [cell.videoTypeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp, model.picture]] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
      cell.countLabel.text = [NSString stringWithFormat:@"视频:%@", model.video_num];
      cell.chapterLabel.text = [NSString stringWithFormat:@"章节:%@", model.type_num];
      return cell;
          
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(self.selectMainIndex == 101)
    {
        LiveModel *liveModel = self.liveList[indexPath.section];
        CourseDetailViewController *vc = [[CourseDetailViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.liveModel = liveModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else    {
        VideoViewController *vc = [[VideoViewController alloc] init];
          vc.typeModel =self.typeList[indexPath.section];
            vc.hidesBottomBarWhenPushed = YES;
          [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)enterClcik:(UIButton *)sender{
    LiveModel *liveModel = self.liveList[sender.tag];
          CourseDetailViewController *vc = [[CourseDetailViewController alloc] init];
          vc.hidesBottomBarWhenPushed = YES;
          vc.liveModel = liveModel;
          [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma -mark Network
- (void)NetworkGetAllLiveList{
    [LLRequestClass requestGetAllLiveListBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            [self.liveList removeAllObjects];
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                
                for(NSDictionary *dict in contentArray)
                {
                    LiveModel *model = [LiveModel model];
                    [model setDataWithDic:dict];
                    [self.liveList addObject:model];
                }
            }
        }
        
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}
- (void)NetworkGetVideoTypes{
    self.typeList = [NSMutableArray arrayWithCapacity:9];
    [LLRequestClass requestGetVideoTypeBySuccess:^(id jsonData) {
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
                    VideoTypeModel *model = [VideoTypeModel model];
                    [model setDataWithDic:dict];
                    [self.typeList addObject:model];
                }
                
            }
            
        }
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        
    }];
}

    
- (UIButton *)liveBtn {
        if (!_liveBtn) {
            _liveBtn = [[UIButton alloc] init];
            [_liveBtn setTitleColor:kColorBlackText forState:UIControlStateNormal];
            [_liveBtn setTitleColor:KColorBlueText forState:UIControlStateSelected];
            _liveBtn.tag = 101;
            _liveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [_liveBtn setTitle:@"直播" forState:UIControlStateNormal];
            [_liveBtn addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _liveBtn;
    }

- (UIButton *)videoBtn {
        if (!_videoBtn) {
            _videoBtn = [[UIButton alloc] init];
           [_videoBtn setTitleColor:kColorBlackText forState:UIControlStateNormal];
            _videoBtn.tag = 100;
            [_videoBtn setTitleColor:KColorBlueText forState:UIControlStateSelected];
            _videoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
            _videoBtn.selected = YES;
            [_videoBtn addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _videoBtn;
}
- (UIButton *)signBtn {
    if (!_signBtn) {
        _signBtn = [[UIButton alloc] init];
        [_signBtn setBackgroundImage:[UIImage imageNamed:@"签到"] forState:0];
        [_signBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signBtn;
}

@end
