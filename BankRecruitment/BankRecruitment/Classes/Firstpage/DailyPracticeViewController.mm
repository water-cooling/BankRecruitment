//
//  DailyPracticeViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/31.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "DailyPracticeViewController.h"
#import "ExamOptionTableViewCell.h"
#import "AnswerSheetViewController.h"
#import "WDDrawView.h"
#import "CourseCalendarViewController.h"
#import "AnalysisMoreView.h"
#import "ExamDetailModel.h"
#import "ExamDetailOptionModel.h"
#import "ExamTitleTableViewCell.h"
#import "ExamStemTableViewCell.h"
#import "BBAlertView.h"
#import "ReportErrorViewController.h"
#import "DataBaseManager.h"
#import "ExamOperaterModel.h"
#import "BigImageShowViewController.h"

#define kMaxTableViewLimit 5

@interface DailyPracticeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIScrollView *examScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *examPageControl;
@property (nonatomic, strong) IBOutlet UILabel *bottomTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *PreBtn;
@property (nonatomic, strong) IBOutlet UIButton *NextBtn;
@property (nonatomic, strong) IBOutlet UIButton *draftBtn;
@property (nonatomic, strong) IBOutlet UIButton *answerSheetBtn;
@property (nonatomic, strong) IBOutlet UIButton *collectBtn;
@property (nonatomic, strong) IBOutlet UIButton *shareBtn;
@property (nonatomic, strong) IBOutlet UIButton *TimerBtn;
@property (nonatomic, strong) IBOutlet UIButton *moreBtn;
@property (nonatomic, strong) IBOutlet UIButton *tagBtn;
@property (nonatomic, strong) IBOutlet UIView *bottomContentView;
@property (nonatomic, strong) UIButton *forwordDraftButton;
@property (nonatomic, strong) UIButton *undoDraftButton;
@property (nonatomic, strong) UIButton *clearDraftButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *dailyButton;
@property (strong, nonatomic) WDDrawView *drawView;
@property (strong, nonatomic) AnalysisMoreView *moreView;
@property (strong, nonatomic) IBOutlet UIView *functionBackView;
@property (strong, nonatomic) UIButton *quitMoreButton;

@property (nonatomic, assign) NSInteger selectExamIndex;
@property (nonatomic, strong) NSMutableArray *tableViewList;
@property (nonatomic, strong) NSMutableDictionary *userResultDict;
@property (nonatomic, strong) NSMutableArray *favoriteExamList;

@property (nonatomic, assign) float materialHeight;
@property (nonatomic, assign) float titleHeight;

@property (nonatomic, strong) NSMutableDictionary *globalAttributeDictionary;
@property (nonatomic, assign) BOOL isloadOperation;
@property (nonatomic, assign) BOOL isShowBigImage;

@end

@implementation DailyPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.selectExamIndex = 0;
    self.isloadOperation = NO;
    self.isShowBigImage = NO;
    self.tableViewList = [NSMutableArray arrayWithCapacity:9];
    self.userResultDict = [NSMutableDictionary dictionaryWithCapacity:9];
    self.favoriteExamList = [NSMutableArray arrayWithCapacity:9];
    self.globalAttributeDictionary = [NSMutableDictionary dictionaryWithCapacity:9];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScrollViewFromAnswerScrollViewIndex:) name:@"AnswerSheetTouchExamButtonNotification" object:nil];
    [self drawViews];
    
    [self NetworkGetFavoriteList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    for(NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//    }
    
//    for(ExamDetailModel *model in self.practiceList)
//    {
//        model.title = [model.title stringByReplacingOccurrencesOfString:@"width=\"320\"" withString:[NSString stringWithFormat:@"width=\"%d\"", (int)kScreenWidth]];
//        model.material = [model.material stringByReplacingOccurrencesOfString:@"width=\"320\"" withString:[NSString stringWithFormat:@"width=\"%d\"", (int)kScreenWidth]];
//    }
    
    [self modifyAllTitleImageWidth];
    
    if((IOS9_OR_LATER)&&(!self.isShowBigImage))
    {
        [self refreshViewByDayNightType];
    }
    
    self.isShowBigImage = NO;
    
    if((!self.isloadOperation)&&(self.isSaveUserOperation))
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self addExamListToDB];
            [self getExamOprationList];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD dismiss];
    
    if((self.selectExamIndex > 0)&&(!self.isloadOperation))
    {
        self.isloadOperation = YES;
        self.examPageControl.currentPage = self.selectExamIndex;
        [self.examScrollView scrollRectToVisible:CGRectMake(self.selectExamIndex*Screen_Width, 0, Screen_Width, 10)  animated:YES];
        [self refreshScrollViewByIndex:self.selectExamIndex];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)modifyAllTitleImageWidth
{
    for(ExamDetailModel *examModel in self.practiceList)
    {
        if(!strIsNullOrEmpty(examModel.material))
        {
            NSString *tempString = examModel.material;
            NSRange range1 = [tempString rangeOfString:@"src='"];
            NSRange range2 = [tempString rangeOfString:@"' />"];
            if(range1.length != 5)
            {
                continue;
            }
            NSString *imageUrl1 = [tempString substringWithRange:NSMakeRange(range1.location+5, range2.location-range1.location-5)];
            NSString *imageUrl1Pre = imageUrl1;
            tempString = [tempString substringFromIndex:range2.location+range2.length];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl1 = [imageUrl1 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.material = [examModel.material stringByReplacingOccurrencesOfString:imageUrl1Pre withString:imageUrl1];
            
            NSRange range3 = [tempString rangeOfString:@"src='"];
            NSRange range4 = [tempString rangeOfString:@"' />"];
            if(range3.length != 5)
            {
                continue;
            }
            NSString *imageUrl2 = [tempString substringWithRange:NSMakeRange(range3.location+5, range4.location-range3.location-5)];
            NSString *imageUrl2Pre = imageUrl2;
            tempString = [tempString substringFromIndex:range4.location+range4.length];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl2 = [imageUrl2 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.material = [examModel.material stringByReplacingOccurrencesOfString:imageUrl2Pre withString:imageUrl2];
            
            NSRange range5 = [tempString rangeOfString:@"src='"];
            NSRange range6 = [tempString rangeOfString:@"' />"];
            if(range5.length != 5)
            {
                continue;
            }
            NSString *imageUrl3 = [tempString substringWithRange:NSMakeRange(range5.location+5, range6.location-range5.location-5)];
            NSString *imageUrl3Pre = imageUrl3;
            tempString = [tempString substringFromIndex:range6.location+range6.length];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl3 = [imageUrl3 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.material = [examModel.material stringByReplacingOccurrencesOfString:imageUrl3Pre withString:imageUrl3];
            
            NSRange range7 = [tempString rangeOfString:@"src='"];
            NSRange range8 = [tempString rangeOfString:@"' />"];
            if(range7.length != 5)
            {
                continue;
            }
            NSString *imageUrl4 = [tempString substringWithRange:NSMakeRange(range7.location+5, range8.location-range7.location-5)];
            NSString *imageUrl4Pre = imageUrl4;
            tempString = [tempString substringFromIndex:range8.location+range8.length];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl4 = [imageUrl4 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.material = [examModel.material stringByReplacingOccurrencesOfString:imageUrl4Pre withString:imageUrl4];
            
            NSRange range9 = [tempString rangeOfString:@"src='"];
            NSRange range10 = [tempString rangeOfString:@"' />"];
            if(range9.length != 5)
            {
                continue;
            }
            NSString *imageUrl5 = [tempString substringWithRange:NSMakeRange(range9.location+5, range10.location-range9.location-5)];
            NSString *imageUrl5Pre = imageUrl5;
            tempString = [tempString substringFromIndex:range10.location+range10.length];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl5 = [imageUrl5 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.material = [examModel.material stringByReplacingOccurrencesOfString:imageUrl5Pre withString:imageUrl5];
            
            NSRange range11 = [tempString rangeOfString:@"src='"];
            NSRange range12 = [tempString rangeOfString:@"' />"];
            if(range11.length != 5)
            {
                continue;
            }
            NSString *imageUrl6 = [tempString substringWithRange:NSMakeRange(range11.location+5, range12.location-range11.location-5)];
            NSString *imageUrl6Pre = imageUrl6;
            tempString = [tempString substringFromIndex:range12.location+range12.length];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl6 = [imageUrl6 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.material = [examModel.material stringByReplacingOccurrencesOfString:imageUrl6Pre withString:imageUrl6];
            
            NSRange range13 = [tempString rangeOfString:@"src='"];
            NSRange range14 = [tempString rangeOfString:@"' />"];
            if(range13.length != 5)
            {
                continue;
            }
            NSString *imageUrl7 = [tempString substringWithRange:NSMakeRange(range13.location+5, range14.location-range13.location-5)];
            NSString *imageUrl7Pre = imageUrl7;
            tempString = [tempString substringFromIndex:range14.location+range14.length];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl7 = [imageUrl7 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.material = [examModel.material stringByReplacingOccurrencesOfString:imageUrl7Pre withString:imageUrl7];
            
            NSRange range15 = [tempString rangeOfString:@"src='"];
            NSRange range16 = [tempString rangeOfString:@"' />"];
            if(range15.length != 5)
            {
                continue;
            }
            NSString *imageUrl8 = [tempString substringWithRange:NSMakeRange(range15.location+5, range16.location-range15.location-5)];
            NSString *imageUrl8Pre = imageUrl8;
            tempString = [tempString substringFromIndex:range16.location+range16.length];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl8 = [imageUrl8 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.material = [examModel.material stringByReplacingOccurrencesOfString:imageUrl8Pre withString:imageUrl8];
        }
    }
    
    for(ExamDetailModel *examModel in self.practiceList)
    {
        if(!strIsNullOrEmpty(examModel.title))
        {
            NSString *tempString = examModel.title;
            NSRange range1 = [tempString rangeOfString:@"src='"];
            NSRange range2 = [tempString rangeOfString:@"' />"];
            if(range1.length != 5)
            {
                continue;
            }
            NSString *imageUrl1 = [tempString substringWithRange:NSMakeRange(range1.location+5, range2.location-range1.location-5)];
            NSString *imageUrl1Pre = imageUrl1;
            tempString = [tempString substringFromIndex:range2.location+range2.length];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl1 = [imageUrl1 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.title = [examModel.title stringByReplacingOccurrencesOfString:imageUrl1Pre withString:imageUrl1];
            
            NSRange range3 = [tempString rangeOfString:@"src='"];
            NSRange range4 = [tempString rangeOfString:@"' />"];
            if(range3.length != 5)
            {
                continue;
            }
            NSString *imageUrl2 = [tempString substringWithRange:NSMakeRange(range3.location+5, range4.location-range3.location-5)];
            NSString *imageUrl2Pre = imageUrl2;
            tempString = [tempString substringFromIndex:range4.location+range4.length];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl2 = [imageUrl2 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.title = [examModel.title stringByReplacingOccurrencesOfString:imageUrl2Pre withString:imageUrl2];
            
            NSRange range5 = [tempString rangeOfString:@"src='"];
            NSRange range6 = [tempString rangeOfString:@"' />"];
            if(range5.length != 5)
            {
                continue;
            }
            NSString *imageUrl3 = [tempString substringWithRange:NSMakeRange(range5.location+5, range6.location-range5.location-5)];
            NSString *imageUrl3Pre = imageUrl3;
            tempString = [tempString substringFromIndex:range6.location+range6.length];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl3 = [imageUrl3 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.title = [examModel.title stringByReplacingOccurrencesOfString:imageUrl3Pre withString:imageUrl3];
            
            NSRange range7 = [tempString rangeOfString:@"src='"];
            NSRange range8 = [tempString rangeOfString:@"' />"];
            if(range7.length != 5)
            {
                continue;
            }
            NSString *imageUrl4 = [tempString substringWithRange:NSMakeRange(range7.location+5, range8.location-range7.location-5)];
            NSString *imageUrl4Pre = imageUrl4;
            tempString = [tempString substringFromIndex:range8.location+range8.length];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl4 = [imageUrl4 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.title = [examModel.title stringByReplacingOccurrencesOfString:imageUrl4Pre withString:imageUrl4];
            
            NSRange range9 = [tempString rangeOfString:@"src='"];
            NSRange range10 = [tempString rangeOfString:@"' />"];
            if(range9.length != 5)
            {
                continue;
            }
            NSString *imageUrl5 = [tempString substringWithRange:NSMakeRange(range9.location+5, range10.location-range9.location-5)];
            NSString *imageUrl5Pre = imageUrl5;
            tempString = [tempString substringFromIndex:range10.location+range10.length];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl5 = [imageUrl5 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.title = [examModel.title stringByReplacingOccurrencesOfString:imageUrl5Pre withString:imageUrl5];
            
            NSRange range11 = [tempString rangeOfString:@"src='"];
            NSRange range12 = [tempString rangeOfString:@"' />"];
            if(range11.length != 5)
            {
                continue;
            }
            NSString *imageUrl6 = [tempString substringWithRange:NSMakeRange(range11.location+5, range12.location-range11.location-5)];
            NSString *imageUrl6Pre = imageUrl6;
            tempString = [tempString substringFromIndex:range12.location+range12.length];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl6 = [imageUrl6 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.title = [examModel.title stringByReplacingOccurrencesOfString:imageUrl6Pre withString:imageUrl6];
            
            NSRange range13 = [tempString rangeOfString:@"src='"];
            NSRange range14 = [tempString rangeOfString:@"' />"];
            if(range13.length != 5)
            {
                continue;
            }
            NSString *imageUrl7 = [tempString substringWithRange:NSMakeRange(range13.location+5, range14.location-range13.location-5)];
            NSString *imageUrl7Pre = imageUrl7;
            tempString = [tempString substringFromIndex:range14.location+range14.length];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl7 = [imageUrl7 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.title = [examModel.title stringByReplacingOccurrencesOfString:imageUrl7Pre withString:imageUrl7];
            
            NSRange range15 = [tempString rangeOfString:@"src='"];
            NSRange range16 = [tempString rangeOfString:@"' />"];
            if(range15.length != 5)
            {
                continue;
            }
            NSString *imageUrl8 = [tempString substringWithRange:NSMakeRange(range15.location+5, range16.location-range15.location-5)];
            NSString *imageUrl8Pre = imageUrl8;
            tempString = [tempString substringFromIndex:range16.location+range16.length];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            imageUrl8 = [imageUrl8 stringByAppendingString:[NSString stringWithFormat:@"' width='%d", (int)kScreenWidth-48]];
            examModel.title = [examModel.title stringByReplacingOccurrencesOfString:imageUrl8Pre withString:imageUrl8];
        }
    }
}

- (void)addExamListToDB
{
    NSString *isFromIntelligent = nil;
    if([self.title containsString:@"智能"]||[self.title containsString:@"专项"])
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
    
    for(ExamDetailModel *model in self.practiceList)
    {
        model.isFromIntelligent = isFromIntelligent;
        model.isFromOutLine = isFromOutLine;
        model.OID = currentOID;
        [[DataBaseManager sharedManager] addExamDetail:model];
    }
}

- (void)getExamOprationList
{
    NSString *isFromIntelligent = nil;
    if([self.title containsString:@"智能"]||[self.title containsString:@"专项"])
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
        ExamOperaterModel *operaterModel =  [[DataBaseManager sharedManager] getExamOperationListByExamID:examModel.ID EID:examModel.EID OID:currentOID isFromOutLine:isFromOutLine isFromIntelligent:isFromIntelligent];
        if(operaterModel)
        {
            NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:9];
            [resultDict setObject:examModel.ID forKey:@"ExamID"];
            [resultDict setObject:examModel.EID forKey:@"EID"];
            [resultDict setObject:operaterModel.isFromIntelligent forKey:@"isFromIntelligent"];
            [resultDict setObject:operaterModel.isFromOutLine forKey:@"isFromOutLine"];
            [resultDict setObject:operaterModel.TagFlag forKey:@"TagFlag"];
            [resultDict setObject:operaterModel.Answer forKey:@"Answer"];
            [resultDict setObject:operaterModel.GetScore forKey:@"GetScore"];
            [resultDict setObject:operaterModel.isOK forKey:@"isOK"];
            [resultDict setObject:operaterModel.OID forKey:@"OID"];
            [resultDict setObject:operaterModel.isSelected forKey:@"isSelected"];
            self.selectExamIndex = operaterModel.isSelected.integerValue;
            
            [self.userResultDict setObject:resultDict forKey:[NSNumber numberWithInt:index]];
        }
        
    }
}

- (void)dealloc
{
    [[LdGlobalObj sharedInstanse] stopExamTimer];
    [[LdGlobalObj sharedInstanse] removeObserver:self forKeyPath:@"examTimerNumber"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AnswerSheetTouchExamButtonNotification" object:nil];
}

- (void)backButtonPressed
{
    NSMutableDictionary *realResultDict = [NSMutableDictionary dictionaryWithCapacity:9];
    for(NSNumber *indexNumber in self.userResultDict.allKeys)
    {
        NSDictionary *resultDict = self.userResultDict[indexNumber];
        if(resultDict[@"Answer"])
        {
            [realResultDict setObject:[NSDictionary dictionaryWithDictionary:self.userResultDict[indexNumber]] forKey:indexNumber];
        }
    }
    
    if(realResultDict.allKeys.count == self.practiceList.count)
    {
        BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"你已做完题目，先交卷？" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"确定"];
        LL_WEAK_OBJC(self);
        [alertView setConfirmBlock:^{
            AnswerSheetViewController *vc = [[AnswerSheetViewController alloc] init];
            vc.DailyPracticeTitle = self.title;
            vc.OID = self.OID;
            vc.practiceList = [NSMutableArray arrayWithArray:self.practiceList];
            vc.userResultDict = [NSMutableDictionary dictionaryWithDictionary:self.userResultDict];
            vc.isMockExamType = self.isMockExamType;
            [weakself.navigationController pushViewController:vc animated:NO];
            
            [weakself performSelector:@selector(laterSubmitAction:) withObject:vc afterDelay:0.3];
        }];
        [alertView setCancelBlock:^{
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
        [alertView show];
    }
    else if(realResultDict.allKeys.count > 0)
    {
        if(!self.isSaveUserOperation)
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        //是/否 保存 当前练习状态
        BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"是否保存当前练习状态？" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"保存"];
        LL_WEAK_OBJC(self);
        [alertView setConfirmBlock:^{
            for(NSNumber *indexNumber in realResultDict.allKeys)
            {
                NSDictionary *resultDict = realResultDict[indexNumber];
                ExamOperaterModel *operationModel = [ExamOperaterModel model];
                [operationModel setDataWithDic:resultDict];
                operationModel.isSelected = [NSString stringWithFormat:@"%d", (int)self.selectExamIndex];
                [[DataBaseManager sharedManager] addUserOperate:operationModel];
            }
            
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
        [alertView setCancelBlock:^{
            
            NSString *isFromIntelligent = nil;
            if([self.title containsString:@"智能"]||[self.title containsString:@"专项"])
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
            
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
        [alertView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)drawViews
{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [_backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    
    //设置滚动条类型
    self.examScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    //是否自动裁切超出部分
    self.examScrollView.clipsToBounds = YES;
    //设置是否可以缩放
    self.examScrollView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    self.examScrollView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.examScrollView.directionalLockEnabled = NO;
    self.examScrollView.backgroundColor = kColorBarGrayBackground;
    self.examScrollView.userInteractionEnabled = YES;
    self.examScrollView.delegate = self;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.examScrollView.alwaysBounceHorizontal = NO;
    self.examScrollView.alwaysBounceVertical = NO;
    self.examScrollView.showsHorizontalScrollIndicator = NO;
    self.examScrollView.showsVerticalScrollIndicator = NO;
    
    self.examPageControl.numberOfPages = [self.practiceList count];
    self.examPageControl.currentPage = 0;
    self.examPageControl.hidden = YES;
    
    NSInteger tableViewCount = 0;
    if(IOS9_OR_LATER)
    {
        tableViewCount = self.practiceList.count<kMaxTableViewLimit ? self.practiceList.count : kMaxTableViewLimit;
    }
    else
    {
        tableViewCount = self.practiceList.count;
    }
    
    for(int index=0; index<tableViewCount; index++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(index*Screen_Width, 0, Screen_Width, Screen_Height-StatusBarAndNavigationBarHeight-44-40-TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = index;
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            tableView.backgroundColor = UIColorFromHex(0x20282f);
        }
        else
        {
            tableView.backgroundColor = kColorBarGrayBackground;
        }
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        [self.examScrollView addSubview:tableView];
        [self.tableViewList addObject:tableView];
    }
    
    [self.examScrollView setContentSize:CGSizeMake(Screen_Width*self.practiceList.count, 40)];
    
    [[LdGlobalObj sharedInstanse] addObserver:self
           forKeyPath:@"examTimerNumber"
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
              context:NULL];
    [[LdGlobalObj sharedInstanse] startExamTimer];
    
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x7a8596) ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x2b3f5d);
        [_dailyButton setImage:[UIImage imageNamed:@"night_btn_history"] forState:UIControlStateNormal];
        
        self.examScrollView.backgroundColor = [UIColor blackColor];
        self.functionBackView.backgroundColor = UIColorFromHex(0x213451);
        for(UIView *subView in self.examScrollView.subviews)
        {
            if([subView isKindOfClass:[UITableView class]])
            {
                subView.backgroundColor = UIColorFromHex(0x20282f);
            }
        }
        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        [self.draftBtn setImage:[UIImage imageNamed:@"night_icon_caogao"] forState:UIControlStateNormal];
        [self.answerSheetBtn setImage:[UIImage imageNamed:@"night_icon_datika"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"night_icon_collect"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"night_icon_share"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"night_icon_more"] forState:UIControlStateNormal];
        [self.TimerBtn setTitleColor:UIColorFromHex(0x7a8596) forState:UIControlStateNormal];
        self.bottomContentView.backgroundColor = UIColorFromHex(0x29323a);
        [self.PreBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
        [self.NextBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
        self.bottomTitleLabel.textColor = UIColorFromHex(0x666666);
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
        [_dailyButton setImage:[UIImage imageNamed:@"day_btn_history"] forState:UIControlStateNormal];
        
        self.examScrollView.backgroundColor = [UIColor whiteColor];
        self.functionBackView.backgroundColor = UIColorFromHex(0x1e9aed);
        for(UIView *subView in self.examScrollView.subviews)
        {
            if([subView isKindOfClass:[UITableView class]])
            {
                subView.backgroundColor = kColorBarGrayBackground;
            }
        }
        
        [self.backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
        [self.draftBtn setImage:[UIImage imageNamed:@"shiti_icon_caogao"] forState:UIControlStateNormal];
        [self.answerSheetBtn setImage:[UIImage imageNamed:@"shiti_icon_datika"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"shiti_icon_collect"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"shiti_icon_share"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"day_shiti_icon_more"] forState:UIControlStateNormal];
        [self.TimerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.bottomContentView.backgroundColor = [UIColor whiteColor];
        [self.PreBtn setTitleColor:kColorNavigationBar forState:UIControlStateNormal];
        [self.NextBtn setTitleColor:kColorNavigationBar forState:UIControlStateNormal];
        self.bottomTitleLabel.textColor = kColorDarkText;
    }
    
    self.bottomTitleLabel.text = [NSString stringWithFormat:@"1/%d", (int)self.practiceList.count];
}

- (void)refreshViewByDayNightType
{
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x7a8596) ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x2b3f5d);
        [_dailyButton setImage:[UIImage imageNamed:@"night_btn_history"] forState:UIControlStateNormal];
        
        self.view.backgroundColor = UIColorFromHex(0x20282f);
        self.examScrollView.backgroundColor = [UIColor blackColor];
        self.functionBackView.backgroundColor = UIColorFromHex(0x213451);
        for(UIView *subView in self.examScrollView.subviews)
        {
            if([subView isKindOfClass:[UITableView class]])
            {
                subView.backgroundColor = UIColorFromHex(0x20282f);
            }
        }
        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        [self.draftBtn setImage:[UIImage imageNamed:@"night_icon_caogao"] forState:UIControlStateNormal];
        [self.answerSheetBtn setImage:[UIImage imageNamed:@"night_icon_datika"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"night_icon_collect"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"night_icon_share"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"night_icon_more"] forState:UIControlStateNormal];
        [self.TimerBtn setTitleColor:UIColorFromHex(0x7a8596) forState:UIControlStateNormal];
        self.bottomContentView.backgroundColor = UIColorFromHex(0x29323a);
        [self.PreBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
        [self.NextBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
        self.bottomTitleLabel.textColor = UIColorFromHex(0x666666);
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
        [_dailyButton setImage:[UIImage imageNamed:@"day_btn_history"] forState:UIControlStateNormal];
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.examScrollView.backgroundColor = [UIColor whiteColor];
        self.functionBackView.backgroundColor = UIColorFromHex(0x1e9aed);
        for(UIView *subView in self.examScrollView.subviews)
        {
            if([subView isKindOfClass:[UITableView class]])
            {
                subView.backgroundColor = kColorBarGrayBackground;
            }
        }
        
        [self.backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
        [self.draftBtn setImage:[UIImage imageNamed:@"shiti_icon_caogao"] forState:UIControlStateNormal];
        [self.answerSheetBtn setImage:[UIImage imageNamed:@"shiti_icon_datika"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"shiti_icon_collect"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"shiti_icon_share"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"day_shiti_icon_more"] forState:UIControlStateNormal];
        [self.TimerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.bottomContentView.backgroundColor = [UIColor whiteColor];
        [self.PreBtn setTitleColor:kColorNavigationBar forState:UIControlStateNormal];
        [self.NextBtn setTitleColor:kColorNavigationBar forState:UIControlStateNormal];
        self.bottomTitleLabel.textColor = kColorDarkText;
    }
    
    if(self.practiceList.count > 0)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self.globalAttributeDictionary removeAllObjects];
        [self reloadCurrentTableViewDatas];
        [SVProgressHUD dismiss];
    }
    
    [self showIsTagView];
}

- (void)reloadCurrentTableViewDatas
{
    if(IOS9_OR_LATER)
    {
        for(int index=0; index<self.practiceList.count; index++)
        {
            if(index == self.selectExamIndex)
            {
                [self yibuLoadAttributeStringBy:index];
            }
        }
    }
    else
    {
        for(UITableView *tableView in self.tableViewList)
        {
            [tableView reloadData];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.examScrollView)
    {
        //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
        int currentPage = floor((self.examScrollView.contentOffset.x - Screen_Width / ([self.practiceList count]+0)) / Screen_Width) + 1;
        if(currentPage>=self.practiceList.count)
        {
            return;
        }
        
        NSLog(@"begin reloadSelectTableViewBy %d", currentPage);
        
        //切换改变页码，小圆点
        if(scrollView == self.examScrollView)
        {
            self.examPageControl.currentPage = currentPage;
            [self refreshScrollViewByIndex:currentPage];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.examScrollView)
    {
        if(scrollView.contentOffset.x > scrollView.contentSize.width-Screen_Width+60)
        {
            [self nextBtnAction];
        }
    }
}

- (void)refreshScrollViewByIndex:(NSInteger)index
{
    if(IOS9_OR_LATER)
    {
        self.selectExamIndex = index;
        [self yibuLoadAttributeStringBy:index];
//        if(index-1 > 0)
//        {
//            [self yibuLoadAttributeStringBy:index-1];
//        }
//        
//        if(index+1 < self.practiceList.count)
//        {
//            [self yibuLoadAttributeStringBy:index+1];
//        }
        
    }
    else
    {
        self.selectExamIndex = index;
    }
    
    if(index == self.practiceList.count-1){
        [self.NextBtn setTitle:@"提交答案" forState:UIControlStateNormal];
    }else{
        [self.NextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }
   
    self.bottomTitleLabel.text = [NSString stringWithFormat:@"%d/%d", (int)index+1, (int)self.practiceList.count];
    //判断是否收藏
    [self showIsCollectView];
    
    [self showIsTagView];
}

//异步加载
- (void)yibuLoadAttributeStringBy:(NSInteger) currentIndex
{
    if([self.globalAttributeDictionary objectForKey:[NSNumber numberWithInteger:currentIndex]])
    {
        [self reloadSelectTableViewInMainThreadBy:[NSNumber numberWithInteger:currentIndex]];
        return;
    }
    
    LL_WEAK_OBJC(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger currentIndex1 = currentIndex;
        
        NSMutableDictionary *attributedDictionary = [NSMutableDictionary dictionaryWithCapacity:9];
        ExamDetailModel *examModel = self.practiceList[currentIndex1];
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        NSString *title = [NSString stringWithFormat:@"%ld.    %@", (long)currentIndex1+1, examModel.title];
        NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                  options:options
                                                                                       documentAttributes:nil
                                                                                                    error:nil];
        
        [titleAttributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize] range:NSMakeRange(0, [titleAttributeString length])];
        [titleAttributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleAttributeString length])];
        [attributedDictionary setObject:titleAttributeString forKey:@"globalTitleAttributeString"];
        
        NSMutableAttributedString *materialAttributeString = [[NSMutableAttributedString alloc] initWithData:[examModel.material dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                     options:options
                                                                                          documentAttributes:nil
                                                                                                       error:nil];
        [materialAttributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize] range:NSMakeRange(0, [materialAttributeString length])];
        [materialAttributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [materialAttributeString length])];
        [attributedDictionary setObject:materialAttributeString forKey:@"globalMaterialAttributeString"];
        
        NSMutableArray *globalOptionAttributeStringList = [NSMutableArray arrayWithCapacity:9];
        for(int optionIndex=0; optionIndex<examModel.list_TitleList.count; optionIndex++)
        {
            ExamDetailOptionModel *examOptionModel = examModel.list_TitleList[optionIndex];
            
            NSString *title = [NSString stringWithFormat:@"%@", examOptionModel.SList];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                 options:options
                                                                                      documentAttributes:nil
                                                                                                   error:nil];
            [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize] range:NSMakeRange(0, [attributeString length])];
            [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributeString length])];
            CGSize attributeSize = [LdGlobalObj sizeWithAttributedString:attributeString width:Screen_Width-78];
            NSInteger rowNum = attributeSize.height/[UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize].lineHeight;
            if(rowNum==1)
            {
                [attributeString removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, [attributeString length])];
            }
            [globalOptionAttributeStringList addObject:attributeString];
        }
        [attributedDictionary setObject:globalOptionAttributeStringList forKey:@"globalOptionAttributeStringList"];
        [weakself.globalAttributeDictionary setObject:attributedDictionary forKey:[NSNumber numberWithInteger:currentIndex1]];
        
        [weakself performSelectorOnMainThread:@selector(reloadSelectTableViewInMainThreadBy:) withObject:[NSNumber numberWithInteger:currentIndex1] waitUntilDone:NO];
    });
}

- (void)reloadSelectTableViewInMainThreadBy:(NSNumber *)index
{
    for(UITableView *tableView in self.tableViewList)
    {
        if(tableView.tag == index.integerValue)
        {
            [tableView reloadData];
            return;
        }
    }
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(index.integerValue*Screen_Width, 0, Screen_Width, Screen_Height-104-43) style:UITableViewStyleGrouped];
    tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    tempTableView.tag = index.integerValue;
    tempTableView.cellLayoutMarginsFollowReadableWidth = NO;
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        tempTableView.backgroundColor = UIColorFromHex(0x20282f);
    }
    else
    {
        tempTableView.backgroundColor = kColorBarGrayBackground;
    }
    [self.examScrollView addSubview:tempTableView];
    [self.tableViewList addObject:tempTableView];
    
    if(self.tableViewList.count > kMaxTableViewLimit)
    {
        UITableView *removeTableView = self.tableViewList[0];
        [self.tableViewList removeObject:removeTableView];
        [removeTableView removeFromSuperview];
        removeTableView = nil;
    }
}

- (void)refreshScrollViewFromAnswerScrollViewIndex:(NSNotification *)notification
{
    NSNumber *number = notification.object;
    
    self.examPageControl.currentPage = number.integerValue;
    [self.examScrollView scrollRectToVisible:CGRectMake(number.integerValue*Screen_Width, 0, Screen_Width, 10)  animated:YES];
    [self refreshScrollViewByIndex:number.integerValue];
}

- (void)laterSubmitAction:(AnswerSheetViewController *)vc
{
    [vc submitAction:nil fromPractice:YES];
}

- (void)dailyButtonPressed
{
    CourseCalendarViewController *vc = [[CourseCalendarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nextBtnAction
{
    if(self.selectExamIndex < self.practiceList.count-1)
    {
        self.examPageControl.currentPage = self.selectExamIndex+1;
        [self.examScrollView scrollRectToVisible:CGRectMake((self.selectExamIndex+1)*Screen_Width, 0, Screen_Width, 10)  animated:YES];
        [self refreshScrollViewByIndex:self.selectExamIndex+1];
    }
    else
    {
        AnswerSheetViewController *vc = [[AnswerSheetViewController alloc] init];
        vc.DailyPracticeTitle = self.title;
        vc.OID = self.OID;
        vc.practiceList = [NSMutableArray arrayWithArray:self.practiceList];
        vc.userResultDict = [NSMutableDictionary dictionaryWithDictionary:self.userResultDict];
        vc.isMockExamType = self.isMockExamType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)preBtnAction
{
    if(self.selectExamIndex > 0)
    {
        self.examPageControl.currentPage = self.selectExamIndex-1;
        [self.examScrollView scrollRectToVisible:CGRectMake((self.selectExamIndex-1)*Screen_Width, 0, Screen_Width, 10)  animated:YES];
        [self refreshScrollViewByIndex:self.selectExamIndex-1];
    }
}

- (IBAction)AnswerSheetAction:(id)sender
{
    AnswerSheetViewController *vc = [[AnswerSheetViewController alloc] init];
    vc.DailyPracticeTitle = self.title;
    vc.OID = self.OID;
    vc.practiceList = [NSMutableArray arrayWithArray:self.practiceList];
    vc.userResultDict = [NSMutableDictionary dictionaryWithDictionary:self.userResultDict];
    vc.isMockExamType = self.isMockExamType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)collectAction:(id)sender
{
    BOOL isCollect = NO;
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    BOOL isIntelligent = NO;
    NSString *examType = @"试题";
    isIntelligent = [self.title containsString:@"智能"]||[self.title containsString:@"专项"];
    if(isIntelligent)
    {
        examType = @"专项智能";
    }
    
    for(NSDictionary *dict in self.favoriteExamList)
    {
        NSString *LinkID = dict[@"LinkID"];
        NSString *FType = dict[@"FType"];
        if([LinkID isEqualToString:examModel.ID]&&[FType isEqualToString:examType])
        {
            isCollect = YES;
            break;
        }
    }
    
    if(isCollect)
    {
        [self NetworkSubmitDeleteFavorite];
    }
    else
    {
        [self NetworkSubmitPutFavorite];
    }
}

- (void)showIsCollectView
{
    BOOL isIntelligent = NO;
    NSString *examType = @"试题";
    isIntelligent = [self.title containsString:@"智能"]||[self.title containsString:@"专项"];
    if(isIntelligent)
    {
        examType = @"专项智能";
    }
    
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [self.collectBtn setImage:[UIImage imageNamed:@"night_icon_collect"] forState:UIControlStateNormal];
    }
    else
    {
        [self.collectBtn setImage:[UIImage imageNamed:@"shiti_icon_collect"] forState:UIControlStateNormal];
    }
    
    for(NSDictionary *dict in self.favoriteExamList)
    {
        NSString *LinkID = dict[@"LinkID"];
        NSString *FType = dict[@"FType"];
        if([LinkID isEqualToString:examModel.ID]&&[FType isEqualToString:examType])
        {
            [self.collectBtn setImage:[UIImage imageNamed:@"zhibo_detail_icon_collect_press"] forState:UIControlStateNormal];
            break;
        }
    }
}

- (void)shareToPlatformType:(UMSocialPlatformType)platformType
{
    //设置网页地址
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString* content = examModel.title;
    NSString *des = @"考银行就用银行易考！";
    if(!strIsNullOrEmpty(content)){
        NSRange range = [content rangeOfString:@"<"];
        float index_img = range.location;
        if(index_img>=0 && index_img<=10){
            des = examModel.content;
        }else{
            if(index_img == NSNotFound){
                if([content length]>30){
                    NSString* contents = [content substringToIndex:30];
                    des = contents;
                }else{
                    des = content;
                }
            }else{
                NSString* contents = [content substringToIndex:index_img-1];
                des = contents;
            }
        }
    }
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.title descr:des thumImage:[UIImage imageNamed:@"shareIcon.png"]];
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://yk.yinhangzhaopin.com/bshWeb/exam/ViewTitle.jsp?ID=%@&FLAG=%d", examModel.ID, [self.title containsString:@"智能"]||[self.title containsString:@"专项"] ? 1 : 0];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            ZB_Toast(@"分享失败");
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            ZB_Toast(@"分享成功");
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (IBAction)shareAction:(id)sender
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareToPlatformType:platformType];
    }];
    
}

- (IBAction)tagAction:(id)sender
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:self.userResultDict[[NSNumber numberWithInteger:self.selectExamIndex]]];
    if(!resultDict)
    {
        resultDict = [NSMutableDictionary dictionaryWithObject:@"是" forKey:@"TagFlag"];
    }
    else
    {
        NSString *TagFlag = resultDict[@"TagFlag"];
        if(TagFlag)
        {
            if([TagFlag isEqualToString:@"是"])
            {
                [resultDict setObject:@"否" forKey:@"TagFlag"];
            }
            else
            {
                [resultDict setObject:@"是" forKey:@"TagFlag"];
            }
        }
        else
        {
            [resultDict setObject:@"是" forKey:@"TagFlag"];
        }
    }
    
    NSString *TagFlag = [resultDict objectForKey:@"TagFlag"];
    if([TagFlag isEqualToString:@"是"])
    {
        ZB_Toast(@"已标记");
    }
    else
    {
        ZB_Toast(@"已取消标记");
    }
    
    [self.userResultDict setObject:resultDict forKey:[NSNumber numberWithInteger:self.selectExamIndex]];
    [self showIsTagView];
}

- (void)showIsTagView
{
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [self.tagBtn setImage:[UIImage imageNamed:@"night_exam_tag"] forState:UIControlStateNormal];
    }
    else
    {
        [self.tagBtn setImage:[UIImage imageNamed:@"exam_tag"] forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:self.userResultDict[[NSNumber numberWithInteger:self.selectExamIndex]]];
    if(resultDict)
    {
        NSString *TagFlag = resultDict[@"TagFlag"];
        if([TagFlag isEqualToString:@"是"])
        {
            if([LdGlobalObj sharedInstanse].isNightExamFlag)
            {
                [self.tagBtn setImage:[UIImage imageNamed:@"night_exam_Taged"] forState:UIControlStateNormal];
            }
            else
            {
                [self.tagBtn setImage:[UIImage imageNamed:@"exam_Taged"] forState:UIControlStateNormal];
            }
            
        }
    }
}

- (void)ReportErrorAction
{
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    ReportErrorViewController *vc = [[ReportErrorViewController alloc] init];
    vc.examModel = examModel;
    vc.isFromIntelligent = [self.title containsString:@"智能"]||[self.title containsString:@"专项"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)moreAction:(id)sender
{
    if(self.moreView)
    {
        [self quitMoreButtonAction];
    }
    
    [self.moreView removeFromSuperview];
    self.moreView = nil;
    self.moreView = [[[NSBundle mainBundle] loadNibNamed:@"AnalysisMoreView" owner:nil options:nil] firstObject];
    self.moreView.frame = CGRectMake(Screen_Width-150, StatusBarAndNavigationBarHeight+40, 150, 158);
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
    
    self.moreView.moreShareBtnBlock = ^(){
        [weakself shareAction:nil];
    };
    
    self.moreView.moreFontBtnBlock = ^(int fontSize){
        [LdGlobalObj sharedInstanse].examFontSize = fontSize;
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[NSNumber numberWithInt:fontSize] forKey:@"examFontSize"];
        [def synchronize];
        
        if(weakself.practiceList.count > 0)
        {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [weakself.globalAttributeDictionary removeAllObjects];
            [weakself reloadCurrentTableViewDatas];
            [SVProgressHUD dismiss];
        }
    };
    
    self.moreView.moreReportErrorBtnBlock = ^(){
        [weakself ReportErrorAction];
    };
}

- (void)quitMoreButtonAction
{
    [self.moreView removeFromSuperview];
    self.moreView = nil;
    [self.quitMoreButton removeFromSuperview];
    self.quitMoreButton = nil;
}

#pragma -mark TimerStop
- (IBAction)timerStopAction:(id)sender
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
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:9];
    for(NSNumber *indexNumber in self.userResultDict.allKeys)
    {
        NSDictionary *resultDict = self.userResultDict[indexNumber];
        if(resultDict[@"Answer"])
        {
            [tempDict setObject:[NSDictionary dictionaryWithDictionary:self.userResultDict[indexNumber]] forKey:indexNumber];
        }
    }
    label2.text = [NSString stringWithFormat:@"共%d道题，还剩%d道未做", (int)self.practiceList.count, (int)(self.practiceList.count-tempDict.allKeys.count)];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"examTimerNumber"])
    {
        NSNumber *num = [change valueForKey:NSKeyValueChangeNewKey];
        [self.TimerBtn setTitle:[NSString stringWithFormat:@"%02d:%02d", num.intValue/60, num.intValue%60] forState:UIControlStateNormal];
        
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:self.userResultDict[[NSNumber numberWithInteger:self.selectExamIndex]]];
        if(resultDict)
        {
            NSNumber *UseTimer = resultDict[@"UserTime"];
            if(UseTimer)
            {
                UseTimer = [NSNumber numberWithInteger:(UseTimer.integerValue+1)];
            }
            else
            {
                UseTimer = [NSNumber numberWithInteger:1];
            }
            [resultDict setObject:UseTimer forKey:@"UserTime"];
        }
        else
        {
            resultDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:1] forKey:@"UseTimer"];
        }
        
        [self.userResultDict setObject:resultDict forKey:[NSNumber numberWithInteger:self.selectExamIndex]];
    }
    else if([keyPath isEqualToString:@"pathCountNumber"])
    {
        if([self.drawView isCanUndo])
        {
            _undoDraftButton.userInteractionEnabled = YES;
            if([LdGlobalObj sharedInstanse].isNightExamFlag)
            {
                [_undoDraftButton setImage:[UIImage imageNamed:@"night_caogao_icon_revoke_right"] forState:UIControlStateNormal];
            }
            else
            {
                [_undoDraftButton setImage:[UIImage imageNamed:@"caogao_icon_revoke_right"] forState:UIControlStateNormal];
            }
        }
        else
        {
            _undoDraftButton.userInteractionEnabled = NO;
            if([LdGlobalObj sharedInstanse].isNightExamFlag)
            {
                [_undoDraftButton setImage:[UIImage imageNamed:@"night_caogao_icon_revoke_right_none"] forState:UIControlStateNormal];
            }
            else
            {
                [_undoDraftButton setImage:[UIImage imageNamed:@"caogao_icon_revoke_right_none"] forState:UIControlStateNormal];
            }
        }
        
        if([self.drawView isCanResume])
        {
            _forwordDraftButton.userInteractionEnabled = YES;
            if([LdGlobalObj sharedInstanse].isNightExamFlag)
            {
                [_forwordDraftButton setImage:[UIImage imageNamed:@"night_caogao_icon_revoke_left"] forState:UIControlStateNormal];
            }
            else
            {
                [_forwordDraftButton setImage:[UIImage imageNamed:@"caogao_icon_revoke_left"] forState:UIControlStateNormal];
            }
        }
        else
        {
            _forwordDraftButton.userInteractionEnabled = NO;
            if([LdGlobalObj sharedInstanse].isNightExamFlag)
            {
                [_forwordDraftButton setImage:[UIImage imageNamed:@"night_caogao_icon_revoke_left_none"] forState:UIControlStateNormal];
            }
            else
            {
                [_forwordDraftButton setImage:[UIImage imageNamed:@"caogao_icon_revoke_left_none"] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma -mark DraftBook
- (IBAction)DraftBookAction:(id)sender
{
    if(self.drawView)
    {
        return;
    }
    self.drawView = [[WDDrawView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, Screen_Height)];
    self.drawView.backgroundColor = kColorBarGrayBackground;
    self.drawView.alpha = 0.8;
    [self.view addSubview:self.drawView];
    
    [self.drawView addObserver:self forKeyPath:@"pathCountNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.drawView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    }];
    
    UIButton *closeDraftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeDraftButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [closeDraftButton setImage:[UIImage imageNamed:@"night_caogao_icon_cancle"] forState:UIControlStateNormal];
    }
    else
    {
        [closeDraftButton setImage:[UIImage imageNamed:@"caogao_icon_cancle"] forState:UIControlStateNormal];
    }
    [closeDraftButton addTarget:self action:@selector(closeDraftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeDraftButton];
    
    _forwordDraftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _forwordDraftButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [_forwordDraftButton setImage:[UIImage imageNamed:@"night_caogao_icon_revoke_left_none"] forState:UIControlStateNormal];
    }
    else
    {
        [_forwordDraftButton setImage:[UIImage imageNamed:@"caogao_icon_revoke_left_none"] forState:UIControlStateNormal];
    }
    [_forwordDraftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [_forwordDraftButton addTarget:self action:@selector(forwordDraftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_forwordDraftButton];
    
    UIView *titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width-100, 44)];
    self.navigationItem.titleView = titleBarView;
    
    _undoDraftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _undoDraftButton.frame = CGRectMake(50.0f, 0.0f, 44.0f, 44.0f);
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [_undoDraftButton setImage:[UIImage imageNamed:@"night_caogao_icon_revoke_right_none"] forState:UIControlStateNormal];
    }
    else
    {
        [_undoDraftButton setImage:[UIImage imageNamed:@"caogao_icon_revoke_right_none"] forState:UIControlStateNormal];
    }
    [_undoDraftButton addTarget:self action:@selector(undoDraftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [titleBarView addSubview:_undoDraftButton];
    
    UIButton *clearDraftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearDraftButton.frame = CGRectMake(titleBarView.width-94, 0.0f, 44.0f, 44.0f);
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [clearDraftButton setImage:[UIImage imageNamed:@"night_caogao_icon_rubbish"] forState:UIControlStateNormal];
    }
    else
    {
        [clearDraftButton setImage:[UIImage imageNamed:@"caogao_icon_rubbish"] forState:UIControlStateNormal];
    }
    [clearDraftButton addTarget:self action:@selector(clearDraftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [titleBarView addSubview:clearDraftButton];
}

- (void)closeDraftButtonPressed
{
    [UIView animateWithDuration:0.8 animations:^{
        self.drawView.frame = CGRectMake(0, Screen_Height, Screen_Width, Screen_Height);
    } completion:^(BOOL finished) {
        [self.drawView removeObserver:self forKeyPath:@"pathCountNumber"];
        [self.drawView removeFromSuperview];
        self.drawView = nil;
        
        self.navigationItem.titleView = nil;
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
        [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        UIButton *dailyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dailyButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
        [dailyButton setImage:[UIImage imageNamed:@"icn_message"] forState:UIControlStateNormal];
        [dailyButton addTarget:self action:@selector(dailyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [dailyButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dailyButton];
    }];
}

- (void)forwordDraftButtonPressed
{
    [self.drawView resume];
}

- (void)undoDraftButtonPressed
{
    [self.drawView undo];
}

- (void)clearDraftButtonPressed
{
    [self.drawView clear];
}

#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((tableView.tag >= self.selectExamIndex-2)&&(tableView.tag <= self.selectExamIndex+2))
    {
        ExamDetailModel *examModel = self.practiceList[tableView.tag];
        NSDictionary *attributedDict = [self.globalAttributeDictionary objectForKey:[NSNumber numberWithInteger:tableView.tag]];
        if(!attributedDict)
        {
            return 0.1;
        }
        
        if(indexPath.section == 0)
        {
            CGSize titleSize = [LdGlobalObj sizeWithAttributedString:[attributedDict objectForKey:@"globalTitleAttributeString"] width:Screen_Width-kExamTitleCellWidthOffset];
            if(strIsNullOrEmpty(examModel.material))
            {
                self.titleHeight = titleSize.height+50;
                return titleSize.height+50;
            }
            else
            {
                CGSize materialSize = [LdGlobalObj sizeWithAttributedString:[attributedDict objectForKey:@"globalMaterialAttributeString"] width:Screen_Width-kExamTitleCellWidthOffset];
                
                if(indexPath.row == 0)
                {
                    self.materialHeight = materialSize.height+8;
                    return materialSize.height+8;
                }
                else
                {
                    self.titleHeight = titleSize.height+50;
                    return titleSize.height+50;
                }
            }
        }
        else
        {
            NSArray *globalOptionAttributeStringList = [attributedDict objectForKey:@"globalOptionAttributeStringList"];
            if(globalOptionAttributeStringList.count > indexPath.row)
            {
                CGSize size = [LdGlobalObj sizeWithAttributedString:globalOptionAttributeStringList[indexPath.row] width:Screen_Width-94];
                return size.height+16+10;
            }
            else
            {
                return 0.1;
            }
        }
    }
    else
    {
        return 0.1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(IOS9_OR_LATER)
    {
        if((tableView.tag >= self.selectExamIndex-2)&&(tableView.tag <= self.selectExamIndex+2))
        {
            return 2;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ExamDetailModel *examModel = self.practiceList[tableView.tag];
    if(section == 0)
    {
        if(strIsNullOrEmpty(examModel.material))
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else
    {
        return examModel.list_TitleList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamDetailModel *examModel = self.practiceList[tableView.tag];
    NSDictionary *attributedDict = [self.globalAttributeDictionary objectForKey:[NSNumber numberWithInteger:tableView.tag]];
    if(!attributedDict)
    {
        UITableViewCell *loc_cell = ldGetTableCellWithStyle(tableView, @"UITableViewCell", UITableViewCellStyleDefault);
        return loc_cell;
    }
    
    if(indexPath.section == 0)
    {
        if(!strIsNullOrEmpty(examModel.material)&&indexPath.row == 0)
        {
            ExamStemTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ExamStemTableViewCell, @"ExamStemTableViewCell");
            loc_cell.examStemLabel.attributedText = [attributedDict objectForKey:@"globalMaterialAttributeString"];
            if([LdGlobalObj sharedInstanse].isNightExamFlag)
            {
                loc_cell.examStemLabel.textColor = UIColorFromHex(0x666666);
                loc_cell.backgroundColor = [UIColor clearColor];
            }
            else
            {
                loc_cell.examStemLabel.textColor = kColorDarkText;
                loc_cell.backgroundColor = [UIColor whiteColor];
            }
            return loc_cell;
        }
        
        ExamTitleTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ExamTitleTableViewCell, @"ExamTitleTableViewCell");
//            loc_cell.examTitleLabel.attributedText = [attributedDict objectForKey:@"globalTitleAttributeString"];
        NSMutableAttributedString *tempstring = [[NSMutableAttributedString alloc] init];
        [tempstring setAttributedString:[attributedDict objectForKey:@"globalTitleAttributeString"]];
        [tempstring addAttribute:NSPaperSizeDocumentAttribute value:[NSValue valueWithCGSize:CGSizeMake(Screen_Width-15-33, self.titleHeight)] range:NSMakeRange(0, [tempstring length])];
        loc_cell.examTitleLabel.attributedText = tempstring;
        
        
        loc_cell.examTopTitleLabel.text = [NSString stringWithFormat:@"%@(%@)", examModel.content, examModel.QPoint];
        loc_cell.examTopTitleLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize];
        loc_cell.examIndexLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize];
        loc_cell.examIndexLabel.text = [NSString stringWithFormat:@"%d/%d", (int)tableView.tag+1, (int)self.practiceList.count];
        
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            loc_cell.examTitleLabel.textColor = UIColorFromHex(0x666666);
            loc_cell.examIndexLabel.textColor = UIColorFromHex(0x666666);
            loc_cell.examTopTitleLabel.textColor = UIColorFromHex(0x666666);
            loc_cell.backgroundColor = [UIColor clearColor];
            if ([examModel.QType isEqualToString:@"多选题"])
            {
                loc_cell.examTypeImageView.image = [UIImage imageNamed:@"night_shiti_tips_duoxuan"];
            }
            else
            {
                loc_cell.examTypeImageView.image = [UIImage imageNamed:@"night_shiti_tips_danxuan"];
            }
        }
        else
        {
            if ([examModel.QType isEqualToString:@"多选题"])
            {
                loc_cell.examTypeImageView.image = [UIImage imageNamed:@"shiti_tips_duoxuan"];
            }
            else
            {
                loc_cell.examTypeImageView.image = [UIImage imageNamed:@"shiti_tips_danxuan"];
            }
            loc_cell.examTitleLabel.textColor = kColorDarkText;
            loc_cell.examIndexLabel.textColor = kColorDarkText;
            loc_cell.examTopTitleLabel.textColor = kColorDarkText;
            loc_cell.backgroundColor = [UIColor whiteColor];
        }
        
        return loc_cell;
    }
    
    
    ExamOptionTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ExamOptionTableViewCell, @"ExamOptionTableViewCell");
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        loc_cell.examOptionButton.backgroundColor = [UIColor clearColor];
    }
    else
    {
        loc_cell.examOptionButton.backgroundColor = [UIColor whiteColor];
    }
    
    ExamDetailOptionModel *examOptionModel = examModel.list_TitleList[indexPath.row];
    [loc_cell selectedOptinalCell:NO];
    BOOL flag = NO;
    NSDictionary *resultDict = self.userResultDict[[NSNumber numberWithInteger:tableView.tag]];
    if(resultDict)
    {
        NSRange range = [resultDict[@"Answer"] rangeOfString:examOptionModel.single];
        if(range.length == examOptionModel.single.length)
        {
            [loc_cell selectedOptinalCell:YES];
            flag = YES;
        }
    }
    
    NSArray *globalOptionAttributeStringList = [attributedDict objectForKey:@"globalOptionAttributeStringList"];
    if(globalOptionAttributeStringList.count > indexPath.row)
    {
        NSMutableAttributedString *attributeString = globalOptionAttributeStringList[indexPath.row];
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x666666) range:NSMakeRange(0, [attributeString length])];
        }
        else
        {
            [attributeString addAttribute:NSForegroundColorAttributeName value:kColorDarkText range:NSMakeRange(0, [attributeString length])];
        }
        loc_cell.examOptionTitleLabel.text = examOptionModel.single;
        loc_cell.examOptionTitleLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize+3];
        loc_cell.examOptionDetailLabel.attributedText = attributeString;
    }
    
    return loc_cell;
}

- (void)jumpToBigImageBy:(NSMutableArray *)imageList;
{
    BigImageShowViewController *vc = [[BigImageShowViewController alloc] init];
    vc.view.backgroundColor = [UIColor blackColor];
    vc.imageUrlList = imageList;
    [self presentViewController:vc animated:YES completion:nil];
    [vc setupImagesPage:nil];
    self.isShowBigImage = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ExamDetailModel *examModel = self.practiceList[tableView.tag];
    if(indexPath.section == 0)
    {
        NSMutableArray *imageurlList = [NSMutableArray arrayWithCapacity:9];
        if(!strIsNullOrEmpty(examModel.material)&&indexPath.row == 0)
        {
            NSString *tempString = examModel.material;
            NSRange range1 = [tempString rangeOfString:@"src='"];
            NSRange range2 = [tempString rangeOfString:@"' />"];
            if(range1.length != 5)
            {
                return;
            }
            NSString *imageUrl1 = [tempString substringWithRange:NSMakeRange(range1.location+5, range2.location-range1.location-5)];
            tempString = [tempString substringFromIndex:range2.location+range2.length];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            [imageurlList addObject:imageUrl1];
            
            NSRange range3 = [tempString rangeOfString:@"src='"];
            NSRange range4 = [tempString rangeOfString:@"' />"];
            if(range3.length != 5)
            {
                [self jumpToBigImageBy:imageurlList];
                return;
            }
            NSString *imageUrl2 = [tempString substringWithRange:NSMakeRange(range3.location+5, range4.location-range3.location-5)];
            tempString = [tempString substringFromIndex:range4.location+range4.length];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            [imageurlList addObject:imageUrl2];
            
            NSRange range5 = [tempString rangeOfString:@"src='"];
            NSRange range6 = [tempString rangeOfString:@"' />"];
            if(range5.length != 5)
            {
                [self jumpToBigImageBy:imageurlList];
                return;
            }
            NSString *imageUrl3 = [tempString substringWithRange:NSMakeRange(range5.location+5, range6.location-range5.location-5)];
            tempString = [tempString substringFromIndex:range6.location+range6.length];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            [imageurlList addObject:imageUrl3];
            
            NSRange range7 = [tempString rangeOfString:@"src='"];
            NSRange range8 = [tempString rangeOfString:@"' />"];
            if(range7.length != 5)
            {
                [self jumpToBigImageBy:imageurlList];
                return;
            }
            NSString *imageUrl4 = [tempString substringWithRange:NSMakeRange(range7.location+5, range8.location-range7.location-5)];
            tempString = [tempString substringFromIndex:range8.location+range8.length];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            [imageurlList addObject:imageUrl4];
            
            NSRange range9 = [tempString rangeOfString:@"src='"];
            NSRange range10 = [tempString rangeOfString:@"' />"];
            if(range9.length != 5)
            {
                [self jumpToBigImageBy:imageurlList];
                return;
            }
            NSString *imageUrl5 = [tempString substringWithRange:NSMakeRange(range9.location+5, range10.location-range9.location-5)];
            tempString = [tempString substringFromIndex:range10.location+range10.length];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            [imageurlList addObject:imageUrl5];
            
            NSRange range11 = [tempString rangeOfString:@"src='"];
            NSRange range12 = [tempString rangeOfString:@"' />"];
            if(range11.length != 5)
            {
                [self jumpToBigImageBy:imageurlList];
                return;
            }
            NSString *imageUrl6 = [tempString substringWithRange:NSMakeRange(range11.location+5, range12.location-range11.location-5)];
            tempString = [tempString substringFromIndex:range12.location+range12.length];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            [imageurlList addObject:imageUrl6];
            
            NSRange range13 = [tempString rangeOfString:@"src='"];
            NSRange range14 = [tempString rangeOfString:@"' />"];
            if(range13.length != 5)
            {
                [self jumpToBigImageBy:imageurlList];
                return;
            }
            NSString *imageUrl7 = [tempString substringWithRange:NSMakeRange(range13.location+5, range14.location-range13.location-5)];
            tempString = [tempString substringFromIndex:range14.location+range14.length];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            [imageurlList addObject:imageUrl7];
            
            NSRange range15 = [tempString rangeOfString:@"src='"];
            NSRange range16 = [tempString rangeOfString:@"' />"];
            if(range15.length != 5)
            {
                [self jumpToBigImageBy:imageurlList];
                return;
            }
            NSString *imageUrl8 = [tempString substringWithRange:NSMakeRange(range15.location+5, range16.location-range15.location-5)];
            tempString = [tempString substringFromIndex:range16.location+range16.length];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
            imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
            [imageurlList addObject:imageUrl8];
            
            [self jumpToBigImageBy:imageurlList];
            return;
        }
        
        
        NSString *tempString = examModel.title;
        NSRange range1 = [tempString rangeOfString:@"src='"];
        NSRange range2 = [tempString rangeOfString:@"' />"];
        if(range1.length != 5)
        {
            return;
        }
        NSString *imageUrl1 = [tempString substringWithRange:NSMakeRange(range1.location+5, range2.location-range1.location-5)];
        imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
        imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
        imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
        imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
        imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
        imageUrl1 = [imageUrl1 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
        tempString = [tempString substringFromIndex:range2.location+range2.length];
        [imageurlList addObject:imageUrl1];
        
        NSRange range3 = [tempString rangeOfString:@"src='"];
        NSRange range4 = [tempString rangeOfString:@"' />"];
        if(range3.length != 5)
        {
            [self jumpToBigImageBy:imageurlList];
            return;
        }
        NSString *imageUrl2 = [tempString substringWithRange:NSMakeRange(range3.location+5, range4.location-range3.location-5)];
        imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
        imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
        imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
        imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
        imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
        imageUrl2 = [imageUrl2 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
        tempString = [tempString substringFromIndex:range4.location+range4.length];
        [imageurlList addObject:imageUrl2];
        
        NSRange range5 = [tempString rangeOfString:@"src='"];
        NSRange range6 = [tempString rangeOfString:@"' />"];
        if(range5.length != 5)
        {
            [self jumpToBigImageBy:imageurlList];
            return;
        }
        NSString *imageUrl3 = [tempString substringWithRange:NSMakeRange(range5.location+5, range6.location-range5.location-5)];
        imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
        imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
        imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
        imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
        imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
        imageUrl3 = [imageUrl3 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
        tempString = [tempString substringFromIndex:range6.location+range6.length];
        [imageurlList addObject:imageUrl3];
        
        NSRange range7 = [tempString rangeOfString:@"src='"];
        NSRange range8 = [tempString rangeOfString:@"' />"];
        if(range7.length != 5)
        {
            [self jumpToBigImageBy:imageurlList];
            return;
        }
        NSString *imageUrl4 = [tempString substringWithRange:NSMakeRange(range7.location+5, range8.location-range7.location-5)];
        tempString = [tempString substringFromIndex:range8.location+range8.length];
        imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
        imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
        imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
        imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
        imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
        imageUrl4 = [imageUrl4 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
        [imageurlList addObject:imageUrl4];
        
        NSRange range9 = [tempString rangeOfString:@"src='"];
        NSRange range10 = [tempString rangeOfString:@"' />"];
        if(range9.length != 5)
        {
            [self jumpToBigImageBy:imageurlList];
            return;
        }
        NSString *imageUrl5 = [tempString substringWithRange:NSMakeRange(range9.location+5, range10.location-range9.location-5)];
        tempString = [tempString substringFromIndex:range10.location+range10.length];
        imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
        imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
        imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
        imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
        imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
        imageUrl5 = [imageUrl5 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
        [imageurlList addObject:imageUrl5];
        
        NSRange range11 = [tempString rangeOfString:@"src='"];
        NSRange range12 = [tempString rangeOfString:@"' />"];
        if(range11.length != 5)
        {
            [self jumpToBigImageBy:imageurlList];
            return;
        }
        NSString *imageUrl6 = [tempString substringWithRange:NSMakeRange(range11.location+5, range12.location-range11.location-5)];
        tempString = [tempString substringFromIndex:range12.location+range12.length];
        imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
        imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
        imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
        imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
        imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
        imageUrl6 = [imageUrl6 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
        [imageurlList addObject:imageUrl6];
        
        NSRange range13 = [tempString rangeOfString:@"src='"];
        NSRange range14 = [tempString rangeOfString:@"' />"];
        if(range13.length != 5)
        {
            [self jumpToBigImageBy:imageurlList];
            return;
        }
        NSString *imageUrl7 = [tempString substringWithRange:NSMakeRange(range13.location+5, range14.location-range13.location-5)];
        tempString = [tempString substringFromIndex:range14.location+range14.length];
        imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
        imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
        imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
        imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
        imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
        imageUrl7 = [imageUrl7 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
        [imageurlList addObject:imageUrl7];
        
        NSRange range15 = [tempString rangeOfString:@"src='"];
        NSRange range16 = [tempString rangeOfString:@"' />"];
        if(range15.length != 5)
        {
            [self jumpToBigImageBy:imageurlList];
            return;
        }
        NSString *imageUrl8 = [tempString substringWithRange:NSMakeRange(range15.location+5, range16.location-range15.location-5)];
        tempString = [tempString substringFromIndex:range16.location+range16.length];
        imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='320" withString:@""];
        imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='272" withString:@""];
        imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='327" withString:@""];
        imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='366" withString:@""];
        imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' width='720" withString:@""];
        imageUrl8 = [imageUrl8 stringByReplacingOccurrencesOfString:@"' alt='" withString:@""];
        [imageurlList addObject:imageUrl8];
        
        [self jumpToBigImageBy:imageurlList];
    }
    
    ExamDetailOptionModel *examOptionModel = examModel.list_TitleList[indexPath.row];
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:self.userResultDict[[NSNumber numberWithInteger:self.selectExamIndex]]];
    
    if(examModel.solution.length > 1)//多选
    {
        if(resultDict)
        {
            NSString *result = resultDict[@"Answer"];
            NSRange range = [result rangeOfString:examOptionModel.single];
            if(range.length == examOptionModel.single.length)
            {
                result = [result stringByReplacingOccurrencesOfString:examOptionModel.single withString:@""];
            }
            else if(result)
            {
                result = [result stringByAppendingString:examOptionModel.single];
            }
            else
            {
                result = examOptionModel.single;
            }
            
            [resultDict setObject:result forKey:@"Answer"];
        }
        else
        {
            resultDict = [NSMutableDictionary dictionaryWithObject:examOptionModel.single forKey:@"Answer"];
        }
    }
    else//单选
    {
        if(resultDict)
        {
            [resultDict setObject:examOptionModel.single forKey:@"Answer"];
        }
        else
        {
            resultDict = [NSMutableDictionary dictionaryWithObject:examOptionModel.single forKey:@"Answer"];
        }
    }
    
    [resultDict setObject:examModel.ID forKey:@"ExamID"];
    [resultDict setObject:examModel.EID forKey:@"EID"];
    [resultDict setObject:[[LdGlobalObj sharedInstanse].formatter stringFromDate:[NSDate date]] forKey:@"ATime"];
    if([self.title containsString:@"智能"]||[self.title containsString:@"专项"])
    {
        [resultDict setObject:@"是" forKey:@"isFromIntelligent"];
    }
    else
    {
        [resultDict setObject:@"否" forKey:@"isFromIntelligent"];
    }
    
    if(!strIsNullOrEmpty(self.OID))
    {
        [resultDict setObject:self.OID forKey:@"OID"];
        [resultDict setObject:@"是" forKey:@"isFromOutLine"];
    }
    else
    {
        [resultDict setObject:@"" forKey:@"OID"];
        [resultDict setObject:@"否" forKey:@"isFromOutLine"];
    }
    
    NSString *TagFlag = resultDict[@"TagFlag"];
    if(strIsNullOrEmpty(TagFlag))
    {
        [resultDict setObject:@"否" forKey:@"TagFlag"];
    }
    
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
        [resultDict setObject:@"是" forKey:@"isOK"];
        [resultDict setObject:examModel.score forKey:@"GetScore"];
    }
    else
    {
        [resultDict setObject:@"否" forKey:@"isOK"];
        [resultDict setObject:@"0" forKey:@"GetScore"];
    }
    
    [self.userResultDict setObject:resultDict forKey:[NSNumber numberWithInteger:tableView.tag]];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:9];
    for(int index=0; index<examModel.list_TitleList.count; index++)
    {
        if((indexPath.section != 1)||(index > examModel.list_TitleList.count-1))
        {
            return;
        }
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
    }
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if(examModel.solution.length == 1)//单选
    {
        [self nextBtnAction];
    }
}

#pragma -mark Network
- (void)NetworkSubmitPutFavorite
{
    BOOL isIntelligent = NO;
    NSString *examType = @"试题";
    isIntelligent = [self.title containsString:@"智能"]||[self.title containsString:@"专项"];
    if(isIntelligent)
    {
        examType = @"专项智能";
    }
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    [LLRequestClass requestPutFavoriteByLinkID:examModel.ID FType:examType Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [SNToast toast:@"收藏成功"];
                self.favoriteExamList = [NSMutableArray arrayWithArray:contentArray];
                [self showIsCollectView];
                return;
            }
        }
        ZB_Toast(@"收藏失败");
    } failure:^(NSError *error) {
        ZB_Toast(@"收藏失败");
    }];
}

- (void)NetworkSubmitDeleteFavorite
{
    BOOL isIntelligent = NO;
    NSString *examType = @"试题";
    isIntelligent = [self.title containsString:@"智能"]||[self.title containsString:@"专项"];
    if(isIntelligent)
    {
        examType = @"专项智能";
    }
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    [LLRequestClass requestDeleteFavoriteByLinkID:examModel.ID FType:examType Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [SNToast toast:@"取消收藏成功"];
                self.favoriteExamList = [NSMutableArray arrayWithArray:contentArray];
                [self showIsCollectView];
                return;
            }
            else if([result isEqualToString:@"noresult"])
            {
                [SNToast toast:@"取消收藏成功"];
                [self.favoriteExamList removeAllObjects];
                [self showIsCollectView];
                return;
            }
        }
        ZB_Toast(@"取消收藏失败");
    } failure:^(NSError *error) {
        ZB_Toast(@"取消收藏失败");
    }];
}

- (void)NetworkGetFavoriteList
{
    [LLRequestClass requestGetFavoriteListBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.favoriteExamList = [NSMutableArray arrayWithArray:contentArray];
                [self showIsCollectView];
                return;
            }
        }
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

@end
