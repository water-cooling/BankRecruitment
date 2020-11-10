//
//  WrongQuestionsViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/30.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "WrongQuestionsViewController.h"
#import "CalendarTableViewCell.h"
#import "PurchedModel.h"
#import "WrongQuestionsSheetViewController.h"
#import "WrongTreeViewController.h"

@interface WrongQuestionsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation WrongQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.list = [NSMutableArray arrayWithCapacity:9];
    
    [self drawViews];
    [self NetworkGetPayInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"错题本";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-TabbarSafeBottomMargin) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, CalendarTableViewCell, @"CalendarTableViewCell");
            loc_cell.accessoryType = UITableViewCellAccessoryNone;
             PurchedModel *model = self.list[indexPath.row];
            loc_cell.calendarTitleLabel.text = model.Abstract;
    loc_cell.calendarTimeLabel.text = model.FeeDate;
    loc_cell.editBtn.tag = indexPath.row;
     [loc_cell.editBtn setImage:[UIImage imageNamed:@"zt"] forState:0];
     [loc_cell.editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
            return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PurchedModel *model = self.list[indexPath.row];
    if([model.LinkID isEqualToString:[LdGlobalObj sharedInstanse].firstExaminPaperEID])    {
        WrongTreeViewController *vc = [[WrongTreeViewController alloc] init];
        vc.title = model.Abstract;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        WrongQuestionsSheetViewController *vc = [[WrongQuestionsSheetViewController alloc] init];
        vc.purchedModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)editClick:(UIButton *)sender{
    PurchedModel *model = self.list[sender.tag];
       if([model.LinkID isEqualToString:[LdGlobalObj sharedInstanse].firstExaminPaperEID])
       {
           WrongTreeViewController *vc = [[WrongTreeViewController alloc] init];
           vc.title = model.Abstract;
           [self.navigationController pushViewController:vc animated:YES];
       }
       else
       {
           WrongQuestionsSheetViewController *vc = [[WrongQuestionsSheetViewController alloc] init];
           vc.purchedModel = model;
           [self.navigationController pushViewController:vc animated:YES];
       }
    
}

#pragma -mark Network
- (void)NetworkGetPayInfo
{
    [LLRequestClass requestGetPurchListByPType:@"试卷" Success:^(id jsonData) {
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
                    PurchedModel *model = [PurchedModel model];
                    [model setDataWithDic:dict];
                    [self.list addObject:model];
                }
                
                [self.tableView reloadData];
                return;
            }
        }
        
        ZB_Toast(@"您还没有开始做题");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
