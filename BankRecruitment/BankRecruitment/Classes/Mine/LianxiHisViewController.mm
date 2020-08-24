//
//  LianxiHisViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/30.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "LianxiHisViewController.h"
#import "OutlineModel.h"
#import "QuestionTableViewCell.h"
#import "ExaminationTitleModel.h"
#import "DailyPracticeViewController.h"
#import "ExamDetailModel.h"
#import "ExaminationTitleModel.h"
#import "ErrorAnalysisViewController.h"
#import "PurchedModel.h"
#import "WrongQuestionsSheetViewController.h"
#import "ExaminationTitleModel.h"

@interface LianxiHisViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *outLineList;
@end

@implementation LianxiHisViewController

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
          OutlineModel *model = [self getModelOfOutLineSection:indexPath.section andRow:indexPath.row];
          
          QuestionTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, QuestionTableViewCell, @"QuestionTableViewCell");
          loc_cell.actionBtn.tag = indexPath.section*10000+indexPath.row;
      loc_cell.editBtn.tag = indexPath.section*2000+indexPath.row;

          [loc_cell.actionBtn addTarget:self action:@selector(outLineCellAction:) forControlEvents:UIControlEventTouchUpInside];
          [loc_cell.actionBtn setImage:nil forState:UIControlStateNormal];
          loc_cell.questionNumberLabel.hidden = YES;
          loc_cell.questionTitleLabel.text = model.Name;
          loc_cell.totelCountLabel.text = [NSString stringWithFormat:@"%@/%@",model.doCount, model.TCount];
      [loc_cell.editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
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
                  loc_cell.actionBtn.size = CGSizeMake(25, 25);

              }
              else
              {
                  [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_add"] forState:UIControlStateNormal];
                  loc_cell.actionBtn.size = CGSizeMake(25, 25);

              }
          }
          else if(model.list_outlineinfo.count > 0)
          {
              if(model.isSpread)
              {
                  [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_minus"] forState:UIControlStateNormal];
                  loc_cell.actionBtn.size = CGSizeMake(17, 17);

              }
              else
              {
                  [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_icon_add"] forState:UIControlStateNormal];
                  loc_cell.actionBtn.size = CGSizeMake(17, 17);

              }
          }
          else
          {
              [loc_cell.actionBtn setImage:[UIImage imageNamed:@"content_circle_blue"] forState:UIControlStateNormal];
              loc_cell.actionBtn.size = CGSizeMake(15, 15);

          }
          return loc_cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OutlineModel *model = [self getModelOfOutLineSection:indexPath.section andRow:indexPath.row];
    [self NetworkGetOutLineTitleHisBy:model];
    
}

- (void)editClick:(UIButton *)button
{
    OutlineModel *model = [self getModelOfOutLineSection:button.tag/20000 andRow:button.tag%20000];
  [self NetworkGetOutLineTitleHisBy:model];

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

- (void)NetworkGetOutLineTitleHisBy:(OutlineModel *)model
{
    [LLRequestClass requestdoGetOutlineTitleHisByOID:model.ID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *List = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    ExaminationTitleModel *model = [ExaminationTitleModel model];
                    [model setDataWithDic:dict];
                    [List addObject:model];
                }
                
                PurchedModel *purchModel = [PurchedModel model];
                purchModel.LinkID = model.EID;
                purchModel.Abstract = model.Name;
                
                WrongQuestionsSheetViewController *vc = [[WrongQuestionsSheetViewController alloc] init];
                vc.purchedModel = purchModel;
                vc.practiceList = List;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
        
        ZB_Toast(@"没有查出历史");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

@end
