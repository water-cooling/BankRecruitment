//
//  InviteListViewController.m
//  Recruitment
//
//  Created by yltx on 2020/10/19.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "InviteListViewController.h"
#import "InviteListTableViewCell.h"
@interface InviteListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIImageView *placehodleImg;
@property (strong, nonatomic) UILabel *noAddressLab;
@end

@implementation InviteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请记录";
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.placehodleImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData"]];

    self.noAddressLab = [[UILabel alloc] init];
    self.noAddressLab.font = [UIFont systemFontOfSize:15];
    self.noAddressLab.textAlignment = NSTextAlignmentCenter;
        self.noAddressLab.textColor = [UIColor colorWithHex:@"#333333"];
        self.noAddressLab.text = @"暂无记录";
    [self.view addSubview:self.noAddressLab];
    [self.view addSubview:self.placehodleImg];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.placehodleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(145, 145));
    }];
    [self.noAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
          make.height.mas_equalTo(15);
          make.top.equalTo(self.placehodleImg.mas_bottom).offset(33);
      }];
    // Do any additional setup after loading the view.
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InviteListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InviteListTableViewCell" forIndexPath:indexPath];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (UITableView *)tableView {
    if (_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"InviteListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InviteListTableViewCell"];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    return _tableView;
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
