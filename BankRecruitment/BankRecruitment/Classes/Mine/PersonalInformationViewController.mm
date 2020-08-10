//
//  PersonalInformationViewController.m
//  Chengshishuo
//
//  Created by xiajianqing on 15/12/2.
//  Copyright © 2015年 Longlian. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "GTMBase64.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface PersonalInformationViewController ()

@property (nonatomic, strong) IBOutlet UIButton *headBtn;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *sexTextField;

@property (nonatomic, strong) NSString *imageUrlString;

@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人信息";
    self.imageUrlString = @"";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self drawViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 20.0f);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.headBtn.layer.cornerRadius = 40;
    self.headBtn.layer.masksToBounds = YES;
    self.nameTextField.text = [LdGlobalObj sharedInstanse].user_name;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitButtonPressed
{
    if(strIsNullOrEmpty(self.nameTextField.text))
    {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称" duration:kHttpRequestFailedShowTime];
        return;
    }
    
    [self requestSetPet:self.nameTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.sexTextField)
    {
        LdActionSheet *sheet = [[LdActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
        [sheet showInView:self.view];
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - UIImagePickerController

- (IBAction)headImageBtnAction:(id)sender
{
//    //上传图像
//    LdActionSheet *sheet = [[LdActionSheet alloc] initWithTitle:@"筛选"
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:@"手机相册"
//                                              otherButtonTitles: @"系统拍照",
//                            nil];
//    [sheet showInView:self.view];
}

#pragma -mark Network
- (void)requestSetPet:(NSString *)Pet
{
    [LLRequestClass requestmodifyNameByPet:Pet success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            NSString *msg = [contentDict objectForKey:@"msg"];
            if([result isEqualToString:@"success"])
            {
                ZB_Toast(@"修改成功");
                
                [LdGlobalObj sharedInstanse].user_name = Pet;
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                ZB_Toast(msg);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
