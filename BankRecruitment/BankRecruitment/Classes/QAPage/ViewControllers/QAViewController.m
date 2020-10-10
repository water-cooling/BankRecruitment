//
//  QAViewController.m
//  Recruitment
//
//  Created by yltx on 2020/10/9.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QAViewController.h"
#import "SPPageMenu.h"
@interface QAViewController ()<UITableViewDelegate,UITableViewDataSource,SPPageMenuDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong)  SPPageMenu*pageMenu;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *QABtn;

@end

@implementation QAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pageMenu];
    [self.view addSubview:self.searchBar];
   
    // Do any additional setup after loading the view.
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
        make.height.mas_equalTo(25);
    }];
    [self.QABtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-18);
        make.centerY.equalTo(self.searchBar);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
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

#pragma mark - Getter
- (SPPageMenu *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, Screen_Width, 50) trackerStyle:SPPageMenuTrackerStyleRoundedRect];
        [_pageMenu setItems:@[@"全部",@"待支付",@"已支付",@"已取消",@"已取消",@"已取消",@"已取消"] selectedItemIndex:0];
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:16];
        _pageMenu.selectedItemTitleColor = [UIColor blackColor];
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:0 alpha:0.6];
        _pageMenu.tracker.backgroundColor = [UIColor orangeColor];
        _pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
    }
    return _pageMenu;
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-TabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
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
        _searchBar.placeholder = @"搜索主播名称";
        _searchBar.delegate = self;
        UITextField *textfield;
       if (@available(iOS 13.0, *)) {
       // 针对 13.0 以上的iOS系统进行处理
            NSUInteger numViews = [_searchBar.subviews count];
            for(int i = 0; i < numViews; i++) {
                if([[_searchBar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
                    textfield = [_searchBar.subviews objectAtIndex:i];
                }
            }
        }else {
        // 针对 13.0 以下的iOS系统进行处理
            textfield = [_searchBar valueForKey:@"_searchField"];
       }
       textfield.borderStyle = UITextBorderStyleNone;
       [textfield setBackgroundColor:[UIColor whiteColor]];
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
    UIColor*color = [UIColor colorWithHex:@"#ffffff"];
    CGFloat cornerRadius = 5;
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
        [_QABtn setBackgroundImage:[UIImage imageNamed:@"椭圆蓝"] forState:0];
        [_QABtn setTitle:@"我的\n问题" forState:UIControlStateNormal];
    }
    return _QABtn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
