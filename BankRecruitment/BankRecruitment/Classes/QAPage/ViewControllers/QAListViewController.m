//
//  QAViewController.m
//  Recruitment
//
//  Created by yltx on 2020/10/9.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QAListViewController.h"
#import "SPPageMenu.h"
#import "QATableViewCell.h"
#import "SubmitQuestionViewController.h"
#import "MyQuestionViewController.h"
#import "YLSPGoodsSearchView.h"
#import "SearchViewController.h"
#import "QACategoryListModel.h"
#import "QuestionListModel.h"
#import "MJRefresh.h"
#import "QuestionDetailViewController.h"
#import "SignViewController.h"
@interface QAListViewController ()<UITableViewDelegate,UITableViewDataSource,SPPageMenuDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong)  SPPageMenu*pageMenu;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, strong) QACategoryListModel *selectCodeModel;
@property (nonatomic, strong) YLSPGoodsSearchView * searchView;
@property (nonatomic, strong) SearchViewController * searchListVc;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *signBtn;
@property (strong, nonatomic) UIImageView *placehodleImg;
@property (strong, nonatomic) UILabel *placehodleTitle;

@end

@implementation QAListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    [self topView];
    [self initUI];
    [self setIOS:self.tableview];
    [self getQuestionCatsquest];
    [self setupRefreshTable:self.tableview needsFooterRefresh:YES];
    
}
#pragma mark --fresh
-(void)reloadHeaderTableViewDataSource{
    self.pageNo = 1;
    [self.tableview.mj_footer resetNoMoreData];
    [self.dataArr removeAllObjects];
    [self getQuestionListquest:self.selectCodeModel.questionCatCode];
}

-(void)reloadFooterTableViewDataSource{
    self.pageNo ++;
    [self getQuestionListquest:self.selectCodeModel.questionCatCode];
}
-(void)topView{
     self.searchView = [[YLSPGoodsSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, StatusBarAndNavigationBarHeight)];
    [self.view addSubview:self.searchView];
    self.searchView.SeachBar.delegate = self;
    [self.searchView.SeachBar addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.searchView.QABtn addTarget:self action:@selector(myQuestionClick) forControlEvents:UIControlEventTouchUpInside];
       [self.searchView.cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
       [self.searchView.SeachBar addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
}
-(void)initUI{
  [self.view addSubview:self.pageMenu];
       [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.equalTo(self.view);
           make.top.equalTo(self.pageMenu.mas_bottom);
           make.bottom.equalTo(self.view).offset(-TabbarSafeBottomMargin);
       }];
        [self.view addSubview:self.signBtn];
      [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.view).offset(100);
          make.right.equalTo(self.view.mas_right).offset(-5);
    }];
    [self.view addSubview:self.submitBtn];
  [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.signBtn.mas_bottom).offset(20);
      make.right.equalTo(self.view.mas_right).offset(-5);
}];
    self.searchListVc = [SearchViewController new];
    self.searchListVc.view.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, Screen_Height-StatusBarAndNavigationBarHeight-TabbarSafeBottomMargin);
    MJWeakSelf;
    self.searchListVc.block = ^(QuestionListModel *model) {
        [weakSelf.searchView showSearchViewAnimation];
        [weakSelf setupChildView: YES];
        [weakSelf.searchView.SeachBar resignFirstResponder];
        QuestionDetailViewController * detailVc = [QuestionDetailViewController new];
        detailVc.questionId = model.questionId;
        detailVc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:detailVc animated:YES];
    };
    [self.view addSubview:self.searchListVc.view];
    [self setupChildView:YES];
     self.placehodleImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData"]];
          self.placehodleTitle = [[UILabel alloc] init];
          self.placehodleTitle.font = [UIFont systemFontOfSize:15];
          self.placehodleTitle.textAlignment = NSTextAlignmentCenter;
            self.placehodleTitle.hidden = YES;
              self.placehodleTitle.textColor = [UIColor colorWithHex:@"#999999"];
              self.placehodleTitle.text = @"暂无数据";
          [self.view addSubview:self.placehodleTitle];
          [self.view addSubview:self.placehodleImg];
        self.placehodleImg.hidden = YES;
          [self.placehodleImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(142, 104));
            }];
            [self.placehodleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                  make.height.mas_equalTo(15);
                  make.top.equalTo(self.placehodleImg.mas_bottom).offset(33);
              }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.searchView.SeachBar resignFirstResponder];
}
#pragma mark - NetWorking

-(void)getQuestionCatsquest{
    [NewRequestClass requestQuestionCats:nil success:^(id jsonData) {
        NSDictionary *content=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        if (content[@"data"][@"response"][@"rows"]) {
            self.categoryArr = [QACategoryListModel mj_objectArrayWithKeyValuesArray:content[@"data"][@"response"][@"rows"]];
            NSMutableArray *arrStr = [NSMutableArray array];
            for (QACategoryListModel * model in self.categoryArr) {
                [arrStr addObject:model.questionCatCodeName];
            }
            [_pageMenu setItems:arrStr.copy selectedItemIndex:0];
            self.selectCodeModel = self.categoryArr.firstObject;
          
        };

    } failure:^(NSError *error) {
        
    }];
}
-(void)getQuestionListquest:(NSString *)code{
    [self.view showActivityViewAtCenter];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.pageNo) forKey:@"pageNo"];
    [dict setValue:@(10) forKey:@"pageSize"];
    [dict setValue:code forKey:@"questionCatCode"];
    [NewRequestClass requestQuestionList:dict success:^(id jsonData) {
        [self.view hideActivityViewAtCenter];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (jsonData[@"data"][@"response"][@"rows"]) {
            for (NSDictionary *dict in jsonData[@"data"][@"response"][@"rows"]){
                QuestionListModel * model = [QuestionListModel mj_objectWithKeyValues:dict];
                CGFloat height = [model.title sizeWithFont:14 textSizeWidht:Screen_Width-28 textSizeHeight:CGFLOAT_MAX].height;
                model.Cellheight = 92+height;
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count == 0) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
                self.tableview.hidden = YES;
                self.placehodleImg.hidden = NO;
                self.placehodleTitle.hidden = NO;
            }else{
                self.tableview.hidden = NO;
                self.placehodleImg.hidden = YES;
                self.placehodleTitle.hidden = YES;
            }
            [self.tableview reloadData];
        };

    } failure:^(NSError *error) {
        [self.view hideActivityViewAtCenter];
         self.tableview.hidden = YES;
        self.placehodleImg.hidden = NO;
        self.placehodleTitle.hidden = NO;
    }];
}


#pragma mark - UITextFieldActions
- (void)textFieldDidBegin:(UITextField *)field {
    [self.searchView showCanncelAnimation];
    [self setupChildView:NO];
}
- (void)textFieldChanged:(UITextField *)field {

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return NO;
    }
    [textField resignFirstResponder];
    self.searchListVc.searchStr = textField.text;
    return YES;
}
- (void)cancelBtnClicked:(UIButton *)sender {
        [self.searchView showSearchViewAnimation];
        [self setupChildView: YES];
        [self.searchView.SeachBar resignFirstResponder];
}
- (void)setupChildView:(BOOL)Send {
    if (Send) {
        if (self.dataArr.count == 0) {
            self.searchListVc.view.hidden = YES;
            self.placehodleImg.hidden = NO;
            self.placehodleTitle.hidden = NO;
        }else{
            self.searchListVc.view.hidden = YES;
            self.placehodleImg.hidden = YES;
            self.placehodleTitle.hidden = YES;
        }
    }else{
        self.searchListVc.view.hidden = NO;
        self.placehodleImg.hidden = YES;
        self.placehodleTitle.hidden = YES;
        
    }
}
-(void)ReturnBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionListModel * model  = self.dataArr[indexPath.section];
    return model.Cellheight;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
   return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QATableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QATableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QuestionListModel * model  = self.dataArr[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionDetailViewController * detailVc = [QuestionDetailViewController new];
    QuestionListModel * model  = self.dataArr[indexPath.section];
    detailVc.questionId = model.questionId;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
    view.backgroundColor = [UIColor colorWithHex:@"#F3F3F3"];
    return view;
}
#pragma mark - SPPageMenuDelegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index{
    self.selectCodeModel = self.categoryArr[index];
    [self.dataArr removeAllObjects];
    self.pageNo = 1;
    [self getQuestionListquest:self.selectCodeModel.questionCatCode];
}

-(void)submitClick{
    SubmitQuestionViewController *submitVc = [SubmitQuestionViewController new];
    submitVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:submitVc animated:YES];
}
-(void)signClick{
    SignViewController * signVC = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
    signVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signVC animated:YES];
}

-(void)myQuestionClick{
    MyQuestionViewController *MyQuestionVc = [MyQuestionViewController new];
       MyQuestionVc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:MyQuestionVc animated:YES];
}

#pragma mark - Getter
- (SPPageMenu *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, 50)];
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:16];
        _pageMenu.selectedItemTitleColor = [UIColor blackColor];
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _pageMenu;
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-TabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerNib:[UINib nibWithNibName:@"QATableViewCell" bundle:nil] forCellReuseIdentifier:@"QATableViewCell"];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = kColorBarGrayBackground;
        [self.view addSubview:_tableview];
        _tableview.estimatedRowHeight =0;
        _tableview.estimatedSectionHeaderHeight =0;
        _tableview.estimatedSectionFooterHeight =0;
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _tableview;
}
- (UIImage*)searchFieldBackgroundImage {
    UIColor*color = [UIColor colorWithHex:@"#F0F0F0"];
    CGFloat cornerRadius = 12.5;
    CGRect rect =CGRectMake(0,0,28,28);
    
    UIBezierPath*roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth=0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setBackgroundImage:[UIImage imageNamed:@"tiwen"] forState:0];
        [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
- (UIButton *)signBtn {
    if (!_signBtn) {
        _signBtn = [[UIButton alloc] init];
        [_signBtn setBackgroundImage:[UIImage imageNamed:@"签到"] forState:0];
        [_signBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signBtn;
}
@end
