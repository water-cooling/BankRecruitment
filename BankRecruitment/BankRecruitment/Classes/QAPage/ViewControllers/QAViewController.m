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
@interface QAViewController ()<UITableViewDelegate,UITableViewDataSource,SPPageMenuDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong)  SPPageMenu*pageMenu;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *QABtn;
@property (nonatomic, strong) UIButton *signBtn;
@end

@implementation QAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topView];
    [self.view addSubview:self.pageMenu];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.pageMenu.mas_bottom);
        make.bottom.equalTo(self.view).offset(-TabbarSafeBottomMargin);
    }];
    [self.view addSubview:self.signBtn];
          [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.equalTo(self.view).offset(100);
              make.right.equalTo(self.view.mas_right).offset(-5);
          }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)topView{
    UIView *topView = [UIView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(StatusBarHeight);
        make.height.mas_equalTo(StatusBarAndNavigationBarHeight-StatusBarHeight);
    }];
    [topView addSubview:self.searchBar];
    [topView addSubview:self.QABtn];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(12);
        make.top.equalTo(topView).offset(9);
        make.right.equalTo(topView).offset(-52);
        make.height.mas_equalTo(30);
    }];
    [self.QABtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-18);
        make.centerY.equalTo(self.searchBar);
    }];
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar =[[UISearchBar alloc]init];
        _searchBar.placeholder = @"搜索问题";
        _searchBar.delegate = self;
        UITextField *textfield;
       if (@available(iOS 13.0, *)) {
       // 针对 13.0 以上的iOS系统进行处理
           textfield = _searchBar.searchTextField;
        }else {
        // 针对 13.0 以下的iOS系统进行处理
            textfield = [_searchBar valueForKey:@"_searchField"];
       }
        textfield.layer.cornerRadius = 15;
        textfield.layer.masksToBounds = YES;
       textfield.borderStyle = UITextBorderStyleNone;
       [textfield setBackgroundColor:[UIColor colorWithHex:@"#FFFFFF"]];
       for (UIView *view in _searchBar.subviews) {
           for (UIView * subviews in view.subviews) {
               if ( [ subviews isKindOfClass:NSClassFromString(@"UISearchBarBackground").class]) {
                   subviews.alpha = 0;
               }
           }
       }
        [[UISearchBar appearance] setSearchFieldBackgroundImage:[self searchFieldBackgroundImage] forState:UIControlStateNormal];
        [textfield setDefaultTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.5]}];
        _searchBar.searchTextPositionAdjustment = UIOffsetMake(7, 0);
//        _searchBar.inputAccessoryView = [self addToolbar];

    }
    return _searchBar;
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
- (UIButton *)QABtn {
    if (!_QABtn) {
        _QABtn = [[UIButton alloc] init];
        [_QABtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _QABtn.titleLabel.font = [UIFont systemFontOfSize:9];
        _QABtn.titleLabel.numberOfLines = 0;
        [_QABtn setBackgroundImage:[UIImage imageNamed:@"椭圆蓝"] forState:0];
        [_QABtn setTitle:@"我的\n问题" forState:UIControlStateNormal];
    }
    return _QABtn;
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
