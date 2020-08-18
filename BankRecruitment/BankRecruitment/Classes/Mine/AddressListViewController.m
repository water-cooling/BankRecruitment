//
//  AddressViewController.m
//  YLSC
//
//  Created by EDZ on 2018/5/16.
//  Copyright © 2018年 qitenginfo. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressTableViewCell.h"
#import "CreateAddressViewController.h"
#import "AddressModel.h"

@interface AddressListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) AddressModel *addressModel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *placehodleImg;
@property (strong, nonatomic) UILabel *noAddressLab;
@property (strong, nonatomic) UIButton *createBtn;
@end



@implementation AddressListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDataAddressList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.view.backgroundColor = [UIColor whiteColor];
    self.placehodleImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noaddress"]];
    self.title = @"地址列表";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.noAddressLab = [[UILabel alloc] init];
    self.noAddressLab.font = [UIFont systemFontOfSize:15];
    self.noAddressLab.textAlignment = NSTextAlignmentCenter;
        self.noAddressLab.textColor = [UIColor colorWithHex:@"#333333"];
        self.noAddressLab.text = @"您还没有收获地址哦～";
    [self.view addSubview:self.noAddressLab];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.placehodleImg];
    self.tableView.hidden = YES;
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
    [self.view addSubview:self.createBtn];
    [self.createBtn addTarget:self action:@selector(creatNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-22.5);
        make.width.mas_equalTo(Screen_Width-64);
        make.height.mas_equalTo(40);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}
- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatNewAddress{
    CreateAddressViewController *vc = [[CreateAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getDataAddressList {
    [LLRequestClass requestGetAddressBySuccess:^(id jsonData) {
           NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
           NSLog(@"%@", contentArray);
           if(contentArray.count > 0)
           {
               NSDictionary *contentDict = contentArray.firstObject;
               NSString *result = [contentDict objectForKey:@"result"];
               if([result isEqualToString:@"success"]){
                   self.tableView.hidden = NO;
                   self.placehodleImg.hidden = YES;
                   self.noAddressLab.hidden = YES;
                   self.createBtn.hidden = YES;
                   self.addressModel = [AddressModel model];
                   [self.addressModel setDataWithDic:contentDict];
                   [self.tableView reloadData];
               }else{
                   self.tableView.hidden = YES;
                   self.placehodleImg.hidden = NO;
                   self.noAddressLab.hidden = NO;
                   self.createBtn.hidden = NO;
               }
           }
       } failure:^(NSError *error) {
           self.tableView.hidden = YES;
           self.placehodleImg.hidden = NO;
           self.noAddressLab.hidden = NO;
           self.createBtn.hidden = NO;
           NSLog(@"%@",error);
       }];
}



#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressModel ? 1 : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.receiveNameLab.text     = self.addressModel.Name;
    cell.receivePhoneLab.text    = self.addressModel.Tel;
    cell.addressLab.text  = self.addressModel.Addr;
    [cell.editBtn addTarget:self action:@selector(editAddress) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)editAddress{
    CreateAddressViewController *vc = [[CreateAddressViewController alloc] init];
    vc.addressModel = self.addressModel;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

- (UITableView *)tableView{
    if ( !_tableView ){
        _tableView                 = [[UITableView alloc] init];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [[UIButton alloc] init];
        [_createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _createBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _createBtn.layer.cornerRadius = 20;
        _createBtn.backgroundColor = KColorBlueText;
        [_createBtn setTitle:@"新建收货地址" forState:UIControlStateNormal];
    }
    return _createBtn;
}

@end

