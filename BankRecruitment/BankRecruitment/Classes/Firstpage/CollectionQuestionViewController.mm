//
//  CollectionQuestionViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/4.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "CollectionQuestionViewController.h"
#import "SearchTitleTableViewCell.h"
#import "ExamDetailModel.h"
#import "ErrorAnalysisViewController.h"

@interface CollectionQuestionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *questionList;

@end

@implementation CollectionQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.questionList = [NSMutableArray arrayWithCapacity:9];
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    
    [self NetworkGetFavoriteList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"收藏题目";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITableView datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamDetailModel *model = self.questionList[indexPath.row];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"（%@）%@", model.QType, getZZwithString(model.title)]];
    [titleAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[LdGlobalObj sharedInstanse].examFontSize] range:NSMakeRange(0, [titleAttributeString length])];
    [titleAttributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleAttributeString length])];
    CGSize TitleSize = [LdGlobalObj sizeWithAttributedString:titleAttributeString width:Screen_Width-20];
    if(TitleSize.height > 80)
    {
        return 125;
    }
    return TitleSize.height + 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTitleTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, SearchTitleTableViewCell, @"SearchTitleTableViewCell");
    
    ExamDetailModel *model = self.questionList[indexPath.row];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"（%@）%@", model.QType, getZZwithString(model.title)]];
    [titleAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[LdGlobalObj sharedInstanse].examFontSize] range:NSMakeRange(0, [titleAttributeString length])];
    [titleAttributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleAttributeString length])];
    [titleAttributeString addAttribute:NSForegroundColorAttributeName value:kColorDarkText range:NSMakeRange(0, [titleAttributeString length])];
    loc_cell.searchTitleLabel.attributedText = titleAttributeString;
    
    loc_cell.searchTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    loc_cell.searchSourceLabel.text = [NSString stringWithFormat:@"来源：%@", model.content];
    
    return loc_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExamDetailModel *model = self.questionList[indexPath.row];
    ErrorAnalysisViewController *vc = [[ErrorAnalysisViewController alloc] init];
    vc.practiceList = @[model];
    vc.DailyPracticeTitle = [model.isFromIntelligent isEqualToString:@"是"] ? @"专项智能" : @"试题";
    vc.isFromFirstPageSearch = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark Network
- (void)NetworkGetFavoriteList
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetFavoriteListBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *examIDList = [NSMutableArray arrayWithCapacity:9];
                NSMutableArray *IntelligentIDList = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *tempDict in contentArray)
                {
                    NSString *FType = tempDict[@"FType"];
                    if([FType isEqualToString:@"试题"])
                    {
                        NSDictionary *dict = [NSDictionary dictionaryWithObject:tempDict[@"LinkID"] forKey:@"ID"];
                        [examIDList addObject:dict];
                    }
                    else if ([FType isEqualToString:@"专项智能"])
                    {
                        NSDictionary *dict = [NSDictionary dictionaryWithObject:tempDict[@"LinkID"] forKey:@"ID"];
                        [IntelligentIDList addObject:dict];
                    }
                }
                
                [self.questionList removeAllObjects];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                [self NetworkGetExamDetailListByTitleList:examIDList];
                [self NetworkGetIntelligentExamDetailListByTitleList:IntelligentIDList];
                return;
            }
            else if([result isEqualToString:@"noresult"])
            {
                ZB_Toast(@"您还没有收藏哦");
                [self.questionList removeAllObjects];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                return;
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetExamDetailsByTitleList:titleList Success:^(id jsonData) {
        NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        if([contentDict isKindOfClass:[NSArray class]])
        {
            [SVProgressHUD dismiss];
            return;
        }
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
                model.isFromIntelligent = @"否";
                [examList addObject:model];
            }
            
            [self.questionList addObjectsFromArray:examList];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            return;
        }
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetIntelligentExamDetailListByTitleList:(NSArray *)titleList
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetIntelligentExamDetailsByTitleList:titleList Success:^(id jsonData) {
        NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        if([contentDict isKindOfClass:[NSArray class]])
        {
            [SVProgressHUD dismiss];
            return;
        }
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
                model.isFromIntelligent = @"是";
                [examList addObject:model];
            }
            
            [self.questionList addObjectsFromArray:examList];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            return;
        }

        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
