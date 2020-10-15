//
//  MyQuestionViewController.m
//  Recruitment
//
//  Created by yltx on 2020/10/15.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "QATableViewCell.h"
@interface MyQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger pageNo;
@property (strong, nonatomic) UIImageView *placehodleImg;
@property (strong, nonatomic) UILabel *placehodleTitle;


@end

@implementation MyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawViews];
    [self initUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我要提问";
    // Do any additional setup after loading the view.
}

- (void)drawViews{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
