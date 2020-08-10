//
//  SearchTitleViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "SearchTitleViewController.h"
#import "SearchTitleTableViewCell.h"
#import "ExamDetailModel.h"
#import "MJRefresh.h"
#import "ErrorAnalysisViewController.h"
#import "BBAlertView.h"

@interface SearchTitleViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchList;
@end

@implementation SearchTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.searchList = [NSMutableArray arrayWithCapacity:9];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 160, 30)];
    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchBar.tintColor = kColorDarkText;
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"搜索题目";
    self.searchBar.delegate = self;
    [self.searchBar setValue:@"取消" forKey: @"_cancelButtonText"];
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    // 输入文本颜色
    searchField.textColor = kColorDarkText;
    // 默认文本颜色
    [searchField setValue:kColorDarkText forKeyPath:@"_placeholderLabel.textColor"];
    self.navigationItem.titleView = self.searchBar;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self setupTableViewRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
    self.navigationController.navigationBarHidden = NO;
//    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(strIsNullOrEmpty(searchBar.text))
    {
        return;
    }
    [searchBar resignFirstResponder];
    [self NetworkGetSearchByKeyword:searchBar.text andPage:1];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 开始进入刷新状态
- (void)setupTableViewRefresh
{
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf footerRereshing];
    }];
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf headerRereshing];
    }];
    
    [self headerRereshing];
    self.tableView.footer.hidden = NO;
}

- (void)headerRereshing
{
    if(strIsNullOrEmpty(self.searchBar.text))
    {
        [self endTableRefreshing];
        return;
    }
    
    [self.searchBar resignFirstResponder];
    [self NetworkGetSearchByKeyword:self.searchBar.text andPage:1];
}

- (void)footerRereshing
{
    if(strIsNullOrEmpty(self.searchBar.text))
    {
        [self endTableRefreshing];
        return;
    }
    
    if(self.searchList.count%10 != 0)
    {
        ZB_Toast(@"没有更多内容了");
        [self endTableRefreshing];
        return;
    }
    
    [self.searchBar resignFirstResponder];
    [self NetworkGetSearchByKeyword:self.searchBar.text andPage:(int)self.searchList.count/10+1];
}

- (void)endTableRefreshing
{
    if(self.tableView.header.isRefreshing)
    {
        [self.tableView.header endRefreshing];
    }
    
    if(self.tableView.footer.isRefreshing)
    {
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
    }
    
    if(self.searchList.count%10 == 0)
    {
        self.tableView.footer.loadMoreButton.hidden = NO;
    }
    else
    {
        self.tableView.footer.loadMoreButton.hidden = YES;
    }
    
    if(self.searchList.count == 0)
    {
        self.tableView.footer.loadMoreButton.hidden = YES;
    }
}

#pragma mark -UITableView datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamDetailModel *model = self.searchList[indexPath.row];
    
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
    return self.searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTitleTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, SearchTitleTableViewCell, @"SearchTitleTableViewCell");
    
    ExamDetailModel *model = self.searchList[indexPath.row];
    
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
    [self.searchBar resignFirstResponder];
    
    ErrorAnalysisViewController *vc = [[ErrorAnalysisViewController alloc] init];
    vc.practiceList = @[self.searchList[indexPath.row]];
    vc.DailyPracticeTitle = @"搜索题目";
    vc.isFromFirstPageSearch = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark Network
- (void)NetworkGetSearchByKeyword:(NSString *)keyword andPage:(int)page
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetSearchListByKeyWord:keyword NPage:page Success:^(id jsonData) {
        
        NSDictionary *contentDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        if([contentDict isKindOfClass:[NSArray class]])
        {
            if(page == 1)
            {
                [self.searchList removeAllObjects];
                [self.tableView reloadData];
            }
            [self endTableRefreshing];
            [SVProgressHUD dismiss];
            return;
        }
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
            
            if(page == 1)
            {
                [self.searchList removeAllObjects];
            }
            
            [self.searchList addObjectsFromArray:examList];
            [self.tableView reloadData];
        }
        
        [self endTableRefreshing];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [self endTableRefreshing];
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
    }];
}

@end
