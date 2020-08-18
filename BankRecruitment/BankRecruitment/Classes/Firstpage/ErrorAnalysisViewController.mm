//
//  ErrorAnalysisViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ErrorAnalysisViewController.h"
#import "ErrorAnalysisOptionTableViewCell.h"
#import "AnswerSheetViewController.h"
#import "WDDrawView.h"
#import "CourseCalendarViewController.h"
#import "AnalysisTableViewCell.h"
#import "AnalysisMoreView.h"
#import "ExamDetailModel.h"
#import "ExamDetailOptionModel.h"
#import "ErrorAnswerSheetViewController.h"
#import "NoteTableViewCell.h"
#import "NoteModel.h"
#import "NoteViewController.h"
#import "BBAlertView.h"
#import "NewExamTitleTableViewCell.h"
#import "ExamStemTableViewCell.h"
#import "ReportErrorViewController.h"
#import "BigImageShowViewController.h"

#define kMaxTableViewLimit 5

@interface ErrorAnalysisViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *examScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *examPageControl;
@property (strong, nonatomic) AnalysisMoreView *moreView;
@property (nonatomic, strong) IBOutlet UIButton *moreBtn;
@property (strong, nonatomic) IBOutlet UIView *functionBackView;
@property (strong, nonatomic) IBOutlet UILabel *analysisTypeLabel;
@property (strong, nonatomic) UIButton *quitMoreButton;
@property (nonatomic, strong) IBOutlet UIButton *answerSheetBtn;
@property (nonatomic, strong) IBOutlet UIButton *collectBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) BBAlertView *alertView;
@property (nonatomic, strong) IBOutlet UILabel *bottomTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *PreBtn;
@property (nonatomic, strong) IBOutlet UIButton *NextBtn;
@property (nonatomic, strong) IBOutlet UIView *bottomContentView;

@property (nonatomic, assign) NSInteger selectExamIndex;
@property (nonatomic, strong) NSMutableArray *tableViewList;
@property (nonatomic, strong) NoteModel *currentNoteModel;
@property (nonatomic, strong) NSMutableArray *favoriteExamList;

@property (nonatomic, strong) NSMutableDictionary *globalAttributeDictionary;

@property (nonatomic, assign) float materialHeight;
@property (nonatomic, assign) float titleHeight;

@property (nonatomic, assign) BOOL isShowBigImage;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *safeViewsScrollViewBottomConstraint;
@end

@implementation ErrorAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.selectExamIndex = 0;
    self.isShowBigImage = NO;
    self.tableViewList = [NSMutableArray arrayWithCapacity:9];
    self.favoriteExamList = [NSMutableArray arrayWithCapacity:9];
    self.globalAttributeDictionary = [NSMutableDictionary dictionaryWithCapacity:9];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScrollViewFromAnswerScrollViewIndex:) name:@"ErrorAnswerSheetTouchExamBtnNotification" object:nil];
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self modifyAllTitleImageWidth];
    
    [self NetworkGetNote];
    if((IOS9_OR_LATER)&&(!self.isShowBigImage))
    {
        [self refreshViewByDayNightType];
    }
    
    self.isShowBigImage = NO;
    
    self.title = self.DailyPracticeTitle;
    [self NetworkGetFavoriteList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ErrorAnswerSheetTouchExamBtnNotification" object:nil];
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

- (void)drawViews
{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [_backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    
    if(self.isFromFirstPageSearch){
        self.NextBtn.hidden = YES;
        self.PreBtn.hidden = YES;
//        self.scrollViewBottomConstraint = 0;
//        self.safeViewsScrollViewBottomConstraint = 0;
    }
    
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
            tableView.backgroundColor = [UIColor whiteColor];
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
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        
        self.functionBackView.backgroundColor = UIColorFromHex(0x213451);
        for(UIView *subView in self.examScrollView.subviews)
        {
            if([subView isKindOfClass:[UITableView class]])
            {
                subView.backgroundColor = UIColorFromHex(0x20282f);
            }
        }
        
        self.analysisTypeLabel.textColor = UIColorFromHex(0x7a8596);
        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        [self.answerSheetBtn setImage:[UIImage imageNamed:@"night_icon_datika"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"night_icon_collect"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"night_icon_share"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"night_icon_more"] forState:UIControlStateNormal];
        self.bottomContentView.backgroundColor = UIColorFromHex(0x29323a);
        [self.PreBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
        [self.NextBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
        self.bottomTitleLabel.textColor = UIColorFromHex(0x666666);
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        
        self.functionBackView.backgroundColor = UIColorFromHex(0x1e9aed);
        for(UIView *subView in self.examScrollView.subviews)
        {
            if([subView isKindOfClass:[UITableView class]])
            {
                subView.backgroundColor = kColorBarGrayBackground;
            }
        }
        
        self.analysisTypeLabel.textColor = [UIColor whiteColor];
        [self.backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
        [self.answerSheetBtn setImage:[UIImage imageNamed:@"shiti_icon_datika"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"shiti_icon_collect"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"shiti_icon_share"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"day_shiti_icon_more"] forState:UIControlStateNormal];
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
        
        self.view.backgroundColor = UIColorFromHex(0x20282f);
        self.functionBackView.backgroundColor = UIColorFromHex(0x213451);
        for(UIView *subView in self.examScrollView.subviews)
        {
            if([subView isKindOfClass:[UITableView class]])
            {
                subView.backgroundColor = UIColorFromHex(0x20282f);
            }
        }
        
        self.analysisTypeLabel.textColor = UIColorFromHex(0x7a8596);
        [self.backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        [self.answerSheetBtn setImage:[UIImage imageNamed:@"night_icon_datika"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"night_icon_collect"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"night_icon_share"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"night_icon_more"] forState:UIControlStateNormal];
        self.bottomContentView.backgroundColor = UIColorFromHex(0x29323a);
        [self.PreBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
        [self.NextBtn setTitleColor:UIColorFromHex(0x284a92) forState:UIControlStateNormal];
        self.bottomTitleLabel.textColor = UIColorFromHex(0x666666);
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];

        self.view.backgroundColor = [UIColor whiteColor];
        self.functionBackView.backgroundColor = UIColorFromHex(0x1e9aed);
        for(UIView *subView in self.examScrollView.subviews)
        {
            if([subView isKindOfClass:[UITableView class]])
            {
                subView.backgroundColor = kColorBarGrayBackground;
            }
        }
        
        self.analysisTypeLabel.textColor = [UIColor whiteColor];
        [self.backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
        [self.answerSheetBtn setImage:[UIImage imageNamed:@"shiti_icon_datika"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"shiti_icon_collect"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"shiti_icon_share"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"day_shiti_icon_more"] forState:UIControlStateNormal];
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
    
    self.bottomTitleLabel.text = [NSString stringWithFormat:@"%d/%d", (int)index+1, (int)self.practiceList.count];
    [self NetworkGetNote];
    //判断是否收藏
    [self showIsCollectView];
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
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        NSMutableDictionary *attributedDictionary = [NSMutableDictionary dictionaryWithCapacity:9];
        ExamDetailModel *examModel = self.practiceList[currentIndex1];
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
        NSString *title = [NSString stringWithFormat:@"%ld.    %@", (long)currentIndex1+1, examModel.title];
        if(self.isFromFirstPageSearch){
            title = examModel.title;
        }
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
        
        NSMutableAttributedString *analysisAttributeString = [[NSMutableAttributedString alloc] initWithData:[examModel.analysis dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                             options:options
                                                                                  documentAttributes:nil
                                                                                               error:nil];
        [analysisAttributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize] range:NSMakeRange(0, [analysisAttributeString length])];
        [analysisAttributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [analysisAttributeString length])];
        [attributedDictionary setObject:analysisAttributeString forKey:@"globalAnalysisAttributeString"];
        
        
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

- (void)showIsCollectView
{
    BOOL isIntelligent = NO;
    NSString *examType = @"试题";
    isIntelligent = [self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.examScrollView)
    {
        if(scrollView.contentOffset.x > scrollView.contentSize.width-Screen_Width+60)
        {
            if(!self.alertView)
            {
                self.alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"回到首页" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
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
        }
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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
        if(!self.alertView)
        {
            self.alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"回到首页" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
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

- (IBAction)moreButtonPressed
{
    if(self.moreView)
    {
        [self quitMoreButtonAction];
    }
    
    [self.moreView removeFromSuperview];
    self.moreView = nil;
    self.moreView = [[[NSBundle mainBundle] loadNibNamed:@"AnalysisMoreView" owner:nil options:nil] firstObject];
    self.moreView.frame = CGRectMake(Screen_Width-150, StatusBarAndNavigationBarHeight, 150, 158);
    self.moreView.moreSegmentCtl.selectedSegmentIndex = [LdGlobalObj sharedInstanse].isNightExamFlag ? 0 : 1;
    [self.view addSubview:self.moreView];
    
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

- (void)ReportErrorAction
{
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    ReportErrorViewController *vc = [[ReportErrorViewController alloc] init];
    vc.examModel = examModel;
    vc.isFromIntelligent = [self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)AnswerSheetAction:(id)sender
{
    ErrorAnswerSheetViewController *vc = [[ErrorAnswerSheetViewController alloc] init];
    vc.practiceList = [NSMutableArray arrayWithArray:self.practiceList];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)collectAction:(id)sender
{
    BOOL isCollect = NO;
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    BOOL isIntelligent = NO;
    NSString *examType = @"试题";
    isIntelligent = [self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"];
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

- (void)shareToPlatformType:(UMSocialPlatformType)platformType
{
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"银行易考" descr:des thumImage:[UIImage imageNamed:@"shareIcon.png"]];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://yk.yinhangzhaopin.com/bshWeb/exam/ViewTitle.jsp?ID=%@&FLAG=%d", examModel.ID, [self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"] ? 1 : 0];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
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
        //        [self alertWithError:error];
    }];
}

- (void)shareAction:(id)sender
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareToPlatformType:platformType];
    }];
    
}

- (void)modifyNoteButtonAction:(UIButton *)btn
{
    NoteViewController *vc = [[NoteViewController alloc] init];
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    vc.examModel = examModel;
    vc.NoteModel = self.currentNoteModel;
    [self.navigationController pushViewController:vc animated:YES];
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
    else if(indexPath.section == 1)
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
    else if (indexPath.section == 2)
    {
        CGSize size = [LdGlobalObj sizeWithAttributedString:[attributedDict objectForKey:@"globalAnalysisAttributeString"] width:Screen_Width-45];
        return size.height + 165;
    }
    else
    {
        NoteTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, NoteTableViewCell, @"NoteTableViewCell");
        return [loc_cell getHeightNoteTableCellByString:self.currentNoteModel.Note];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if((tableView.tag >= self.selectExamIndex-2)&&(tableView.tag <= self.selectExamIndex+2))
    {
        //先把智能的笔记功能去掉
        if([self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"])
        {
            return 3;
        }
        else
        {
            return 4;
        }
    }
    else
    {
        return 0;
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
    else if(section == 1)
    {
        return examModel.list_TitleList.count;
    }
    else
    {
        return 1;
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
        
        NewExamTitleTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, NewExamTitleTableViewCell, @"NewExamTitleTableViewCell");
        NSMutableAttributedString *tempstring = [[NSMutableAttributedString alloc] init];
        [tempstring setAttributedString:[attributedDict objectForKey:@"globalTitleAttributeString"]];
        [tempstring addAttribute:NSPaperSizeDocumentAttribute value:[NSValue valueWithCGSize:CGSizeMake(Screen_Width-15-33, self.titleHeight)] range:NSMakeRange(0, [tempstring length])];
        loc_cell.examTitleLabel.attributedText = tempstring;
//            loc_cell.examTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//            loc_cell.examTitleLabel.autoresizesSubviews = YES;
//            [loc_cell.examTitleLabel sizeToFit];
        loc_cell.examTopTitleLabel.text = [NSString stringWithFormat:@"%@(%@)", examModel.content, examModel.QPoint];
        loc_cell.examIndexLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize];
        loc_cell.examTopTitleLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize];
        loc_cell.numLab.text = [NSString stringWithFormat:@"%ld",self.selectExamIndex+1];
        loc_cell.examIndexLabel.text = [NSString stringWithFormat:@"%d/%d", (int)tableView.tag+1, (int)self.practiceList.count];
        
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            loc_cell.examTitleLabel.textColor = UIColorFromHex(0x666666);
            loc_cell.examIndexLabel.textColor = UIColorFromHex(0x666666);
            loc_cell.examTopTitleLabel.textColor = UIColorFromHex(0x666666);
            loc_cell.backgroundColor = [UIColor clearColor];
             loc_cell.typeLab.text  = examModel.QType;
           
        }
        else
        {
          loc_cell.typeLab.text  = examModel.QType;
            loc_cell.examTitleLabel.textColor = kColorDarkText;
            loc_cell.examIndexLabel.textColor = kColorDarkText;
            loc_cell.examTopTitleLabel.textColor = kColorDarkText;
            loc_cell.backgroundColor = [UIColor whiteColor];
        }
        
        return loc_cell;
    }
    else if(indexPath.section == 1)
    {
        ErrorAnalysisOptionTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, ErrorAnalysisOptionTableViewCell, @"ErrorAnalysisOptionTableViewCell");
        ExamDetailOptionModel *optionModel = examModel.list_TitleList[indexPath.row];
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            loc_cell.examOptionButton.backgroundColor = [UIColor clearColor];
            loc_cell.backgroundColor = [UIColor clearColor];
        }
        else
        {
            loc_cell.examOptionButton.backgroundColor = [UIColor whiteColor];
            loc_cell.backgroundColor = kColorBarGrayBackground;
        }
        
        NSArray *globalOptionAttributeStringList = [attributedDict objectForKey:@"globalOptionAttributeStringList"];
        if(globalOptionAttributeStringList.count > indexPath.row)
        {
            NSMutableAttributedString *attributeString = globalOptionAttributeStringList[indexPath.row];
            NSRange range = [examModel.answer rangeOfString:optionModel.single];
            NSRange range1 = [examModel.solution rangeOfString:optionModel.single];
            if(range1.length == optionModel.single.length)
            {
                [loc_cell setOptinalCellType:ErrorAnalysisOptionRight attributeString:attributeString];
            }
            else if(range.length == optionModel.single.length)
            {
                [loc_cell setOptinalCellType:ErrorAnalysisOptionWrong attributeString:attributeString];
            }
            else
            {
                [loc_cell setOptinalCellType:ErrorAnalysisOptionNomal attributeString:attributeString];
            }
            
            loc_cell.examOptionTitleLabel.text = optionModel.single;
            loc_cell.examOptionTitleLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize+3];
            loc_cell.examOptionDetailLabel.attributedText = attributeString;
        }
        
        return loc_cell;
    }
    else if (indexPath.section == 2)
    {
        AnalysisTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, AnalysisTableViewCell, @"AnalysisTableViewCell");
        int userTime = examModel.userTime.intValue;
        loc_cell.AnalysisAnswerLabel.text = [NSString stringWithFormat:@"正确答案是：%@      用时：%02d分%02d秒", examModel.solution, userTime/60, userTime%60];
        NSMutableAttributedString *attributeString = [attributedDict objectForKey:@"globalAnalysisAttributeString"];
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            loc_cell.AnalysisBackView.backgroundColor = [UIColor clearColor];
            loc_cell.backgroundColor = [UIColor clearColor];
            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x666666) range:NSMakeRange(0, [attributeString length])];
            loc_cell.AnalysisTitleLabel.textColor = UIColorFromHex(0x65707a);
            loc_cell.AnalysisAnswerLabel.textColor = UIColorFromHex(0x65707a);
        }
        else
        {
            loc_cell.AnalysisBackView.backgroundColor = [UIColor whiteColor];
            loc_cell.backgroundColor = kColorBarGrayBackground;
            [attributeString addAttribute:NSForegroundColorAttributeName value:kColorDarkText range:NSMakeRange(0, [attributeString length])];
            loc_cell.AnalysisTitleLabel.textColor = UIColorFromHex(0x8C9FB0);
            loc_cell.AnalysisAnswerLabel.textColor = UIColorFromHex(0x8C9FB0);
        }
        
        loc_cell.AnalysisLabel.attributedText = attributeString;
        loc_cell.numLabel1.text = examModel.totalCount;
        loc_cell.numLabel2.text = examModel.rightCount;
        loc_cell.numLabel3.text = examModel.errCount;
        loc_cell.numLabel4.text = examModel.badAnswer;
        return loc_cell;
    }
    else
    {
        NoteTableViewCell *loc_cell = GET_TABLE_CELL_FROM_NIB(tableView, NoteTableViewCell, @"NoteTableViewCell");
        [loc_cell.modifyNoteButton addTarget:self action:@selector(modifyNoteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        loc_cell.AnalysisLabel.text = self.currentNoteModel.Note;
        loc_cell.AnalysisLabel.font = [UIFont fontWithName:@"Microsoft YaHei UI" size:[LdGlobalObj sharedInstanse].examFontSize];
        
        if(strIsNullOrEmpty(self.currentNoteModel.Note))
        {
            [loc_cell.modifyNoteButton setTitle:@"添加笔记" forState:UIControlStateNormal];
        }
        else
        {
            [loc_cell.modifyNoteButton setTitle:@"编辑笔记" forState:UIControlStateNormal];
        }
        
        if([LdGlobalObj sharedInstanse].isNightExamFlag)
        {
            loc_cell.backgroundColor = [UIColor clearColor];
            loc_cell.AnalysisTitleLabel.textColor = UIColorFromHex(0x65707a);
        }
        else
        {
            loc_cell.backgroundColor = kColorBarGrayBackground;
            loc_cell.AnalysisTitleLabel.textColor = UIColorFromHex(0x8C9FB0);
        }
        return loc_cell;
    }
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
}

#pragma -mark Network
- (void)NetworkGetNote
{
    ExamDetailModel *examModel = self.practiceList[self.selectExamIndex];
    self.currentNoteModel = nil;
    
    [LLRequestClass requestGetNoteByID:examModel.ID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.lastObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.currentNoteModel = [NoteModel model];
                [self.currentNoteModel setDataWithDic:contentDict];
            }
        }
        
        for(UITableView *tableView in self.tableViewList)
        {
            if((tableView.tag == self.selectExamIndex)&&(tableView.numberOfSections == 4))
            {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                return;
            }
        }
    } failure:^(NSError *error) {
        //ZB_Toast(@"失败");
    }];
}

- (void)NetworkSubmitPutFavorite
{
    BOOL isIntelligent = NO;
    NSString *examType = @"试题";
    isIntelligent = [self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"];
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
    isIntelligent = [self.DailyPracticeTitle containsString:@"智能"]||[self.DailyPracticeTitle containsString:@"专项"];
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
