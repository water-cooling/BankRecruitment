//
//  NoteQuestionViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/4.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "NoteQuestionViewController.h"
#import "SearchTitleTableViewCell.h"
#import "ExamDetailModel.h"
#import "ErrorAnalysisViewController.h"

@interface NoteQuestionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *questionList;

@end

@implementation NoteQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    [self NetworkGetNoteTitles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"笔记题目";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
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
    
    ErrorAnalysisViewController *vc = [[ErrorAnalysisViewController alloc] init];
    vc.practiceList = @[self.questionList[indexPath.row]];
    vc.DailyPracticeTitle = @"笔记题目";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark Network
- (void)NetworkGetNoteTitles
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetNoteTitlesBySuccess:^(id jsonData) {
        [SVProgressHUD dismiss];
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
            
            self.questionList = [NSMutableArray arrayWithArray:examList];
            [self.tableView reloadData];
            return;
        }
        ZB_Toast(@"您还没有添加笔记哦");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

@end
