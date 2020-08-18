//
//  ExerciseReportViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/5.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExerciseReportViewController.h"
#import "ReportAnswerSheetTableViewCell.h"
#import "CalendarTableViewCell.h"
#import "OldExamsSubTableViewCell.h"
#import "ErrorAnalysisViewController.h"
#import "ExamDetailModel.h"
#import "BBAlertView.h"
#import "SMPageControl.h"
#import "FirstAdModel.h"
#import "UIImageView+WebCache.h"
#import "RemoteMessageModel.h"
#import "ExaminationTitleModel.h"
#import "DailyPracticeViewController.h"

#define kHeadScrollHeight 150

@interface ExerciseReportViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)  UIButton *errorAnalysisButton;
@property (nonatomic, strong)  UIButton *allAnalysisButton;
@property (nonatomic, strong)  UIButton *retryErrorButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic, strong) NSMutableArray *answerList;
@property (weak, nonatomic) IBOutlet UILabel *percentLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong) IBOutlet UILabel *totalNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *correctNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *wrongNumLabel;
@property (nonatomic, strong)  UIScrollView *answerSheetScrollView;
@property (nonatomic, strong) BBAlertView *alertView;
//滚动视图对象
@property (nonatomic, assign) CGFloat selectErrorIndex;

@end

@implementation ExerciseReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.selectErrorIndex = MAXFLOAT;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawViews];
//    [self setupImagesPage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    [self.answerSheetScrollView removeAllSubviews];
    
    self.title = self.DailyPracticeTitle;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    float buttonWidth = 0;
    if([self.isMockExamType isEqualToString:@"模考试卷"])
    {
        buttonWidth = (kScreenWidth-62)/2.0f;
        self.errorAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(26, 7.5, buttonWidth, 40)];
        self.errorAnalysisButton.layer.cornerRadius = 20;
        [self.errorAnalysisButton setTitle:@"错题解析" forState:UIControlStateNormal];
        self.errorAnalysisButton.backgroundColor = [UIColor colorWithHex:@"#F79B38"];
        [self.errorAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.errorAnalysisButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.errorAnalysisButton addTarget:self action:@selector(errorAnalysisButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.errorAnalysisButton];
        
        self.allAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(self.errorAnalysisButton.right+10, 7.5, buttonWidth, 40)];
        self.allAnalysisButton.layer.cornerRadius = 20;
        [self.allAnalysisButton setTitle:@"全部解析" forState:UIControlStateNormal];
        self.allAnalysisButton.backgroundColor = KColorBlueText;

        [self.allAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.allAnalysisButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.allAnalysisButton addTarget:self action:@selector(allAnalysisButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.allAnalysisButton];
    }
    else
    {
        buttonWidth = (kScreenWidth-72)/3.0f;
        
        self.errorAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(26, 7.5, buttonWidth, 44)];
        self.errorAnalysisButton.layer.cornerRadius = 20;
        [self.errorAnalysisButton setTitle:@"错题解析" forState:UIControlStateNormal];
        self.errorAnalysisButton.backgroundColor = [UIColor colorWithHex:@"#F79B38"];
        [self.errorAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.errorAnalysisButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.errorAnalysisButton addTarget:self action:@selector(errorAnalysisButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.errorAnalysisButton];
        
        self.allAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(self.errorAnalysisButton.right+10, 7.5, buttonWidth, 44)];
        self.allAnalysisButton.layer.cornerRadius = 20;
        [self.allAnalysisButton setTitle:@"全部解析" forState:UIControlStateNormal];
        self.allAnalysisButton.backgroundColor = KColorBlueText;
        [self.allAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.allAnalysisButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.allAnalysisButton addTarget:self action:@selector(allAnalysisButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.allAnalysisButton];
        
        self.retryErrorButton = [[UIButton alloc] initWithFrame:CGRectMake(self.allAnalysisButton.right+10, 7.5, buttonWidth, 44)];
        self.retryErrorButton.layer.cornerRadius = 20;

        [self.retryErrorButton setTitle:@"错题重做" forState:UIControlStateNormal];
        self.retryErrorButton.backgroundColor = KColorBlueText;

        [self.retryErrorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.retryErrorButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.retryErrorButton addTarget:self action:@selector(ErrorReTryExamAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.retryErrorButton];
    }
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag){
        [backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
    }
    else
    {
        [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
       
    }
    
    self.answerList = [NSMutableArray arrayWithCapacity:9];
    for(int index=0; index<self.practiceList.count; index++)
    {
        ExamDetailModel *examModel = self.practiceList[index];
        NSDictionary *resultDict = self.userResultDict[[NSNumber numberWithInt:index]];
        
        BOOL isCorrent = YES;
        NSString *answer = resultDict[@"Answer"];
        if((answer.length != examModel.solution.length) || strIsNullOrEmpty(answer))
        {
            isCorrent = NO;
        }
        else
        {
            NSMutableArray *answerArray = [NSMutableArray arrayWithCapacity:9];
            for(NSInteger index=0; index<answer.length; index++)
            {
                [answerArray addObject:[answer substringWithRange:NSMakeRange(index, 1)]];
            }
            
            for(NSString *temp in answerArray)
            {
                NSRange range = [examModel.solution rangeOfString:temp];
                if(range.location == NSNotFound)
                {
                    isCorrent = NO;
                    break;
                }
            }
        }
        
        if(isCorrent)
        {
            [self.answerList addObject:@"是"];
        }
        else if(!strIsNullOrEmpty(resultDict[@"Answer"]))
        {
            [self.answerList addObject:@"否"];
        }
        else{
            [self.answerList addObject:@""];
        }
    }
    
    self.answerSheetScrollView = [[UIScrollView alloc] init];
    self.answerSheetScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.answerSheetScrollView];
    [self.answerSheetScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top).offset(10);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"答题情况";
    titleLab.font = [UIFont systemFontOfSize:15];
    [self.answerSheetScrollView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.answerSheetScrollView).offset(15);
        make.left.equalTo(self.answerSheetScrollView).offset(11);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *threeLab = [[UILabel alloc] init];
    threeLab.text = @"未答";
    threeLab.font = [UIFont systemFontOfSize:12];
    [self.answerSheetScrollView addSubview:threeLab];
    [threeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.mas_equalTo(12);
    }];
    UIView *threeCricle = [UIView new];
    threeCricle.layer.cornerRadius = 2.5;
    threeCricle.backgroundColor = [UIColor colorWithHex:@"#EFEFEF"];
    [self.answerSheetScrollView addSubview:threeCricle];
    [threeCricle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(threeLab.mas_left).offset(-2);
        make.centerY.equalTo(titleLab);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    UILabel *twoLab = [[UILabel alloc] init];
       twoLab.text = @"答错";
       twoLab.font = [UIFont systemFontOfSize:12];
       [self.answerSheetScrollView addSubview:twoLab];
       [twoLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(titleLab);
           make.right.equalTo(threeCricle.mas_left).offset(-12);
           make.height.mas_equalTo(12);
       }];
       UIView *twoCricle = [UIView new];
       twoCricle.layer.cornerRadius = 2.5;
       twoCricle.backgroundColor = [UIColor colorWithHex:@"#F79B38"];
       [self.answerSheetScrollView addSubview:twoCricle];
       [twoCricle mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(twoLab.mas_left).offset(-2);
           make.centerY.equalTo(titleLab);
           make.size.mas_equalTo(CGSizeMake(5, 5));
       }];
    UILabel *oneLab = [[UILabel alloc] init];
        oneLab.text = @"答对";
        oneLab.font = [UIFont systemFontOfSize:12];
        [self.answerSheetScrollView addSubview:oneLab];
        [oneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLab);
            make.right.equalTo(twoCricle.mas_left).offset(-12);
            make.height.mas_equalTo(12);
        }];
        UIView *oneCricle = [UIView new];
        oneCricle.layer.cornerRadius = 2.5;
        oneCricle.backgroundColor = [UIColor colorWithHex:@"#35C356"];
        [self.answerSheetScrollView addSubview:oneCricle];
        [oneCricle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(oneLab.mas_left).offset(-2);
            make.centerY.equalTo(titleLab);
            make.size.mas_equalTo(CGSizeMake(5, 5));
        }];
     
    
    
    
    int rightIndex = 0;
    int wrongIndex = 0;
    UIButton *lastButton = nil;
    for(int index=0; index<[self.answerList count]; index++)
    {
        //创建一个视图
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        NSString *answerString = self.answerList[index];
        [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if([answerString isEqualToString:@"是"])
        {
            //正确
            rightIndex++;
            [functionBtn setBackgroundColor:[UIColor colorWithHex:@"#35C356"]];
        }
        else if([answerString isEqualToString:@"否"])
        {
            //错误
            [functionBtn setBackgroundColor:[UIColor colorWithHex:@"#F79B38"]];
            wrongIndex++;
            [functionBtn addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            //未答
            [functionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_none"] forState:UIControlStateNormal];
        }
        functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [functionBtn setTitle:[NSString stringWithFormat:@"%d", index+1] forState:UIControlStateNormal];
        functionBtn.layer.cornerRadius = 20;
        
        int hang = index/4;
        int lie = index%4;
        int firstkongxi = 30;
        int kongxi = (Screen_Width - 181 - firstkongxi*2)/3;
        
        functionBtn.frame = CGRectMake(firstkongxi+kongxi*(lie)+40*lie, 49*(hang+1)+50*hang, 40, 40);
        functionBtn.tag = index;
        
        //把视图添加到当前的滚动视图中
        [self.answerSheetScrollView addSubview:functionBtn];
        lastButton = functionBtn;
    }
    [self.answerSheetScrollView setContentSize:CGSizeMake(100, lastButton.bottom+20)];
    
    self.timeLab.text = [NSString stringWithFormat:@"%02d分%02d秒", [LdGlobalObj sharedInstanse].examTimerNumber.intValue/60, [LdGlobalObj sharedInstanse].examTimerNumber.intValue%60];
    
    [self drawChartView:rightIndex wrongIndex:wrongIndex];
}

- (void)functionBtnAction:(UIButton *)button
{
    self.selectErrorIndex = button.tag;
    [self errorAnalysisButtonAction:nil];
}

- (void)refreshErrorAnalysisVC{
    self.selectErrorIndex = MAXFLOAT;
//    if(self.selectErrorIndex != MAXFLOAT){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorAnswerSheetTouchExamBtnNotification" object:[NSNumber numberWithInteger:self.selectErrorIndex]];
//        self.selectErrorIndex = MAXFLOAT;
//    }
}

- (void)drawChartView:(int)rightIndex wrongIndex:(int)wrongIndex
{
    self.wrongNumLabel.text = [NSString stringWithFormat:@"%d ", wrongIndex];
    self.correctNumLabel.text= [NSString stringWithFormat:@"%d ", rightIndex];
    self.totalNumLabel.text =  [NSString stringWithFormat:@"%d", (int)self.practiceList.count - rightIndex- wrongIndex];
    self.percentLab.text = [NSString stringWithFormat:@"%.f ", (float)rightIndex/(float)self.practiceList.count*100.0];

}

- (void)backButtonPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//错题解析
- (IBAction)errorAnalysisButtonAction:(id)sender
{
    NSMutableArray *errorArray = [NSMutableArray arrayWithCapacity:9];
    for(int index=0; index<self.practiceList.count; index++)
    {
        ExamDetailModel *examModel = self.practiceList[index];
        NSDictionary *resultDict = self.userResultDict[[NSNumber numberWithInt:index]];
        
        BOOL isCorrent = YES;
        NSString *answer = resultDict[@"Answer"];
        if((answer.length != examModel.solution.length) || strIsNullOrEmpty(answer))
        {
            isCorrent = NO;
        }
        else
        {
            NSMutableArray *answerArray = [NSMutableArray arrayWithCapacity:9];
            for(NSInteger index=0; index<answer.length; index++)
            {
                [answerArray addObject:[answer substringWithRange:NSMakeRange(index, 1)]];
            }
            
            for(NSString *temp in answerArray)
            {
                NSRange range = [examModel.solution rangeOfString:temp];
                if(range.location == NSNotFound)
                {
                    isCorrent = NO;
                    break;
                }
            }
        }
        
        if(isCorrent)
        {}
        else if(resultDict[@"Answer"])
        {
            if(index == self.selectErrorIndex){
                self.selectErrorIndex = errorArray.count - 1;
                [errorArray addObject:examModel];
                break;
            }else if(9999 < self.selectErrorIndex){
                [errorArray addObject:examModel];
            }
        }
    }
    
    if(errorArray.count == 0)
    {
        if(!self.alertView)
        {
            self.alertView = [[BBAlertView alloc] initWithTitle:@"您太厉害了，全部答对了哦" message:@"回到首页" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
            LL_WEAK_OBJC(self);
            [self.alertView setConfirmBlock:^{
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }];
            [self.alertView setCancelBlock:^{
                [weakself.alertView dismiss];
                weakself.alertView = nil;
            }];
            [self.alertView show];
        }
        return;
    }
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
    for(ExamDetailModel *model in errorArray)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
        [list addObject:dict];
    }
    
    [SVProgressHUD showWithStatus:@"正在分析" maskType:SVProgressHUDMaskTypeClear];
    if([self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"]||[self.isMockExamType containsString:@"专项"])
    {
        [self NetworkGetIntelligentExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:NO];
    }
    else
    {
        [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:NO];
    }
}

- (IBAction)ErrorReTryExamAction:(id)sender
{
    NSMutableArray *errorArray = [NSMutableArray arrayWithCapacity:9];
    for(int index=0; index<self.practiceList.count; index++)
    {
        ExamDetailModel *examModel = self.practiceList[index];
        NSDictionary *resultDict = self.userResultDict[[NSNumber numberWithInt:index]];
        
        BOOL isCorrent = YES;
        NSString *answer = resultDict[@"Answer"];
        if((answer.length != examModel.solution.length) || strIsNullOrEmpty(answer))
        {
            isCorrent = NO;
        }
        else
        {
            NSMutableArray *answerArray = [NSMutableArray arrayWithCapacity:9];
            for(NSInteger index=0; index<answer.length; index++)
            {
                [answerArray addObject:[answer substringWithRange:NSMakeRange(index, 1)]];
            }
            
            for(NSString *temp in answerArray)
            {
                NSRange range = [examModel.solution rangeOfString:temp];
                if(range.location == NSNotFound)
                {
                    isCorrent = NO;
                    break;
                }
            }
        }
        
        if(isCorrent)
        {}
        else if(resultDict[@"Answer"])
        {
            [errorArray addObject:examModel];
        }
    }
    
    if(errorArray.count == 0)
    {
        if(!self.alertView)
        {
            self.alertView = [[BBAlertView alloc] initWithTitle:@"您太厉害了，全部答对了哦" message:@"回到首页" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
            LL_WEAK_OBJC(self);
            [self.alertView setConfirmBlock:^{
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }];
            [self.alertView setCancelBlock:^{
                [weakself.alertView dismiss];
                weakself.alertView = nil;
            }];
            [self.alertView show];
        }
        return;
    }
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
    for(ExamDetailModel *model in errorArray)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
        [list addObject:dict];
    }
    
    [SVProgressHUD showWithStatus:@"正在分析" maskType:SVProgressHUDMaskTypeClear];
    if([self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"]||[self.isMockExamType containsString:@"专项"])
    {
        [self NetworkGetIntelligentExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:YES];
    }
    else
    {
        [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:YES];
    }
}

- (IBAction)allAnalysisButtonAction:(id)sender
{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
    for(ExamDetailModel *model in self.practiceList)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
        [list addObject:dict];
    }
    
    if(self.practiceList.count == 0)
    {
        ZB_Toast(@"没有找到题目");
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if([self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"]||[self.isMockExamType containsString:@"专项"])
    {
        [self NetworkGetIntelligentExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:NO];
    }
    else
    {
        [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:NO];
    }
}
#pragma -mark Network
/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList isRetry:(BOOL)isRetry
{
    [LLRequestClass requestGetExamDetailsByTitleList:titleList Success:^(id jsonData) {
        NSDictionary *contentDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        NSString *result = contentDict[@"result"];
        if([result isEqualToString:@"success"])
        {
            NSArray *array = contentDict[@"list"];
            NSMutableArray *examList = [NSMutableArray arrayWithCapacity:9];
            for(NSDictionary *dict in array)
            {
                ExamDetailModel *model = [ExamDetailModel model];
                [model setDataWithDic:dict];
                [examList addObject:model];
            }
            
            if(examList.count > 0)
            {
                if(isRetry)
                {
                    DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.practiceList = [NSMutableArray arrayWithArray:examList];
                    vc.title = self.title;
                    vc.isSaveUserOperation = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    ErrorAnalysisViewController *vc = [[ErrorAnalysisViewController alloc] init];
                    vc.practiceList = [NSMutableArray arrayWithArray:examList];
                    vc.DailyPracticeTitle = self.title;
                    if(examList.count == 1){
                        vc.isFromFirstPageSearch = YES;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                    [self performSelector:@selector(refreshErrorAnalysisVC) withObject:nil afterDelay:0.3];
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                ZB_Toast(@"没有找到试题");
            }
            return;
        }
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetIntelligentExamDetailListByTitleList:(NSArray *)titleList isRetry:(BOOL)isRetry
{
    [LLRequestClass requestGetIntelligentExamDetailsByTitleList:titleList Success:^(id jsonData) {
        NSDictionary *contentDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        NSString *result = contentDict[@"result"];
        if([result isEqualToString:@"success"])
        {
            NSArray *array = contentDict[@"list"];
            NSMutableArray *examList = [NSMutableArray arrayWithCapacity:9];
            for(NSDictionary *dict in array)
            {
                ExamDetailModel *model = [ExamDetailModel model];
                [model setDataWithDic:dict];
                [examList addObject:model];
            }
            
            if(examList.count > 0)
            {
                if(isRetry)
                {
                    DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.practiceList = [NSMutableArray arrayWithArray:examList];
                    vc.title = self.title;
                    vc.isSaveUserOperation = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    ErrorAnalysisViewController *vc = [[ErrorAnalysisViewController alloc] init];
                    vc.practiceList = [NSMutableArray arrayWithArray:examList];
                    vc.DailyPracticeTitle = self.DailyPracticeTitle;
                    if(examList.count == 1){
                        vc.isFromFirstPageSearch = YES;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                    [self performSelector:@selector(refreshErrorAnalysisVC) withObject:nil afterDelay:0.3];
                }
                
            }
            else
            {
                [SVProgressHUD dismiss];
                ZB_Toast(@"没有找到试题");
            }
            return;
        }
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

@end
