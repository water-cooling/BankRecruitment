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
#import "PieCharView.h"
#import "ExaminationTitleModel.h"
#import "DailyPracticeViewController.h"

#define kHeadScrollHeight 150

@interface ExerciseReportViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIButton *errorAnalysisButton;
@property (nonatomic, strong) IBOutlet UIButton *allAnalysisButton;
@property (nonatomic, strong) IBOutlet UIButton *retryErrorButton;
@property (nonatomic, strong) NSMutableArray *answerList;

@property (nonatomic, strong) IBOutlet UILabel *totalNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *correctNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *wrongNumLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *answerSheetScrollView;
@property (nonatomic, strong) UIView *whiteScrollBackView;
@property (nonatomic, strong) BBAlertView *alertView;
@property (nonatomic, strong) IBOutlet UILabel *lineView;

//滚动视图对象
@property (nonatomic ,strong) IBOutlet UIScrollView *upScrollView;
//视图中小圆点，对应视图的页码
@property (retain, nonatomic) SMPageControl *upPageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat selectErrorIndex;

- (void)setupImagesPage:(id)sender;
@end

@implementation ExerciseReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        buttonWidth = (kScreenWidth-4)/2.0f;
        self.errorAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(1, kScreenHeight-44-TabbarSafeBottomMargin, buttonWidth, 44)];
        [self.errorAnalysisButton setTitle:@"错题解析" forState:UIControlStateNormal];
        [self.errorAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.errorAnalysisButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.errorAnalysisButton setBackgroundColor:kColorNavigationBar];
        [self.errorAnalysisButton addTarget:self action:@selector(errorAnalysisButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.errorAnalysisButton];
        
        self.allAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(self.errorAnalysisButton.right+2, kScreenHeight-44-TabbarSafeBottomMargin, buttonWidth, 44)];
        [self.allAnalysisButton setTitle:@"全部解析" forState:UIControlStateNormal];
        [self.allAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.allAnalysisButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.allAnalysisButton setBackgroundColor:kColorNavigationBar];
        [self.allAnalysisButton addTarget:self action:@selector(allAnalysisButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.allAnalysisButton];
    }
    else
    {
        buttonWidth = (kScreenWidth-6)/3.0f;
        
        self.errorAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(1, kScreenHeight-44-TabbarSafeBottomMargin, buttonWidth, 44)];
        [self.errorAnalysisButton setTitle:@"错题解析" forState:UIControlStateNormal];
        [self.errorAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.errorAnalysisButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.errorAnalysisButton setBackgroundColor:kColorNavigationBar];
        [self.errorAnalysisButton addTarget:self action:@selector(errorAnalysisButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.errorAnalysisButton];
        
        self.allAnalysisButton = [[UIButton alloc] initWithFrame:CGRectMake(self.errorAnalysisButton.right+2, kScreenHeight-44-TabbarSafeBottomMargin, buttonWidth, 44)];
        [self.allAnalysisButton setTitle:@"全部解析" forState:UIControlStateNormal];
        [self.allAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.allAnalysisButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.allAnalysisButton setBackgroundColor:kColorNavigationBar];
        [self.allAnalysisButton addTarget:self action:@selector(allAnalysisButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.allAnalysisButton];
        
        self.retryErrorButton = [[UIButton alloc] initWithFrame:CGRectMake(self.allAnalysisButton.right+2, kScreenHeight-44-TabbarSafeBottomMargin, buttonWidth, 44)];
        [self.retryErrorButton setTitle:@"错题重做" forState:UIControlStateNormal];
        [self.retryErrorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.retryErrorButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.retryErrorButton setBackgroundColor:kColorNavigationBar];
        [self.retryErrorButton addTarget:self action:@selector(ErrorReTryExamAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.retryErrorButton];
    }
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        self.view.backgroundColor = UIColorFromHex(0x2b3f5d);
        [backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        [self.errorAnalysisButton setBackgroundColor:UIColorFromHex(0x3b4b64)];
        [self.errorAnalysisButton setTitleColor:UIColorFromHex(0x7a8596) forState:UIControlStateNormal];
        [self.allAnalysisButton setBackgroundColor:UIColorFromHex(0x3b4b64)];
        [self.allAnalysisButton setTitleColor:UIColorFromHex(0x7a8596) forState:UIControlStateNormal];
        [self.retryErrorButton setBackgroundColor:UIColorFromHex(0x3b4b64)];
        [self.retryErrorButton setTitleColor:UIColorFromHex(0x7a8596) forState:UIControlStateNormal];
        self.lineView.backgroundColor = UIColorFromHex(0x3b4b64);
        self.totalNumLabel.textColor = UIColorFromHex(0x7a8596);
        self.correctNumLabel.textColor = UIColorFromHex(0x7a8596);
        self.wrongNumLabel.textColor = UIColorFromHex(0x7a8596);
    }
    else
    {
        self.view.backgroundColor = kColorBarGrayBackground;
        [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
        [self.errorAnalysisButton setBackgroundColor:kColorNavigationBar];
        [self.errorAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.allAnalysisButton setBackgroundColor:kColorNavigationBar];
        [self.allAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.retryErrorButton setBackgroundColor:kColorNavigationBar];
        [self.retryErrorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.lineView.backgroundColor = kColorLineSepBackground;
        self.totalNumLabel.textColor = kColorDarkText;
        self.correctNumLabel.textColor = kColorDarkText;
        self.wrongNumLabel.textColor = kColorDarkText;
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
    
    self.answerSheetScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40+190+StatusBarAndNavigationBarHeight, Screen_Width, Screen_Height-44-(40+190+StatusBarAndNavigationBarHeight+TabbarSafeBottomMargin))];
    [self.view addSubview:self.answerSheetScrollView];
    
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
            rightIndex++;
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_right"] forState:UIControlStateNormal];
        }
        else if([answerString isEqualToString:@"否"])
        {
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_wrong-1"] forState:UIControlStateNormal];
            wrongIndex++;
            [functionBtn addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [functionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_none"] forState:UIControlStateNormal];
        }
        functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [functionBtn setTitle:[NSString stringWithFormat:@"%d", index+1] forState:UIControlStateNormal];
        
        int hang = index/4;
        int lie = index%4;
        int firstkongxi = 30;
        int kongxi = (Screen_Width - 181 - firstkongxi*2)/3;
        
        functionBtn.frame = CGRectMake(firstkongxi+kongxi*(lie)+40*lie, 15*(hang+1)+50*hang, 40, 40);
        functionBtn.tag = index;
        
        //把视图添加到当前的滚动视图中
        [self.answerSheetScrollView addSubview:functionBtn];
        lastButton = functionBtn;
    }
    [self.answerSheetScrollView setContentSize:CGSizeMake(100, lastButton.bottom+20)];
    
    _whiteScrollBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, Screen_Width, lastButton.bottom+18)];
    [self.answerSheetScrollView insertSubview:_whiteScrollBackView atIndex:0];
    
    UILabel *TotalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, 40)];
    TotalTimeLabel.textColor = kColorDarkText;
    TotalTimeLabel.font = [UIFont systemFontOfSize:14];
    TotalTimeLabel.text = [NSString stringWithFormat:@"总答题时间 %02d分%02d秒", [LdGlobalObj sharedInstanse].examTimerNumber.intValue/60, [LdGlobalObj sharedInstanse].examTimerNumber.intValue%60];
    TotalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:TotalTimeLabel];
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        TotalTimeLabel.backgroundColor = [UIColor clearColor];
        TotalTimeLabel.textColor = UIColorFromHex(0x7a8596);
        _whiteScrollBackView.backgroundColor = [UIColor clearColor];
        _answerSheetScrollView.backgroundColor = [UIColor clearColor];
    }
    else
    {
        TotalTimeLabel.backgroundColor = [UIColor whiteColor];
        _whiteScrollBackView.backgroundColor = [UIColor whiteColor];
        _answerSheetScrollView.backgroundColor = kColorBarGrayBackground;
    }
    
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
    PieCharView *pieChar = [[PieCharView alloc] initWithFrame:CGRectMake(10, StatusBarAndNavigationBarHeight+36, kScreenWidth - 20, 190) withYoffset:98];
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        pieChar.backgroundColor = [UIColor clearColor];
    }
    else
    {
        pieChar.backgroundColor = kColorBarGrayBackground;
    }
    pieChar.textColor = [UIColor whiteColor];
    pieChar.textFont = [UIFont systemFontOfSize:12];
    pieChar.radius = 65;
    pieChar.centreString = [NSString stringWithFormat:@" 答对率:%.2f%% ", (float)rightIndex/(float)self.practiceList.count*100.0];
    [self.view addSubview:pieChar];
    PieCharModel *model1 = [[PieCharModel alloc] init];
    model1.title = [NSString stringWithFormat:@" 答错:%d ", wrongIndex];
    model1.percent = [NSString stringWithFormat:@"%.2f", (float)wrongIndex/(float)self.practiceList.count];
    model1.color = [UIColor colorWithHex:@"#fb7656"];
    
    PieCharModel *model2 = [[PieCharModel alloc] init];
    model2.title = [NSString stringWithFormat:@" 答对:%d ", rightIndex];
    model2.percent = [NSString stringWithFormat:@"%.2f", (float)rightIndex/(float)self.practiceList.count];
    model2.color = [UIColor colorWithHex:@"#4cc05f"];
    
    PieCharModel *model3 = [[PieCharModel alloc] init];
    model3.title = [NSString stringWithFormat:@" 未答:%d ", (int)self.practiceList.count - rightIndex- wrongIndex];
    model3.percent = [NSString stringWithFormat:@"%.2f", (float)(self.practiceList.count - rightIndex- wrongIndex)/(float)self.practiceList.count];
    model3.color = [UIColor colorWithHex:@"#8c9fb0"];
    
    pieChar.dataArray = @[model1, model2, model3];
    
}

- (void)backButtonPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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

#pragma -mark 广告
//改变滚动视图的方法实现
- (void)setupImagesPage:(id)sender
{
    if(!self.upPageControl)
    {
        self.upPageControl = [[SMPageControl alloc]initWithFrame:CGRectMake(0, Screen_Height-30-44, Screen_Width, 40)];
        self.upPageControl.backgroundColor=[UIColor clearColor];
        self.upPageControl.currentPageIndicatorImage = [UIImage imageNamed:@"Rectangle_white"];
        self.upPageControl.pageIndicatorImage = [UIImage imageNamed:@"Rectangle_opacity"];
        self.upPageControl.indicatorMargin = 2.0f;
        self.upPageControl.indicatorDiameter = 10.0f;
        [self.view addSubview:self.upPageControl];
        self.upPageControl.centerX = Screen_Width/2.;
    }
    self.upPageControl.numberOfPages=[[LdGlobalObj sharedInstanse].advList count];
    self.upPageControl.currentPage=0;
    
    [self.upScrollView removeAllSubviews];
    
    //设置委托
    self.upScrollView.delegate = self;
    //设置背景颜色
    self.upScrollView.backgroundColor = [UIColor clearColor];
    //设置取消触摸
    self.upScrollView.canCancelContentTouches = NO;
    //设置滚动条类型
    self.upScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    //是否自动裁切超出部分
    self.upScrollView.clipsToBounds = YES;
    //设置是否可以缩放
    self.upScrollView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    self.upScrollView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.upScrollView.directionalLockEnabled = NO;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.upScrollView.alwaysBounceHorizontal = NO;
    self.upScrollView.alwaysBounceVertical = NO;
    self.upScrollView.showsHorizontalScrollIndicator = NO;
    self.upScrollView.showsVerticalScrollIndicator = NO;
    
    if([LdGlobalObj sharedInstanse].advList.count == 0)
    {
        UIImageView* backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeadScrollHeight)];
        backImageView.image = kDefaultHorizontalRectangleImage;
        [self.upScrollView addSubview:backImageView];
        self.upPageControl.numberOfPages = 0;
        return;
    }
    
    //add the last image in first
    if([LdGlobalObj sharedInstanse].advList.count > 1)
    {
        FirstAdModel *imageModel = [[LdGlobalObj sharedInstanse].advList objectAtIndex:([[LdGlobalObj sharedInstanse].advList count]-1)];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp,imageModel.img]] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
        //        [imageView setImage:[UIImage imageNamed:[imageDict objectForKey:@"path"]]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(0, 0, Screen_Width, kHeadScrollHeight);
        [self.upScrollView addSubview:imageView];
    }
    
    //用来记录页数
    NSUInteger pages = 0;
    //用来记录scrollView的x坐标
    int originX = ([LdGlobalObj sharedInstanse].advList.count > 1)?Screen_Width:0;
    for(FirstAdModel *imageModel in [LdGlobalObj sharedInstanse].advList)
    {
        //创建一个视图
        UIImageView *pImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        pImageView.userInteractionEnabled = YES;
        //设置视图的背景色
        pImageView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pImageViewTapAction)];
        [pImageView addGestureRecognizer:ges];
        
        //设置imageView的背景图
        [pImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp,imageModel.img]] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
        //        [pImageView setImage:[UIImage imageNamed:[imageDict objectForKey:@"path"]]];
        
        //给imageView设置区域
        CGRect rect = CGRectMake(0, 0, Screen_Width, kHeadScrollHeight);
        rect.origin.x = originX;
        rect.origin.y = 0;
        //rect.size.width = self.upScrollView.frame.size.width;
        rect.size.height = kHeadScrollHeight;
        pImageView.frame = rect;
        //设置图片内容的显示模式(自适应模式)
        pImageView.contentMode = UIViewContentModeScaleToFill;
        //把视图添加到当前的滚动视图中
        [self.upScrollView addSubview:pImageView];
        //下一张视图的x坐标:offset为:self.scrollView.frame.size.width.
        originX += Screen_Width;
        //记录scrollView内imageView的个数
        pages++;
    }
    
    //add the first image at the end
    if([LdGlobalObj sharedInstanse].advList.count > 1)
    {
        FirstAdModel *imageModel = [[LdGlobalObj sharedInstanse].advList firstObject];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp,imageModel.img]] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
        //        [imageView setImage:[UIImage imageNamed:[imageDict objectForKey:@"path"]]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake((Screen_Width * ([[LdGlobalObj sharedInstanse].advList count] + 1)), 0, Screen_Width, kHeadScrollHeight);
        [self.upScrollView addSubview:imageView];
    }
    
    //设置总页数
    self.upPageControl.numberOfPages = pages;
    //默认当前页为第一页
    self.upPageControl.currentPage = 0;
    
    //    NSDictionary *imageDict1 = [self.upImages firstObject];
    //    self.upLabel.text = [imageDict1 objectForKey:@"title"];
    
    //为页码控制器设置标签
    self.upPageControl.tag = 110;
    
    //设置滚动视图的位置
    if([LdGlobalObj sharedInstanse].advList.count > 1)
    {
        [self.upScrollView setContentSize:CGSizeMake(Screen_Width * ([LdGlobalObj sharedInstanse].advList.count + 2), 100)];
        [self.upScrollView setContentOffset:CGPointMake(0, 0)];
        
        float offset = Screen_Width-320;
        [self.upScrollView scrollRectToVisible:CGRectMake(Screen_Width-offset, 0, Screen_Width, kHeadScrollHeight) animated:NO];
    }
    else
    {
        [self.upScrollView setContentSize:CGSizeMake(Screen_Width, 0)];
        [self.upScrollView setContentOffset:CGPointMake(0, 0)];
        [self.upScrollView scrollRectToVisible:CGRectMake(0,0,Screen_Width,kHeadScrollHeight) animated:NO];
    }
    
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollTimerAction) userInfo:nil repeats:YES];
    self.timer.fireDate = [NSDate date];
}

- (void)timerFire
{
    [self.timer fire];
}

- (void)pImageViewTapAction
{
    FirstAdModel *model = [[LdGlobalObj sharedInstanse].advList objectAtIndex:self.upPageControl.currentPage];
    RemoteMessageModel *remodel = [RemoteMessageModel model];
    remodel.msg = @"";
    remodel.mType = model.title;
    remodel.linkId = model.path;
    [[LdGlobalObj sharedInstanse] processRemoteMessage:remodel];
}

- (void)scrollTimerAction
{
    if(self.upPageControl.currentPage == [[LdGlobalObj sharedInstanse].advList count]-1)
    {
        self.upPageControl.currentPage = 0;
    }
    else
    {
        self.upPageControl.currentPage++;
    }
    
    //获取当前视图的页码
    CGRect rect = CGRectMake(0, 0, Screen_Width, kHeadScrollHeight);
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = (1+self.upPageControl.currentPage) * Screen_Width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [self.upScrollView scrollRectToVisible:rect animated:YES];
}

//实现协议UIScrollViewDelegate的方法，必须实现的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate distantFuture]];//暂停
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int currentPage = floor((self.upScrollView.contentOffset.x - Screen_Width / ([[LdGlobalObj sharedInstanse].advList count]+2)) / Screen_Width) + 1;
    
    //切换改变页码，小圆点
    if(scrollView == self.upScrollView)
    {
        if (currentPage==0) {
            //go last but 1 page
            [self.upScrollView scrollRectToVisible:CGRectMake(Screen_Width * [[LdGlobalObj sharedInstanse].advList count],0, Screen_Width, kHeadScrollHeight) animated:NO];
            
            currentPage = (int)([LdGlobalObj sharedInstanse].advList.count-1);
        }
        else if (currentPage==([[LdGlobalObj sharedInstanse].advList count]+1))
        { //如果是最后+1,也就是要开始循环的第一个
            [self.upScrollView scrollRectToVisible:CGRectMake(Screen_Width,0,Screen_Width,kHeadScrollHeight) animated:NO];
            currentPage = 0;
        }
        else
        {
            currentPage--;
        }
        
        self.upPageControl.currentPage = currentPage;
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
