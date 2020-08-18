//
//  WrongQuestionsPracticeViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/1.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "WrongQuestionsSheetViewController.h"
#import "ExamOptionTableViewCell.h"
#import "ExaminationTitleModel.h"
#import "ErrorAnalysisViewController.h"
#import "ExamDetailModel.h"
#import "DailyPracticeViewController.h"
#import "PieCharVIew.h"
#import "PieCharModel.h"

@interface WrongQuestionsSheetViewController ()

@property (nonatomic, strong) IBOutlet UILabel *totalNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *correctNumLabel;
@property (nonatomic, strong) IBOutlet UILabel *wrongNumLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *answerSheetScrollView;
@property (nonatomic, strong) UIView *whiteScrollBackView;

@end

@implementation WrongQuestionsSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :kColorBlackText,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    
    self.title = self.purchedModel.Abstract;
    
    if(!self.practiceList)
    {
        self.practiceList = [NSMutableArray arrayWithCapacity:9];
        [self NetworkGetErrorSheet];
    }
    else
    {
        [self drawViews];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawViews
{
    self.answerSheetScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 190+70, Screen_Width, Screen_Height-44-(190+64+10))];
    if(IS_iPhoneX){
        self.answerSheetScrollView.frame = CGRectMake(0, 190+StatusBarAndNavigationBarHeight+10, Screen_Width, Screen_Height-44-(190+StatusBarAndNavigationBarHeight+TabbarSafeBottomMargin+10));
    }
    [self.view addSubview:self.answerSheetScrollView];
    self.view.backgroundColor=kColorBarGrayBackground;
    self.answerSheetScrollView.backgroundColor = kColorBarGrayBackground;
    int rightIndex = 0;
    int wrongIndex = 0;
    UIButton *lastButton = nil;
    for(int index=0; index<[self.practiceList count]; index++)
    {
        //创建一个视图
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        ExaminationTitleModel *model = self.practiceList[index];
        [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if([model.isOK isEqualToString:@"是"])
        {
            rightIndex++;
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_right"] forState:UIControlStateNormal];
        }
        else if([model.isOK isEqualToString:@"否"])
        {
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_wrong-1"] forState:UIControlStateNormal];
            wrongIndex++;
        }
        else
        {
            [functionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_none"] forState:UIControlStateNormal];
        }
        functionBtn.tag = index;
        
        functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [functionBtn setTitle:[NSString stringWithFormat:@"%d", index+1] forState:UIControlStateNormal];
        
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
    _whiteScrollBackView.backgroundColor = [UIColor whiteColor];
    [self.answerSheetScrollView insertSubview:_whiteScrollBackView atIndex:0];
    
    [self drawChartView:rightIndex wrongIndex:wrongIndex];
}

- (void)drawChartView:(int)rightIndex wrongIndex:(int)wrongIndex
{
    PieCharView *pieChar = [[PieCharView alloc] initWithFrame:CGRectMake(10, StatusBarAndNavigationBarHeight+5, kScreenWidth - 20, 190) withYoffset:78];
    pieChar.backgroundColor = kColorBarGrayBackground;
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

- (IBAction)ErrorAnalysisAction:(id)sender
{
    NSMutableArray *errorlist = [NSMutableArray arrayWithCapacity:9];
    for(ExaminationTitleModel *model in self.practiceList)
    {
        if([model.isOK isEqualToString:@"否"])
        {
            [errorlist addObject:model];
        }
    }
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
    for(ExaminationTitleModel *model in errorlist)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
        [list addObject:dict];
    }
    [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:NO];
}

- (IBAction)ErrorReTryExamAction:(id)sender
{
    NSMutableArray *errorlist = [NSMutableArray arrayWithCapacity:9];
    for(ExaminationTitleModel *model in self.practiceList)
    {
        if([model.isOK isEqualToString:@"否"])
        {
            [errorlist addObject:model];
        }
    }
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
    for(ExaminationTitleModel *model in errorlist)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
        [list addObject:dict];
    }
    [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:YES];
}

- (IBAction)allAnalysisAction:(id)sender
{
    if(self.practiceList.count == 0)
    {
        ZB_Toast(@"没有找到题目");
        return;
    }
    
//    if(self.practiceList.count > 120)
//    {
//        ZB_Toast(@"题目太多，建议您分析错题");
//        return;
//    }
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
    for(ExaminationTitleModel *model in self.practiceList)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
        [list addObject:dict];
    }
    [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] isRetry:NO];
}

#pragma -mark Network
- (void)NetworkGetErrorSheet
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetExamTitleByEID:self.purchedModel.LinkID Success:^(id jsonData) {
        [SVProgressHUD dismiss];
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.practiceList removeAllObjects];
                for(NSDictionary *dict in contentArray)
                {
                    ExaminationTitleModel *model = [ExaminationTitleModel model];
                    [model setDataWithDic:dict];
                    [self.practiceList addObject:model];
                }

                [self drawViews];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}

/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList isRetry:(BOOL)isRetry
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetExamDetailsByTitleList:titleList Success:^(id jsonData) {
        NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentDict);
        if([contentDict isKindOfClass:[NSArray class]])
        {
            [SVProgressHUD dismiss];
            ZB_Toast(@"没有找到试题");
            return;
        }
        
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
                    [self.navigationController pushViewController:vc animated:YES];
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
