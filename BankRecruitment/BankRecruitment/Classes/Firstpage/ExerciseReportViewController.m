//
//  ExerciseReportViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/5.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExerciseReportViewController.h"
#import <UShareUI/UShareUI.h>
#import "ReportAnswerSheetTableViewCell.h"
#import "CalendarTableViewCell.h"
#import "OldExamsSubTableViewCell.h"
#import "QuestionReportTableViewCell.h"

@interface ExerciseReportViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *answerList;
@end

@implementation ExerciseReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"练习报告";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [shareButton setImage:[UIImage imageNamed:@"shiti_icon_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    self.answerList = @[@YES, @NO, @NO, @YES, @NO, @NO, @NO, @YES, @YES, @NO];
    
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonPressed
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
    }];
}

#pragma -mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 70;
    }
    else if (indexPath.row == 1)
    {
        ReportAnswerSheetTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ReportAnswerSheetTableViewCell, @"ReportAnswerSheetTableViewCell");
        loc_cell.answerList = self.answerList;
        return [loc_cell getHeightReportSheetCell];
    }
    else if (indexPath.row == 2)
    {
        return 44;
    }
    else
    {
        return 62;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        CalendarTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, CalendarTableViewCell, @"CalendarTableViewCell");
        
        loc_cell.calendarTitleLabel.text = @"练习类型：每日一练";
        loc_cell.calendarTimeLabel.text = @"交卷时间：2017.03.24";
        
        return loc_cell;
    }
    else if (indexPath.row == 1)
    {
        ReportAnswerSheetTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ReportAnswerSheetTableViewCell, @"ReportAnswerSheetTableViewCell");
        loc_cell.answerList = self.answerList;
        [loc_cell setupSheet];
        return loc_cell;
    }
    else if (indexPath.row == 2)
    {
        OldExamsSubTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, OldExamsSubTableViewCell, @"OldExamsSubTableViewCell");
        loc_cell.oldExamSubLabel.text = @"考试情况";
        return loc_cell;
    }
    else
    {
        QuestionReportTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, QuestionReportTableViewCell, @"QuestionReportTableViewCell");
        if(indexPath.row == 3)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_add"] forState:UIControlStateNormal];
            loc_cell.upLineView.hidden = YES;
            loc_cell.downLineView.hidden = YES;
            loc_cell.BottomLine.hidden = NO;
        }
        else if(indexPath.row == 4)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_minus"] forState:UIControlStateNormal];
            loc_cell.upLineView.hidden = YES;
            loc_cell.downLineView.hidden = NO;
            loc_cell.BottomLine.hidden = YES;
        }
        else if(indexPath.row == 5)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_smallicon_add"] forState:UIControlStateNormal];
            loc_cell.upLineView.hidden = NO;
            loc_cell.downLineView.hidden = NO;
            loc_cell.BottomLine.hidden = YES;
        }
        else if(indexPath.row == 6)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_smallicon_add"] forState:UIControlStateNormal];
            loc_cell.upLineView.hidden = NO;
            loc_cell.downLineView.hidden = NO;
            loc_cell.BottomLine.hidden = YES;
        }
        else if(indexPath.row == 7)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_smallicon_minus"] forState:UIControlStateNormal];
            loc_cell.upLineView.hidden = NO;
            loc_cell.downLineView.hidden = NO;
            loc_cell.BottomLine.hidden = YES;
        }
        else if(indexPath.row == 8)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_circle_blue"] forState:UIControlStateNormal];
            loc_cell.upLineView.hidden = NO;
            loc_cell.downLineView.hidden = NO;
            loc_cell.BottomLine.hidden = YES;
        }
        else if(indexPath.row == 9)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_circle_blue"] forState:UIControlStateNormal];
            loc_cell.upLineView.hidden = NO;
            loc_cell.downLineView.hidden = YES;
            loc_cell.BottomLine.hidden = NO;
        }
        else if(indexPath.row == 10)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_add"] forState:UIControlStateNormal];
            loc_cell.upLineView.hidden = YES;
            loc_cell.downLineView.hidden = YES;
            loc_cell.BottomLine.hidden = NO;
        }
        
        return loc_cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

@end
