//
//  CreateAddressViewController.m
//  ZhiliGou
//
//  Created by xia jianqing on 17/2/12.
//  Copyright © 2017年 ZTE. All rights reserved.
//

#import "CreateAddressViewController.h"
#import "AddressModel.h"

@interface CreateAddressViewController ()
@property (nonatomic, strong) IBOutlet UITextField* addressTextFeild;
@property (nonatomic, strong) IBOutlet UITextField* nameTextFeild;
@property (nonatomic, strong) IBOutlet UITextField* phoneTextFeild;
@property (nonatomic, strong) IBOutlet UIButton *saveBtn;
@end

@implementation CreateAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"编辑地址";
    
    [self drawViews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.addressTextFeild.text = self.addressModel.Addr;
    self.nameTextFeild.text = self.addressModel.Name;
    self.phoneTextFeild.text = self.addressModel.Tel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.view.backgroundColor = kColorBarGrayBackground;
    
    UILabel *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+43+0.5, Screen_Width, 0.5)];
    lineView.backgroundColor = kColorBarGrayBackground;
    [self.view addSubview:lineView];
    
    UILabel *lineView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+43+44+0.5, Screen_Width, 0.5)];
    lineView1.backgroundColor = kColorBarGrayBackground;
    [self.view addSubview:lineView1];
    
    self.saveBtn.layer.cornerRadius = 4;
    self.saveBtn.layer.masksToBounds = YES;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addAddressAction:(id)sender
{
    if(strIsNullOrEmpty(self.addressTextFeild.text) || strIsNullOrEmpty(self.nameTextFeild.text) || strIsNullOrEmpty(self.phoneTextFeild.text))
    {
        ZB_Toast(@"请输入完整信息");
        return;
    }
    
    if(!strIsLongTelNum(self.phoneTextFeild.text))
    {
        ZB_Toast(@"请输入合法的手机号码");
        return;
    }
    
    [LLRequestClass requestPutAddressByName:self.nameTextFeild.text Tel:self.phoneTextFeild.text Addr:self.addressTextFeild.text Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        ZB_Toast(@"编辑地址失败");
    }];
}

@end
