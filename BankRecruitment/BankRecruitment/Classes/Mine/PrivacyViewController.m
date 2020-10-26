//
//  PrivacyViewController.m
//  Recruitment
//
//  Created by humengfan on 2020/10/19.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()
@property (nonatomic,strong)UITextView *textView;
@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私协议";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"银行易考最新隐私协议"ofType:@"txt"]encoding:NSUTF8StringEncoding error:&error];
    if (textFileContents == nil) {
    NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
    }else{
        self.textView.text = textFileContents;
    }
    // Do any additional setup after loading the view.
}
- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = UIColorFromRGB(0x333333);
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.editable = NO;
        _textView.textContainerInset = UIEdgeInsetsZero;
    }
    return _textView;
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
