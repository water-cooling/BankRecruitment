//
//  VideoSelectViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "VideoSelectViewController.h"
#import "QuestionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "OutlineModel.h"
#import "DataBaseManager.h"
#import "DailyPracticeViewController.h"
#import "ExaminationTitleModel.h"
#import "ExamDetailModel.h"
#import "IntelligentPaperViewController.h"
#import "LianxiHisViewController.h"
#import "WrongQuestionsViewController.h"
#import "ExaminationPaperViewController.h"
@interface VideoSelectViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *outLineList;
@property (nonatomic, assign) NSUInteger tempOutLineCellNumber;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) NSInteger FirstCnt; //获取首页做题n题：FirstCnt   ；客户端限制取得的数量显示出来
@property (nonatomic, assign) NSInteger OutlineCnt; //首页提纲n题：OutlineCnt
@end

@implementation VideoSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outLineList = [NSMutableArray array];
    self.OutlineCnt = 20;
    [self NetworkGetFirstContentsOutline];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshRemoteMessageVideoListBy:(VideoCatalogModel *)model{
    VideoViewController *vc = [[VideoViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.remoteMessageVideoModel = model;
    [self.navigationController pushViewController:vc animated:NO];
}
- (NSInteger)getRowOfOutLinesByModel:(OutlineModel *)model{
    if(model.list_outlineinfo.count == 0){
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

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.outLineList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSInteger number = [self getRowOfOutLinesByModel:self.outLineList[section]];
        return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        self.tempOutLineCellNumber = 0;
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
- (IBAction)topBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            ExaminationPaperViewController *vc = [[ExaminationPaperViewController alloc] init];
            vc.examinationPaperType = ExaminationPaperExclusivePaperType;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 101:
            {
            
            WrongQuestionsViewController *vc = [[WrongQuestionsViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 102:
        {
            LianxiHisViewController *vc = [[LianxiHisViewController alloc] init];
                      vc.hidesBottomBarWhenPushed = YES;
                      vc.title = @"练习历史";
                      [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
            case 103:
        {
            IntelligentPaperViewController *vc = [[IntelligentPaperViewController alloc] init];
                      vc.hidesBottomBarWhenPushed = YES;
                      [self.navigationController pushViewController:vc animated:YES];
            
        }
            
            break;
            
        default:
            break;
    }
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
            return;
        }
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}
- (void)NetworkGetParam{
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



- (void)editClick:(UIButton *)button
{
    OutlineModel *model = [self getModelOfOutLineSection:button.tag/20000 andRow:button.tag%20000];
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
                self.selectedIndexPath = [NSIndexPath indexPathForRow:button.tag%20000 inSection:button.tag/20000];
            }
            else
            {
                [self NetworkGetOutlineTitleByOID:model.ID ExamTitle:model.Name];
                self.selectedIndexPath = [NSIndexPath indexPathForRow:button.tag%20000 inSection:button.tag/20000];
            }
        }
        else
        {
            [self NetworkGetOutlineTitleByOID:model.ID ExamTitle:model.Name];
            self.selectedIndexPath = [NSIndexPath indexPathForRow:button.tag%20000 inSection:button.tag/20000];
        }
}
@end
