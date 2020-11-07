//
//  SearchResultViewController.m
//  Recruitment
//
//  Created by yltx on 2020/10/15.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "SearchViewController.h"
#import "MJRefresh.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) UIImageView *placehodleImg;
@property (strong, nonatomic) UILabel *placehodleTitle;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
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

-(void)setSearchStr:(NSString *)searchStr{
    _searchStr = searchStr;
    [self.dataArr removeAllObjects];
    [self getQuestionListquest:searchStr];
}

-(void)getQuestionListquest:(NSString *)searchStr{
    [self.view showActivityViewAtCenter];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@(1) forKey:@"pageNo"];
    [dict setValue:@(10) forKey:@"pageSize"];
    [dict setValue:searchStr forKey:@"q"];
    [NewRequestClass requestQuestionList:dict success:^(id jsonData) {
        [self.view hideActivityViewAtCenter];
        if (jsonData[@"data"][@"response"][@"rows"]) {
            for (NSDictionary *dict in jsonData[@"data"][@"response"][@"rows"]){
                QuestionListModel * model = [QuestionListModel mj_objectWithKeyValues:dict];
                [self.dataArr addObject:model];
            }
        };
        if (self.dataArr.count == 0) {
            self.tableview.hidden = YES;
            self.placehodleImg.hidden = NO;
            self.placehodleTitle.hidden = NO;
        }else{
            self.tableview.hidden = NO;
            self.placehodleImg.hidden = YES;
            self.placehodleTitle.hidden = YES;
        }
        [self.tableview reloadData];
    } failure:^(NSError *error) {
       if (self.dataArr.count == 0) {
            self.tableview.hidden = YES;
            self.placehodleImg.hidden = NO;
            self.placehodleTitle.hidden = NO;
        }else{
            self.tableview.hidden = NO;
            self.placehodleImg.hidden = YES;
            self.placehodleTitle.hidden = YES;
        }
       [self.view hideActivityViewAtCenter];
    }];
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
      cell.imageView.image = [UIImage imageNamed:@"搜索"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    QuestionListModel * model  = self.dataArr[indexPath.row];
          cell.textLabel.text = model.title;
          cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestionListModel * model  = self.dataArr[indexPath.row];
    if (self.block) {
        self.block(model);
    }
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-TabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight =0;
        _tableview.estimatedSectionHeaderHeight =0;
        _tableview.estimatedSectionFooterHeight =0;
        _tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableview];
        _tableview.tableFooterView = [UIView new];
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
