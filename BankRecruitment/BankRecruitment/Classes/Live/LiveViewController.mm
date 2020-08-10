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

@interface LiveViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *mainBottomView;
@property (nonatomic, assign) NSInteger selectMainIndex;
@property (nonatomic, copy) NSArray *mainList;
@property (nonatomic, strong) NSMutableArray *liveList;
@property (nonatomic, strong) NSMutableArray *myClassesList;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectMainIndex = 0;
    self.liveList = [NSMutableArray arrayWithCapacity:9];
    self.myClassesList = [NSMutableArray arrayWithCapacity:9];
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    self.navigationItem.title = @"直播";
    
    [self NetworkGetAllLiveList];
    [self NetworkGetMineLiveList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    float modelheight = 44;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+modelheight, Screen_Width, Screen_Height-TabbarHeight-StatusBarAndNavigationBarHeight-modelheight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kColorBarGrayBackground;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.mainList = @[@"直播中心", @"我的课程"];
    float kongxi = 0;
    float modelWidth = Screen_Width/self.mainList.count;
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, modelheight)];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainView];
    for(int index=0; index<self.mainList.count; index++)
    {
        UIView *modelView = [[UIView alloc] initWithFrame:CGRectMake(modelWidth*index + kongxi*(index+1), 0, modelWidth, modelheight)];
        modelView.userInteractionEnabled = YES;
        [self.mainView addSubview:modelView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(3, 10, modelWidth-6, 24)];
        label.tag = index;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = kColorDarkText;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 2;
        label.text = self.mainList[index];
        [modelView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:modelView.bounds];
        button.backgroundColor = [UIColor clearColor];
        button.tag = index;
        [button addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [modelView addSubview:button];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    lineView.backgroundColor = kColorLineSepBackground;
    lineView.center = self.mainView.center;
    [self.view addSubview:lineView];
    
    self.mainBottomView = [[UIView alloc] initWithFrame:CGRectMake(kongxi, modelheight-4, 100, 4)];
    self.mainBottomView.backgroundColor = kColorNavigationBar;
    self.mainBottomView.centerX = Screen_Width/4;
    [self.mainView addSubview:self.mainBottomView];
    
    UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
    lineBottomView.backgroundColor = kColorLineSepBackground;
    lineBottomView.top = self.mainView.bottom-0.5;
    [self.view addSubview:lineBottomView];
}

- (void)mainButtonAction:(UIButton *)btn
{
    NSInteger index = btn.tag;
    self.selectMainIndex = index;
    for(UIView *subView in self.mainView.subviews)
    {
        for(UIView *subsubView in subView.subviews)
        {
            if((subsubView.tag == index)&&([subsubView isKindOfClass:[UILabel class]]))
            {
                UILabel *tempView = (UILabel *)subsubView;
                tempView.textColor = kColorNavigationBar;
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.mainBottomView.centerX = subView.centerX;
                }];
            }
            else if([subsubView isKindOfClass:[UILabel class]])
            {
                UILabel *tempView = (UILabel *)subsubView;
                tempView.textColor = kColorDarkText;
            }
        }
        
    }
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectMainIndex == 0)
    {
        return 118;
    }
    else
    {
        if(indexPath.section == 0)
        {
            return 44;
        }
        else
        {
            return 80;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.selectMainIndex == 0)
    {
        return self.liveList.count;
    }
    else
    {
        return 1+self.myClassesList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selectMainIndex == 0)
    {
        return 1;
    }
    else
    {
        if(section == 0)
        {
            return 1;
        }
        else
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectMainIndex == 0)
    {
        LiveTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, LiveTableViewCell, @"LiveTableViewCell");
        LiveModel *model = self.liveList[indexPath.section];
        loc_cell.liveTitleLabel.text = model.Name;
        float price = model.Price.floatValue;
        if([model.IsGet isEqualToString:@"是"])
        {
            loc_cell.livePriceLabel.text = @"";
            loc_cell.priceConstraint.constant = 0;
        }
        else if((price != 0)&&([model.IsGet isEqualToString:@"否"]))
        {
            loc_cell.livePriceLabel.text = [NSString stringWithFormat:@"￥%.2f", price];
            loc_cell.priceConstraint.constant = 90;
        }
        else
        {
            loc_cell.livePriceLabel.text = @"";
            loc_cell.priceConstraint.constant = 0;
        }
        
        if([model.IsGet isEqualToString:@"是"]&&(price != 0))
        {
            loc_cell.livePriceLabel.text = @"";
            loc_cell.priceConstraint.constant = 0;
        }
        
        loc_cell.liveBuyNumberLabel.text = [NSString stringWithFormat:@"参与人数 %@",model.PurchCount];
        loc_cell.liveClassPlanLabel.text = [NSString stringWithFormat:@"课程安排：%@至%@(%@课时)",model.BegDate, model.EndDate, model.LCount];
        int endNumber = dateNumberFromDateToToday(model.EndDate);
        if(endNumber>0)
        {
            loc_cell.liveLimitTimeLabel.text = [NSString stringWithFormat:@"距停售时间还有%d天",endNumber];
        }
        else
        {
            loc_cell.liveLimitTimeLabel.text = @"已停售";
        }
        return loc_cell;
    }
    else
    {
        if(indexPath.section == 0)
        {
            MyLiveCommonTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MyLiveCommonTableViewCell, @"MyLiveCommonTableViewCell");
//            if(indexPath.row == 0)
//            {
//                loc_cell.liveTitleImageView.image = [UIImage imageNamed:@"zhibo_icon_collect"];
//                loc_cell.liveTitleLabel.text = @"我的收藏";
//            }
//            else
//            {
                loc_cell.liveTitleImageView.image = [UIImage imageNamed:@"zhibo_icon_calendar"];
                loc_cell.liveTitleLabel.text = @"课程日历";
//            }
            return loc_cell;
        }
        else
        {
            MyCourseTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MyCourseTableViewCell, @"MyCourseTableViewCell");
            LiveModel *model = self.myClassesList[indexPath.section-1];
            loc_cell.liveTitleLabel.text = model.Name;
            loc_cell.liveClassPlanLabel.text = [NSString stringWithFormat:@"课程安排：%@至%@(%@课时)",model.BegDate, model.EndDate, model.LCount];
            return loc_cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(self.selectMainIndex == 0)
    {
        LiveModel *liveModel = self.liveList[indexPath.section];
        CourseDetailViewController *vc = [[CourseDetailViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.liveModel = liveModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if(indexPath.section == 0)
        {
            CourseCalendarViewController *vc = [[CourseCalendarViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            LiveModel *model = self.myClassesList[indexPath.section-1];
            TimetablesViewController *vc = [[TimetablesViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.LID = model.LID;
            vc.title = model.Name;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma -mark Network
- (void)NetworkGetAllLiveList
{
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
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

- (void)NetworkGetMineLiveList
{
    [LLRequestClass requestGetUserBuyedLiveListBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            [self.myClassesList removeAllObjects];
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                for(NSDictionary *dict in contentArray)
                {
                    LiveModel *model = [LiveModel model];
                    [model setDataWithDic:dict];
                    [self.myClassesList addObject:model];
                }
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

@end
