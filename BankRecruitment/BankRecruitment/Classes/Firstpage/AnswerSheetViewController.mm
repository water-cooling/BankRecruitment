//
//  AnswerSheetViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/31.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "AnswerSheetViewController.h"
#import "ErrorAnalysisViewController.h"
#import "SimpleMoreView.h"
#import "ExerciseReportViewController.h"
#import "BBAlertView.h"
#import "ExamDetailModel.h"
#import "DataBaseManager.h"

@interface AnswerSheetViewController ()<BBAlertViewDelegate>
@property (nonatomic, strong) UIButton *timerRightButton;
//@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UILabel *answerTitleLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *answerSheetScrollView;
@property (nonatomic, strong) UIButton *backButton;
@property (strong, nonatomic) SimpleMoreView *moreView;
@property (strong, nonatomic) UIButton *quitMoreButton;
@property (nonatomic, strong) UIView *whiteScrollBackView;

@property (nonatomic, strong) NSMutableDictionary *realResultDict;

@end

@implementation AnswerSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.realResultDict = [NSMutableDictionary dictionaryWithCapacity:9];
    for(NSNumber *indexNumber in self.userResultDict.allKeys)
    {
        NSDictionary *resultDict = self.userResultDict[indexNumber];
        if(resultDict[@"Answer"])
        {
            [self.realResultDict setObject:[NSDictionary dictionaryWithDictionary:self.userResultDict[indexNumber]] forKey:indexNumber];
        }
    }
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshViewByDayNightType];
}

- (void)dealloc
{
    [[LdGlobalObj sharedInstanse] removeObserver:self forKeyPath:@"examTimerNumber"];
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
    
    self.timerRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timerRightButton.frame = CGRectMake(0.0f, 0.0f, 45.0f, 25.0f);
    [self.timerRightButton setTitle:@"00:00" forState:UIControlStateNormal];
    self.timerRightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.timerRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [self.timerRightButton addTarget:self action:@selector(timerRightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
//    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _moreBtn.frame = CGRectMake(65.0f, 0.0f, 25.0f, 25.0f);
//    [_moreBtn setImage:[UIImage imageNamed:@"day_shiti_icon_more"] forState:UIControlStateNormal];
//    [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 44)];
//    [rightBarView addSubview:_timerRightButton];
//    [rightBarView addSubview:_moreBtn];
//    _timerRightButton.centerY = rightBarView.height/2;
//    _moreBtn.centerY = rightBarView.height/2;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.timerRightButton];
    
    self.submitButton.layer.cornerRadius = 4;
    self.submitButton.layer.masksToBounds = YES;
    self.answerSheetScrollView.backgroundColor = kColorBarGrayBackground;
    
    UIButton *lastButton = nil;
    for(int index=0; index<[self.practiceList count]; index++)
    {
        //创建一个视图
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        NSString *result = self.realResultDict[[NSNumber numberWithInteger:index]];
        if(result)
        {
            if([LdGlobalObj sharedInstanse].isNightExamFlag)
            {
                [functionBtn setBackgroundImage:[UIImage imageNamed:@"night_datika_circle_selected"] forState:UIControlStateNormal];
                [functionBtn setTitleColor:UIColorFromHex(0x667aa1) forState:UIControlStateNormal];
            }
            else
            {
                [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_selected"] forState:UIControlStateNormal];
                [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        else
        {
            if([LdGlobalObj sharedInstanse].isNightExamFlag)
            {
                [functionBtn setBackgroundImage:[UIImage imageNamed:@"night_datika_circle_normal"] forState:UIControlStateNormal];
                [functionBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
            }
            else
            {
                [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_normal"] forState:UIControlStateNormal];
                [functionBtn setTitleColor:kColorNavigationBar forState:UIControlStateNormal];
            }
        }
        functionBtn.tag = index;
        
        functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [functionBtn setTitle:[NSString stringWithFormat:@"%d", index+1] forState:UIControlStateNormal];
        [functionBtn addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        int hang = index/4;
        int lie = index%4;
        int firstkongxi = 30;
        int kongxi = (Screen_Width - 160 - firstkongxi*2)/3;
        functionBtn.frame = CGRectMake(firstkongxi+kongxi*(lie)+40*lie, 15*(hang+1)+50*hang, 40, 40);
        
        //添加标记图片
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:self.userResultDict[[NSNumber numberWithInteger:index]]];
        if(resultDict)
        {
            NSString *TagFlag = resultDict[@"TagFlag"];
            if([TagFlag isEqualToString:@"是"])
            {
                UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 0, 8, 8)];
                if([LdGlobalObj sharedInstanse].isNightExamFlag)
                {
                    [tagImageView setImage:[UIImage imageNamed:@"night_datika_circle_wrong"]];
                }
                else
                {
                    [tagImageView setImage:[UIImage imageNamed:@"datika_circle_wrong-1"]];
                }
                [functionBtn addSubview:tagImageView];
            }
        }
        
        //把视图添加到当前的滚动视图中
        [self.answerSheetScrollView addSubview:functionBtn];
        lastButton = functionBtn;
    }
    [self.answerSheetScrollView setContentSize:CGSizeMake(100, lastButton.bottom+20)];
    
    _whiteScrollBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, Screen_Width, lastButton.bottom+18)];
    [self.answerSheetScrollView insertSubview:_whiteScrollBackView atIndex:0];
    
    [[LdGlobalObj sharedInstanse] addObserver:self
                                   forKeyPath:@"examTimerNumber"
                                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                      context:NULL];
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
        [self.timerRightButton setTitleColor:UIColorFromHex(0x7a8596) forState:UIControlStateNormal];
//        [self.moreBtn setImage:[UIImage imageNamed:@"night_icon_more"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        self.answerTitleLabel.textColor = UIColorFromHex(0x666666);
        [self.submitButton setTitleColor:UIColorFromHex(0x370a00) forState:UIControlStateNormal];
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
        
        self.view.backgroundColor = kColorBarGrayBackground;
        _whiteScrollBackView.backgroundColor = [UIColor whiteColor];
        self.answerSheetScrollView.backgroundColor = [UIColor whiteColor];
        [self.timerRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.moreBtn setImage:[UIImage imageNamed:@"day_shiti_icon_more"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
        self.answerTitleLabel.textColor = UIColorFromHex(0x444444);
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    for(UIView *subView in self.answerSheetScrollView.subviews)
    {
        if([subView isKindOfClass:[UIButton class]])
        {
            UIButton *functionBtn = (UIButton *)subView;
            NSString *result = self.realResultDict[[NSNumber numberWithInteger:subView.tag]];
            if(result)
            {
                if([LdGlobalObj sharedInstanse].isNightExamFlag)
                {
                    [functionBtn setBackgroundImage:[UIImage imageNamed:@"night_datika_circle_selected"] forState:UIControlStateNormal];
                    [functionBtn setTitleColor:UIColorFromHex(0x667aa1) forState:UIControlStateNormal];
                }
                else
                {
                    [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_selected"] forState:UIControlStateNormal];
                    [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
            else
            {
                if([LdGlobalObj sharedInstanse].isNightExamFlag)
                {
                    [functionBtn setBackgroundImage:[UIImage imageNamed:@"night_datika_circle_normal"] forState:UIControlStateNormal];
                    [functionBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
                }
                else
                {
                    [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_normal"] forState:UIControlStateNormal];
                    [functionBtn setTitleColor:kColorNavigationBar forState:UIControlStateNormal];
                }
            }
        }
    }
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"examTimerNumber"])
    {
        NSNumber *num = [change valueForKey:NSKeyValueChangeNewKey];
        [self.timerRightButton setTitle:[NSString stringWithFormat:@"%02d:%02d", num.intValue/60, num.intValue%60] forState:UIControlStateNormal];
    }
}

- (void)timerRightButtonPressed
{
    [[LdGlobalObj sharedInstanse] pauseExamTimer];
    [self ShowTimeStopView];
}

- (void)resumeTimeAction
{
    [[LdGlobalObj sharedInstanse] resumeExamTimer];
    
    for(UIView *subView in self.view.subviews)
    {
        if((subView.tag == 1000)||(subView.tag == 1001)||(subView.tag == 1002)||(subView.tag == 1003)||(subView.tag == 1004))
        {
            [subView removeFromSuperview];
        }
    }
}

- (void)ShowTimeStopView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    backView.tag = 1000;
    [self.view addSubview:backView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 25)];
    label1.font = [UIFont systemFontOfSize:20];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.tag = 1001;
    label1.text = @"休息一下";
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 25)];
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.tag = 1002;
    label2.text = [NSString stringWithFormat:@"共%lu道题，还剩%lu道未做", (unsigned long)self.practiceList.count, self.practiceList.count-self.realResultDict.allKeys.count];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 25)];
    label3.font = [UIFont systemFontOfSize:16];
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.tag = 1003;
    label3.text = @"点击任意位置继续";
    [self.view addSubview:label3];
    
    UIButton *allBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    allBut.backgroundColor = [UIColor clearColor];
    allBut.tag = 1004;
    [allBut addTarget:self action:@selector(resumeTimeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBut];
    
    label2.center = self.view.center;
    label1.centerY = label2.centerY-40;
    label3.centerY = label2.centerY+50;
}

- (void)functionBtnAction:(UIButton *)button
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AnswerSheetTouchExamButtonNotification" object:[NSNumber numberWithInteger:button.tag]];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.1];
}

/*
 帐号ID   ：uid
 答题卡list : slist
 {答题时间 ：ATime
 题目ID   ：ID
 结果     :Answer
 是否答对 :isOK
 得分     :GetScore
 答题时长 :UserTime
 */
- (IBAction)submitAction:(id)sender fromPractice:(BOOL)fromPractice
{
    if(self.realResultDict.allKeys.count == 0)
    {
        ZB_Toast(@"您还没有答题呢");
        return;
    }
    
    if(self.realResultDict.allKeys.count < self.practiceList.count)
    {
        BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"你还有题目未做完，确定交卷？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        LL_WEAK_OBJC(self);
        [alertView setConfirmBlock:^{
            if([weakself.DailyPracticeTitle containsString:@"智能"]||[weakself.DailyPracticeTitle containsString:@"专项"])
            {
                [weakself NetworkSubmitIntelligentExerciseResult];
                [weakself deleteCache];
                [[LdGlobalObj sharedInstanse] stopExamTimer];
            }
            else
            {
                [weakself NetworkSubmitExamResult];
                [weakself deleteCache];
                [[LdGlobalObj sharedInstanse] stopExamTimer];
            }
        }];
        [alertView setCancelBlock:^{
            if(fromPractice)
            {
//                int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index - 2)] animated:YES];
            }
        }];
        [alertView show];
    }
    else
    {
        if([self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"])
        {
            [self NetworkSubmitIntelligentExerciseResult];
            [self deleteCache];
            [[LdGlobalObj sharedInstanse] stopExamTimer];
        }
        else
        {
            [self NetworkSubmitExamResult];
            [self deleteCache];
            [[LdGlobalObj sharedInstanse] stopExamTimer];
        }
    }
}

- (void)deleteCache
{
    NSString *isFromIntelligent = nil;
    if([self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"])
    {
        isFromIntelligent = @"是";
    }
    else
    {
        isFromIntelligent = @"否";
    }
    
    NSString *isFromOutLine = nil;
    NSString *currentOID = nil;
    if(!strIsNullOrEmpty(self.OID))
    {
        isFromOutLine = @"是";
        currentOID = self.OID;
    }
    else
    {
        isFromOutLine = @"否";
        currentOID = @"";
    }
    
    for(int index=0; index<self.practiceList.count; index++)
    {
        ExamDetailModel *examModel = self.practiceList[index];
        [[DataBaseManager sharedManager] deleteUserOperateByExamID:examModel.ID EID:examModel.EID OID:currentOID isFromOutLine:isFromOutLine isFromIntelligent:isFromIntelligent];
    }
}

#pragma -mark Network
//试卷提交答题卡（包含首页习题）
- (void)NetworkSubmitExamResult
{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
    for(NSNumber *indexNumber in self.realResultDict.allKeys)
    {
        NSDictionary *ResultDict = self.realResultDict[indexNumber];
        [list addObject:ResultDict];
    }
    
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestSubmitExamResultBySlist:list Success:^(id jsonData) {
        [SVProgressHUD dismiss];
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                if([self.isMockExamType isEqualToString:@"模考试卷"])
                {
                    BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"您的试卷已提交成功" message:@"模考结束后，银行易考才能综合考试情况给出评分及分析报告，请耐心等待。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了"];
                    LL_WEAK_OBJC(self);
                    [alertView setConfirmBlock:^{
                        ExerciseReportViewController *vc = [[ExerciseReportViewController alloc] init];
                        vc.practiceList = [NSMutableArray arrayWithArray:weakself.practiceList];
                        vc.userResultDict = [NSMutableDictionary dictionaryWithDictionary:weakself.realResultDict];
                        vc.DailyPracticeTitle = weakself.DailyPracticeTitle;
                        vc.isMockExamType = weakself.isMockExamType;
                        [weakself.navigationController pushViewController:vc animated:YES];
                    }];
                    [alertView show];
                    
                    ExamDetailModel *examModel = self.practiceList.firstObject;
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"mockExam_%@", examModel.EID]];
                    [defaults synchronize];
                }
                else
                {
                    ExerciseReportViewController *vc = [[ExerciseReportViewController alloc] init];
                    vc.practiceList = [NSMutableArray arrayWithArray:self.practiceList];
                    vc.userResultDict = [NSMutableDictionary dictionaryWithDictionary:self.realResultDict];
                    vc.DailyPracticeTitle = self.DailyPracticeTitle;
                    vc.isMockExamType = self.isMockExamType;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
                return;
            }
        }
        
        ZB_Toast(@"提交失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        ZB_Toast(@"提交遇到点小问题，请您稍后重试");
    }];
}

//专项练习、智能组卷提交答题卡
- (void)NetworkSubmitIntelligentExerciseResult
{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
    for(NSNumber *indexNumber in self.realResultDict.allKeys)
    {
        NSDictionary *ResultDict = self.realResultDict[indexNumber];
        [list addObject:ResultDict];
    }
    
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestSubmitIntelligentExerciseResultBySlist:list Success:^(id jsonData) {
        [SVProgressHUD dismiss];
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                ExerciseReportViewController *vc = [[ExerciseReportViewController alloc] init];
                vc.practiceList = [NSMutableArray arrayWithArray:self.practiceList];
                vc.userResultDict = [NSMutableDictionary dictionaryWithDictionary:self.realResultDict];
                vc.DailyPracticeTitle = self.DailyPracticeTitle;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
        
        ZB_Toast(@"提交失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        ZB_Toast(@"提交遇到点小问题，请您稍后重试");
    }];
}

@end
