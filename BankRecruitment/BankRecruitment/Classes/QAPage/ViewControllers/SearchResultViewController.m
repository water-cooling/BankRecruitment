//
//  SearchResultViewController.m
//  Recruitment
//
//  Created by yltx on 2020/10/15.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger pageNo;
@property (strong, nonatomic) UIImageView *placehodleImg;
@property (strong, nonatomic) UILabel *placehodleTitle;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)initUI{
      [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
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

@end
