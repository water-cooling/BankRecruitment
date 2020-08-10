//
//  PayViewController.m
//  ZhiliGou
//
//  Created by xia jianqing on 17/2/12.
//  Copyright © 2017年 ZTE. All rights reserved.
//

#import "PayViewController.h"
#import "PayPriceTableViewCell.h"
#import "PayMethodTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataBaseManager.h"

@interface PayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger selectPayMethodIndex;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"支付订单";
    self.selectPayMethodIndex = 0;
    
    [self drawViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"paySuccessCallBack" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payFailedCallBack" object:nil];
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.tableView.backgroundColor = kColorBarBackground;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessCallBack) name:@"paySuccessCallBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailedCallBack) name:@"payFailedCallBack" object:nil];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)paySuccessCallBack
{
    ZB_Toast(@"支付成功");
    [[DataBaseManager sharedManager] deleteAllBuyCar];
    [self performSelector:@selector(backToBuyCar) withObject:nil afterDelay:0.3];
}

- (void)backToBuyCar
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)payFailedCallBack
{
    ZB_Toast(@"支付失败");
}

#pragma -mark UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 105;
    }
    else
    {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 25;
    }
    else
    {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 25)];
        subView.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, Screen_Width, 20)];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = kColorDarkText;
        label.text = @"请选择支付方式";
        [subView addSubview:label];
        label.centerY = subView.centerY;
        
        return subView;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        PayPriceTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, PayPriceTableViewCell, @"PayPriceTableViewCell");
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f元", self.totalPrice];
        return cell;
    }
    else
    {
        PayMethodTableViewCell *cell = GET_TABLE_CELL_FROM_NIB(tableView, PayMethodTableViewCell, @"PayMethodTableViewCell");
        
        if(indexPath.row == 0)
        {
            cell.payTitleLabel.text = @"支付宝支付";
            cell.payDetailLabel.text = @"推荐有支付宝账号的用户使用";
        }
        else
        {
            cell.payTitleLabel.text = @"微信支付";
            cell.payDetailLabel.text = @"推荐安装微信5.0及以上版本的用户使用";
        }
        
        if(indexPath.row == self.selectPayMethodIndex)
        {
            cell.selectImageView.image = [UIImage imageNamed:@"shopping_circle_select_p"];
        }
        else
        {
            cell.selectImageView.image = [UIImage imageNamed:@"shopping_circle_select_n"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 1)
    {
        self.selectPayMethodIndex = indexPath.row;
        [self.tableView reloadData];
    }
}

#pragma -mark NetWork
- (IBAction)payAction:(id)sender
{
    [LLRequestClass requestPayDingdanByPayID:self.payOrderID type_id:@"1" success:^(id jsonData) {
        NSDictionary *contentDic=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDic);
        NSString *result = [contentDic objectForKey:@"result"];
        if([result isEqualToString:@"success"])
        {
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:[contentDic objectForKey:@"value"] fromScheme:@"TaoZhiLi" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
            }];
        }
        else
        {
            ZB_Toast(@"支付失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        ZB_Toast(@"支付失败");
    }];
}

@end
