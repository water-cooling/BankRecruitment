//
//  ErrorAnswerSheetViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/21.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ErrorAnswerSheetViewController.h"
#import "SimpleMoreView.h"
#import "ExamDetailModel.h"

@interface ErrorAnswerSheetViewController ()
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) IBOutlet UILabel *answerTitleLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *answerSheetScrollView;
@property (nonatomic, strong) UIButton *backButton;
@property (strong, nonatomic) SimpleMoreView *moreView;
@property (strong, nonatomic) UIButton *quitMoreButton;
@property (nonatomic, strong) UIView *whiteScrollBackView;

//@property (nonatomic, strong) NSMutableDictionary *realResultDict;

@end

@implementation ErrorAnswerSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshViewByDayNightType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"答题卡";
    self.answerTitleLabel.text = @"";
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [_backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(65.0f, 0.0f, 25.0f, 25.0f);
    [_moreBtn setImage:[UIImage imageNamed:@"day_shiti_icon_more"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_moreBtn];
    
    self.answerSheetScrollView.backgroundColor = kColorBarGrayBackground;
    UIButton *lastButton = nil;
    for(int index=0; index<self.practiceList.count; index++)
    {
        //创建一个视图
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        ExamDetailModel *examModel = self.practiceList[index];
        [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if([examModel.isOK isEqualToString:@"是"])
        {
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_right"] forState:UIControlStateNormal];
        }
        else if([examModel.isOK isEqualToString:@"否"])
        {
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_wrong-1"] forState:UIControlStateNormal];
        }
        else
        {
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_selected"] forState:UIControlStateNormal];
        }
//        if([LdGlobalObj sharedInstanse].isNightExamFlag)
//        {
//            [functionBtn setBackgroundImage:[UIImage imageNamed:@"night_datika_circle_selected"] forState:UIControlStateNormal];
//            [functionBtn setTitleColor:UIColorFromHex(0x667aa1) forState:UIControlStateNormal];
//        }
//        else
//        {
//            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_selected"] forState:UIControlStateNormal];
//            [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
        functionBtn.tag = index;
        
        functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [functionBtn setTitle:[NSString stringWithFormat:@"%d", index+1] forState:UIControlStateNormal];
        [functionBtn addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        int hang = index/4;
        int lie = index%4;
        int firstkongxi = 30;
        int kongxi = (Screen_Width - 160 - firstkongxi*2)/3;
        
        functionBtn.frame = CGRectMake(firstkongxi+kongxi*(lie)+40*lie, 15*(hang+1)+50*hang, 40, 40);
        
        //把视图添加到当前的滚动视图中
        [self.answerSheetScrollView addSubview:functionBtn];
        lastButton = functionBtn;
    }
    [self.answerSheetScrollView setContentSize:CGSizeMake(100, lastButton.bottom+20)];
    
    _whiteScrollBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, Screen_Width, lastButton.bottom+18)];
    [self.answerSheetScrollView insertSubview:_whiteScrollBackView atIndex:0];
}

- (void)refreshViewByDayNightType
{
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x7a8596) ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x2b3f5d);
        
        self.view.backgroundColor = UIColorFromHex(0x2b3f5d);
        _whiteScrollBackView.backgroundColor = UIColorFromHex(0x20282f);
        self.answerSheetScrollView.backgroundColor = UIColorFromHex(0x20282f);
        [self.moreBtn setImage:[UIImage imageNamed:@"night_icon_more"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        self.answerTitleLabel.textColor = UIColorFromHex(0x666666);
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];        
        self.view.backgroundColor = kColorBarGrayBackground;
        _whiteScrollBackView.backgroundColor = [UIColor whiteColor];
        self.answerSheetScrollView.backgroundColor = [UIColor whiteColor];
        [self.moreBtn setImage:[UIImage imageNamed:@"day_shiti_icon_more"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
        self.answerTitleLabel.textColor = UIColorFromHex(0x444444);
    }
    
//    for(UIView *subView in self.answerSheetScrollView.subviews)
//    {
//        if([subView isKindOfClass:[UIButton class]])
//        {
//            UIButton *functionBtn = (UIButton *)subView;
//            if([LdGlobalObj sharedInstanse].isNightExamFlag)
//            {
//                [functionBtn setBackgroundImage:[UIImage imageNamed:@"night_datika_circle_selected"] forState:UIControlStateNormal];
//                [functionBtn setTitleColor:UIColorFromHex(0x667aa1) forState:UIControlStateNormal];
//            }
//            else
//            {
//                [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_selected"] forState:UIControlStateNormal];
//                [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            }
//
//        }
//    }
}

- (IBAction)moreAction:(id)sender
{
    if(self.moreView)
    {
        [self quitMoreButtonAction];
    }
    
    [self.moreView removeFromSuperview];
    self.moreView = nil;
    self.moreView = [[[NSBundle mainBundle] loadNibNamed:@"SimpleMoreView" owner:nil options:nil] firstObject];
    self.moreView.frame = CGRectMake(Screen_Width-110, StatusBarAndNavigationBarHeight, 110, 40);
    self.moreView.backgroundColor = kColorNavigationBar;
    self.moreView.moreSegmentCtl.tintColor = [UIColor whiteColor];
    self.moreView.moreSegmentCtl.selectedSegmentIndex = [LdGlobalObj sharedInstanse].isNightExamFlag ? 0 : 1;
    [self.view addSubview:self.moreView];
    self.moreView.layer.borderColor = UIColorFromHex(0x1e9aed).CGColor;
    self.moreView.layer.borderWidth = 1;
    self.moreView.layer.masksToBounds = YES;
    [self.quitMoreButton removeFromSuperview];
    self.quitMoreButton = nil;
    self.quitMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.quitMoreButton addTarget:self action:@selector(quitMoreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.quitMoreButton belowSubview:self.moreView];
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        self.moreView.backgroundColor = UIColorFromHex(0x2b3f5d);
        self.moreView.moreSegmentCtl.tintColor = [UIColor whiteColor];
        self.moreView.layer.borderColor = UIColorFromHex(0x284a92).CGColor;
    }
    else
    {
        self.moreView.backgroundColor = kColorNavigationBar;
        self.moreView.moreSegmentCtl.tintColor = [UIColor whiteColor];
        self.moreView.layer.borderColor = UIColorFromHex(0x1e9aed).CGColor;
    }
    self.moreView.layer.borderWidth = 1;
    self.moreView.layer.masksToBounds = YES;
    
    LL_WEAK_OBJC(self);
    self.moreView.moreSegmentCtlChangeBlock = ^(BOOL isNight){
        [weakself quitMoreButtonAction];
        
        [LdGlobalObj sharedInstanse].isNightExamFlag = isNight;
        [weakself refreshViewByDayNightType];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[NSNumber numberWithBool:isNight] forKey:@"isNightExamFlag"];
        [def synchronize];
    };
}

- (void)quitMoreButtonAction
{
    [self.moreView removeFromSuperview];
    self.moreView = nil;
    [self.quitMoreButton removeFromSuperview];
    self.quitMoreButton = nil;
}

- (void)backButtonPressed
{
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.1];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)functionBtnAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorAnswerSheetTouchExamBtnNotification" object:[NSNumber numberWithInteger:button.tag]];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.1];
}

@end
