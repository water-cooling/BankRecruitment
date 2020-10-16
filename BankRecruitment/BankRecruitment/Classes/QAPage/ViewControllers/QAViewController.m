//
//  QAViewController.m
//  Recruitment
//
//  Created by yltx on 2020/10/9.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QAViewController.h"
#import "SPPageMenu.h"
#import "QATableViewCell.h"
#import "SubmitQuestionViewController.h"
#import "MyQuestionViewController.h"
#import "YLSPGoodsSearchView.h"
#import "SearchViewController.h"
@interface QAViewController ()<UITableViewDelegate,UITableViewDataSource,SPPageMenuDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong)  SPPageMenu*pageMenu;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) YLSPGoodsSearchView * searchView;
@property (nonatomic, strong) SearchViewController * searchListVc;
@property (nonatomic, strong) UIButton *QABtn;
@property (nonatomic, strong) UIButton *signBtn;
@end

@implementation QAViewController
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
    [self topView];
    [self initUI];
}
-(void)topView{
     self.searchView = [[YLSPGoodsSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, StatusBarAndNavigationBarHeight)];
    [self.view addSubview:self.searchView];
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
    self.searchListVc = [SearchViewController new];
    self.searchListVc.view.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, Screen_Height-StatusBarAndNavigationBarHeight-TabbarSafeBottomMargin);
    [self.view addSubview:self.searchListVc.view];
    [self setupChildView:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.searchView.SeachBar resignFirstResponder];
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
    [self setupChildView:YES];
    [self.searchView showSearchViewAnimation];
    return YES;
}

- (void)cancelBtnClicked:(UIButton *)sender {
    if (self.searchView.SeachBar.text.length) {
        [self.searchView showSearchViewAnimation];
        [self setupChildView: YES];
        [self.searchView.SeachBar resignFirstResponder];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (void)setupChildView:(BOOL)Send {
    if (Send) {
        [self.view sendSubviewToBack:self.searchListVc.view];
    }else{
        [self.view bringSubviewToFront:self.searchListVc.view];
    }
}
-(void)ReturnBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
    //    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QATableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QATableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
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
    switch (index) {
        case 0:
        {
            self.status = @"";
        }
            break;
        case 1:{
            self.status = @"0";
        }
            break;
        case 2:
        {
            self.status = @"1";
        }
            break;
        case 3:
        {
            self.status = @"2";
        }
            break;
        default:
            break;
    }
    [self.dataArr removeAllObjects];
    self.pageNo = 1;
}

-(void)signClick{
    SubmitQuestionViewController *submitVc = [SubmitQuestionViewController new];
    submitVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:submitVc animated:YES];
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
        [_pageMenu setItems:@[@"全部",@"待支付",@"已支付",@"已取消",@"已取消",@"已取消",@"已取消"] selectedItemIndex:0];
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
        
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _tableview;
}
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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

- (UIButton *)signBtn {
    if (!_signBtn) {
        _signBtn = [[UIButton alloc] init];
        [_signBtn setBackgroundImage:[UIImage imageNamed:@"tiwen"] forState:0];
        [_signBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signBtn;
}
@end
