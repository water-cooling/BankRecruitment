//
//  MyCoursesViewController.m
//  Recruitment
//
//  Created by yltx on 2020/8/21.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "MyCoursesViewController.h"
#import "MyCourseTableViewCell.h"
#import "LiveModel.h"
#import "TimetablesViewController.h"
#import "CourseCalendarViewController.h"
@interface MyCoursesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *myClassesList;
@property (strong, nonatomic) UIImageView *placehodleImg;
@property (strong, nonatomic) UILabel *noAddressLab;
@end

@implementation MyCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myClassesList = [NSMutableArray arrayWithCapacity:9];
    [self drawViews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableview.tableFooterView = [UIView new];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.title = @"我的课程";
    [self NetworkGetMineLiveList];
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.placehodleImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noaddress"]];
    self.noAddressLab = [[UILabel alloc] init];
    self.noAddressLab.font = [UIFont systemFontOfSize:15];
    self.noAddressLab.textAlignment = NSTextAlignmentCenter;
        self.noAddressLab.textColor = [UIColor colorWithHex:@"#333333"];
        self.noAddressLab.text = @"您还没有收获地址哦～";
    [self.view addSubview:self.noAddressLab];
    [self.view addSubview:self.placehodleImg];
    self.tableview.hidden = YES;
    [self.placehodleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(145, 145));
    }];
    [self.noAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
          make.height.mas_equalTo(15);
          make.top.equalTo(self.placehodleImg.mas_bottom).offset(33);
      }];
}
- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)historyDayClick:(id)sender {
    CourseCalendarViewController *vc = [[CourseCalendarViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
[self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return self.myClassesList.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
            return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCourseTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MyCourseTableViewCell, @"MyCourseTableViewCell");
    LiveModel *model = self.myClassesList[indexPath.section];
    loc_cell.liveTitleLabel.text = model.Name;
    [loc_cell.enterBtn addTarget:self action:@selector(enterClcik:) forControlEvents:UIControlEventTouchUpInside];
    loc_cell.enterBtn.tag = indexPath.section;

    loc_cell.liveClassPlanLabel.text = [NSString stringWithFormat:@"课程安排：%@-%@",model.BegDate, model.EndDate];
    loc_cell.liveClassTeacherLabel.text = [NSString stringWithFormat:@"%@已购",model.PurchCount];
    loc_cell.classTImeLab.text = [NSString stringWithFormat:@"%@课时",model.LCount];
            return loc_cell;

}

-(void)enterClcik:(UIButton *)sender{
    LiveModel *model = self.myClassesList[sender.tag];
    TimetablesViewController *vc = [[TimetablesViewController alloc] init];
               vc.hidesBottomBarWhenPushed = YES;
               vc.LID = model.LID;
               vc.title = model.Name;
               [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
            LiveModel *model = self.myClassesList[indexPath.section];
            TimetablesViewController *vc = [[TimetablesViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.LID = model.LID;
            vc.title = model.Name;
            [self.navigationController pushViewController:vc animated:YES];

    
}

#pragma -mark Network


- (void)NetworkGetMineLiveList{
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
                self.tableview.hidden = NO;
                self.placehodleImg.hidden = YES;
                self.noAddressLab.hidden = YES;
                                
            }
            self.tableview.hidden = NO;
            self.placehodleImg.hidden = YES;
            self.noAddressLab.hidden = YES;
            
        }else{
            ZB_Toast(@"暂无数据");
            self.tableview.hidden = NO;
            self.placehodleImg.hidden = YES;
            self.noAddressLab.hidden = YES;
        }
        
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        //;
    }];
}
@end
