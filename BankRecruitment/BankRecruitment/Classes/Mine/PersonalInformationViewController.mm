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

@interface PersonalInformationViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *saveBtn;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) NSString *imageUrlString;

@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"昵称";
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
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.saveBtn.layer.cornerRadius = 20;
    self.saveBtn.layer.masksToBounds = YES;
    [self.saveBtn addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.nameTextField.delegate = self;
    self.nameTextField.text = [LdGlobalObj sharedInstanse].user_name;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChangeSelection:(UITextField *)textField{
    NSLog(@"改变");
    //手机号码校验
    if (self.nameTextField.text.length > 0) {
            self.saveBtn.enabled = YES;
            self.saveBtn.backgroundColor = [UIColor colorWithHex:@"#558CF4"];
        } else {
            self.saveBtn.enabled = NO;
            self.saveBtn.backgroundColor = [UIColor colorWithHex:@"#DCDCDC"];
        }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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
