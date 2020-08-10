//
//  WrongTreeViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "WrongTreeViewController.h"
#import "OutlineModel.h"
#import "QuestionReportTableViewCell.h"
#import "ExaminationTitleModel.h"
#import "DailyPracticeViewController.h"
#import "ExamDetailModel.h"
#import "ExaminationTitleModel.h"
#import "ErrorAnalysisViewController.h"


@interface WrongTreeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *outLineList;
@end

@implementation WrongTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.outLineList = [NSMutableArray arrayWithCapacity:9];
    
    [self drawViews];
    [self NetworkGetFirstContentsOutline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - TabbarSafeBottomMargin) style:UITableViewStylePlain];
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
    OutlineModel *sctionModel = self.outLineList[section];
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

- (void)outLineCellAction:(UIButton *)button
{
    OutlineModel *model = [self getModelOfOutLineSection:button.tag/10000 andRow:button.tag%10000];
    model.isSpread = !model.isSpread;
    [self.tableView reloadData];
}

- (void)questionExamButtonAction:(UIButton *)button
{
    OutlineModel *model = [self getModelOfOutLineSection:button.tag/10000 andRow:button.tag%10000];
    [self NetworkGetOutlineTitleHisByOID:model.ID ExamTitle:model.Name ButtonType:@"exam"];
}

#pragma -mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.outLineList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = [self getRowOfOutLinesByModel:self.outLineList[section]];
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutlineModel *model = [self getModelOfOutLineSection:indexPath.section andRow:indexPath.row];
    
    QuestionReportTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, QuestionReportTableViewCell, @"QuestionReportTableViewCell");
    loc_cell.actionBtn.tag = indexPath.section*10000+indexPath.row;
    [loc_cell.actionBtn addTarget:self action:@selector(outLineCellAction:) forControlEvents:UIControlEventTouchUpInside];
    [loc_cell.actionBtn setImage:nil forState:UIControlStateNormal];
    loc_cell.questionTitleLabel.text = model.Name;
    [loc_cell.questionExamButton setTitle:[NSString stringWithFormat:@"练习错题(%@)道",model.errCount] forState:UIControlStateNormal];
    loc_cell.questionExamButton.tag = indexPath.section*10000+indexPath.row;
    [loc_cell.questionExamButton addTarget:self action:@selector(questionExamButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    loc_cell.upLineView.hidden = NO;
    loc_cell.downLineView.hidden = NO;
    loc_cell.BottomLine.hidden = YES;
    if(indexPath.row == 0)
    {
        loc_cell.upLineView.hidden = YES;
    }
    if(indexPath.row == ([tableView numberOfRowsInSection:indexPath.section]-1))
    {
        loc_cell.BottomLine.hidden = NO;
        loc_cell.downLineView.hidden = YES;
    }
    
    if(model.ceng == 0)
    {
        if(model.isSpread)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_minus"] forState:UIControlStateNormal];
        }
        else
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_add"] forState:UIControlStateNormal];
        }
    }
    else if(model.list_outlineinfo.count > 0)
    {
        if(model.isSpread)
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_smallicon_minus"] forState:UIControlStateNormal];
        }
        else
        {
            [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_smallicon_add"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_circle_blue"] forState:UIControlStateNormal];
    }
    
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OutlineModel *model = [self getModelOfOutLineSection:indexPath.section andRow:indexPath.row];
    [self NetworkGetOutlineTitleHisByOID:model.ID ExamTitle:model.Name ButtonType:@"error"];
}

#pragma -mark Network
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
        
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

/**
 根据提纲ID获取试题的标题列表
 
 @param OID 提纲ID
 */
- (void)NetworkGetOutlineTitleHisByOID:(NSString *)OID ExamTitle:(NSString *)title ButtonType:(NSString *)ButtonType
{
    [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetOutlineTitleHisByOID:OID Success:^(id jsonData) {
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
                for(int index=0; index<titleList.count; index++)
                {
                    ExaminationTitleModel *model = titleList[index];
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
                    [list addObject:dict];
                }
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:title ButtonType:ButtonType];
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
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList ExamTitle:(NSString *)title ButtonType:(NSString *)ButtonType
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
                if([ButtonType isEqualToString:@"error"])
                {
                    ErrorAnalysisViewController *vc = [[ErrorAnalysisViewController alloc] init];
                    vc.practiceList = [NSMutableArray arrayWithArray:examList];
                    vc.DailyPracticeTitle = title;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.practiceList = [NSMutableArray arrayWithArray:examList];
                    vc.title = title;
                    vc.isSaveUserOperation = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            else
            {
                ZB_Toast(@"没有找到试题");
                [SVProgressHUD dismiss];
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
