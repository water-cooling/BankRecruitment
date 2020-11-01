//
//  SignViewController.m
//  Recruitment
//
//  Created by yltx on 2020/8/13.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "SignViewController.h"
#import "ExaminationPaperViewController.h"
#import "AlerSignView.h"
@interface SignViewController ()
@property (weak, nonatomic) IBOutlet UILabel *signDayLab;
@property (weak, nonatomic) IBOutlet UIImageView *signBg;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (nonatomic,strong)AlerSignView *signView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signDayBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signDayLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottom;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.title = @"天天签到";
   self.signDayLab.text = [NSString stringWithFormat:@"已连续签到%@天", [LdGlobalObj sharedInstanse].user_SignDays];
     if(isSignAppToday([LdGlobalObj sharedInstanse].user_LastSign)){
         self.signBtn.userInteractionEnabled = NO;
         [self.signBtn setTitle:self.signDayLab.text forState:0];
     }
    self.signDayBottom.constant = -120*kMulriple;
    self.signDayLeft.constant = 40*kMulriple;
    self.signBtnTop.constant = 145*kMulriple;
    self.titleBottom.constant = 15*kMulriple;
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)signClick:(id)sender {
    [self NetworkAppEveryDaySign];
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)dayPractiiesClick:(id)sender {
    ExaminationPaperViewController *vc = [[ExaminationPaperViewController alloc] init];
           vc.examinationPaperType = ExaminationPaperDailyPracticeType;
           vc.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:vc animated:YES];
}

/**
 每日签到
 */
- (void)NetworkAppEveryDaySign{
   
    [LLRequestClass requestSignAppSuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        
        if([contentArray isKindOfClass:[NSDictionary class]]){
            ZB_Toast(@"签到失败");
            return;
        }
        if(contentArray.count > 0){
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                ZB_Toast(@"已签到");
                [LdGlobalObj sharedInstanse].user_acc = contentDict[@"acc"];
                [LdGlobalObj sharedInstanse].user_LastSign = contentDict[@"LastSign"];
                [LdGlobalObj sharedInstanse].user_SignDays = contentDict[@"SignDays"];
                
                self.signBtn.userInteractionEnabled = NO;
                AlerSignView *signView = [[AlerSignView alloc] initWithFrame:CGRectMake(0, 0,Screen_Width,Screen_Height) withSignDay:contentDict[@"SignDays"]];
                [self.view addSubview:signView];
                self.signDayLab.text = [NSString stringWithFormat:@"已连续签到%@天", [LdGlobalObj sharedInstanse].user_SignDays];
                [self.signBtn setTitle:self.signDayLab.text forState:0];
                return;
            }
        }
        ZB_Toast(@"签到失败");
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

@end
