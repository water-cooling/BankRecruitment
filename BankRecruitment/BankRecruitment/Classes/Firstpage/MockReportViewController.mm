//
//  MockReportViewController.m
//  Recruitment
//
//  Created by 夏建清 on 2017/9/20.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MockReportViewController.h"
#import "MockReportScoreTableViewCell.h"
#import "QuestionTableViewCell.h"
#import "OutlineModel.h"
#import "ReportAnswerSheetTableViewCell.h"
#import "ExaminationTitleModel.h"
#import "MockReportHeaderView.h"

@interface MockReportViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *outLineList;
@property (nonatomic, strong) NSMutableArray *practiceList;
@property (nonatomic, copy) NSDictionary *detailDict;
@end

@implementation MockReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.outLineList = [NSMutableArray arrayWithCapacity:9];
    self.practiceList = [NSMutableArray arrayWithCapacity:9];
    self.detailDict = [NSDictionary dictionary];
    
    [self NetworkGetFirstContentsOutline];
    [self NetworkGetDataReport];
    [self NetworkGetExamTitlesByEID:self.mockModel.ExaminID ExamTitle:self.mockModel.ExName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    [self drawViews];
}

- (void)drawViews
{
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
    self.tableView.backgroundColor = kColorBarGrayBackground;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    self.title = self.mockModel.ExName;
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

- (void)outLineCellAction:(UIButton *)button
{
    OutlineModel *model = [self getModelOfOutLineSection:button.tag/10000 andRow:button.tag%10000];
    model.isSpread = !model.isSpread;
    [self.tableView reloadData];
}

#pragma -mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 75;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 170;
    }
    else if(indexPath.section == tableView.numberOfSections-1)
    {
        ReportAnswerSheetTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ReportAnswerSheetTableViewCell, @"ReportAnswerSheetTableViewCell");
        loc_cell.answerList = self.practiceList;
        return [loc_cell getHeightReportSheetCell];
    }
    else
    {
        return 67;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2+self.outLineList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == tableView.numberOfSections-1)
    {
        return 1;
    }
    else
    {
        if(self.outLineList.count > 0)
        {
            return [self getRowOfOutLinesByModel:self.outLineList[section-1]];
        }
        else
        {
            return 0;
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MockReportHeaderView" owner:nil options:nil];
        if(array.count > 0)
        {
            MockReportHeaderView *view = [array objectAtIndex:0];
            NSString *OkCountString = self.detailDict[@"OkCount"];
            float OkCount = OkCountString.floatValue;
            NSString *TitleCountString = self.detailDict[@"TitleCount"];
            float TitleCount = TitleCountString.floatValue;
            if(TitleCount == 0)
            {
                view.label2.text = [NSString stringWithFormat:@"共%@道题，答对%@题，答错%@题，正确率0%%", self.detailDict[@"TitleCount"], self.detailDict[@"OkCount"], self.detailDict[@"ErrCount"]];
            }
            else
            {
                view.label2.text = [NSString stringWithFormat:@"共%@道题，答对%@题，答错%@题，正确率%.2f%%", self.detailDict[@"TitleCount"], self.detailDict[@"OkCount"], self.detailDict[@"ErrCount"], OkCount/TitleCount*100.0f];
            }
            
            NSString *AllTimeString = self.detailDict[@"AllTime"];
            int AllTime = AllTimeString.intValue;
            view.label3.text =[NSString stringWithFormat:@"总用时：%02d分%02d秒", AllTime/60, AllTime%60];
            return view;
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        MockReportScoreTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, MockReportScoreTableViewCell, @"MockReportScoreTableViewCell");
        
        if(self.detailDict.allKeys.count > 0)
        {
            loc_cell.scoreLabel.text = self.detailDict[@"MyScore"];
            loc_cell.topScoreLabel.text = self.detailDict[@"MaxScore"];
            loc_cell.pingjunscoreLabel.text = self.detailDict[@"AvgScore"];
            NSString *WinCountString = self.detailDict[@"WinCount"];
            float WinCount = WinCountString.floatValue;
            NSString *AllCountString = self.detailDict[@"AllCount"];
            float AllCount = AllCountString.floatValue;
            if(AllCount == 0)
            {
                loc_cell.winNumLabel.text = @"0%";
            }
            else
            {
                loc_cell.winNumLabel.text = [NSString stringWithFormat:@"%.2f%%", WinCount/AllCount*100.0f];
            }
            
        }
        
        return loc_cell;
    }
    else if(indexPath.section == tableView.numberOfSections-1)
    {
        ReportAnswerSheetTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ReportAnswerSheetTableViewCell, @"ReportAnswerSheetTableViewCell");
        loc_cell.answerTitleLabel.text = @"答题卡：";
        loc_cell.answerList = [NSArray arrayWithArray:self.practiceList];
        [loc_cell setupSheet];
        return loc_cell;
    }
    else
    {
        OutlineModel *model = [self getModelOfOutLineSection:indexPath.section andRow:indexPath.row];
        
        QuestionTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, QuestionTableViewCell, @"QuestionTableViewCell");
        loc_cell.accessoryType = UITableViewCellAccessoryNone;
        loc_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        loc_cell.actionBtn.tag = indexPath.section*10000+indexPath.row;
        [loc_cell.actionBtn addTarget:self action:@selector(outLineCellAction:) forControlEvents:UIControlEventTouchUpInside];
        [loc_cell.actionBtn setImage:nil forState:UIControlStateNormal];
        loc_cell.questionNumberLabel.hidden = YES;
        loc_cell.questionTitleLabel.text = model.Name;
        if(model.TCount.floatValue == 0)
        {
            loc_cell.totelCountLabel.text = [NSString stringWithFormat:@"共%@道题，答对%@题，答错%@题，正确率0%%", model.TCount, model.okCount, model.errCount];
        }
        else
        {
            float i = model.okCount.floatValue/model.TCount.floatValue;
            loc_cell.totelCountLabel.text = [NSString stringWithFormat:@"共%@道题，答对%@题，答错%@题，正确率%.2f%%", model.TCount, model.okCount, model.errCount, i*100.0f];
        }
        
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma -mark Network
/**
 获取提纲目录
 */
- (void)NetworkGetFirstContentsOutline
{
    [LLRequestClass requestdoGetMockOutlineByEID:self.mockModel.ExaminID Success:^(id jsonData) {
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
        NSLog(@"%@",error);
    }];
}

- (void)NetworkGetDataReport
{
    [LLRequestClass requestGetDataReportByEID:self.mockModel.ExaminID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.detailDict = [NSDictionary dictionaryWithDictionary:contentDict];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

/**
 根据试卷ID获取试题的标题列表
 
 @param EID 试卷ID
 */
- (void)NetworkGetExamTitlesByEID:(NSString *)EID ExamTitle:(NSString *)title
{
    [LLRequestClass requestGetExamTitleByEID:EID Success:^(id jsonData) {
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
                
                self.practiceList = [NSMutableArray arrayWithArray:titleList];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
