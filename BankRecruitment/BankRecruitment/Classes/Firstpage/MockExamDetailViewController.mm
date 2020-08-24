//
//  MockExamDetailViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MockExamDetailViewController.h"
#import "MockModel.h"
#import "LiveModel.h"
//#import "VideoCatalogModel.h"
#import "ExaminationTitleModel.h"
#import "ExamDetailModel.h"
#import "DailyPracticeViewController.h"
//#import "VideoSubViewController.h"
#import "LiveUserClassScheduleModel.h"
#import "DBY1VNLiveViewController.h"
#import "DBY1VNPlaybackViewController.h"
#import "ExamDetailViewController.h"
#import "ExaminationPaperModel.h"
//#import "VideoCatalogModel.h"
#import "CourseDetailViewController.h"
#import "TimetablesViewController.h"
#import "DataBaseManager.h"
#import "BBAlertView.h"
#import "MockReportViewController.h"

@interface MockExamDetailViewController ()
@property (nonatomic, strong) MockModel *mockModel;
@property (nonatomic, strong) IBOutlet UIView *mockTitleBackView;
//标题
@property (nonatomic, strong) IBOutlet UILabel *mockTitleLabel;
//报名人数
@property (nonatomic, strong) IBOutlet UILabel *signNumLabel;
//活动时间
@property (nonatomic, strong) IBOutlet UILabel *mockTimeLabel;
//点击报名
@property (nonatomic, strong) IBOutlet UIButton *mockExamBuyButton;
//试卷类型
@property (nonatomic, strong) IBOutlet UILabel *mockVideoLabel;
//报名按钮
@property (nonatomic, strong) IBOutlet UIButton *reportButton;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end

@implementation MockExamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self NetworkGetAllMockList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"模考大赛";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
   
    self.mockExamBuyButton.layer.cornerRadius = 20;
    self.mockExamBuyButton.layer.masksToBounds = YES;
    self.reportButton.layer.cornerRadius = 12.5;
    self.reportButton.layer.masksToBounds = YES;
    [self.reportButton addTarget:self action:@selector(signMock:) forControlEvents:UIControlEventTouchUpInside];
   
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshViewByData{
    NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有%@人报名", self.mockModel.iCount]];
    [titleAttributeString addAttribute:NSForegroundColorAttributeName value:KColorBlueText range:NSMakeRange(2, [self.mockModel.iCount length])];
    self.signNumLabel.attributedText = titleAttributeString;

    self.mockTitleLabel.text = self.mockModel.Name;
    NSMutableAttributedString *timeAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"活动时间：%@-%@", self.mockModel.BegDate, self.mockModel.EndDate]];
     [timeAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#999999"] range:NSMakeRange(0, 4)];
    self.mockTimeLabel.attributedText = timeAttributeString;
    NSMutableAttributedString *testAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"试卷：%@", self.mockModel.ExName]];
    [testAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#999999"] range:NSMakeRange(0, 2)];
    self.mockVideoLabel.attributedText = testAttributeString;
    if([self.mockModel.SjIsGet isEqualToString:@"是"])
    {
        [self.mockExamBuyButton setTitle:@"开始考试" forState:UIControlStateNormal];
    }
    
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString* BegDateString = [self.mockModel.BegDate stringByAppendingString:@" 00:00"];
    NSString* ExBegDateString = [self.mockModel.ExBegDate stringByAppendingString:@" 00:00"];
    NSString* ExEndDateString = [self.mockModel.ExEndDate stringByAppendingString:@" 23:59"];
    NSDate *BegDate = [dateFmt dateFromString:BegDateString];
    NSDate *ExBegDate = [dateFmt dateFromString:ExBegDateString];
    NSDate *ExEndDate = [dateFmt dateFromString:ExEndDateString];
    NSDate *currentDate = [NSDate date];
    //模考报名 按钮显示规则： 模考 活动 开始时间 - 试卷 结束时间 之间 显示报名按钮，当试卷结束时间过后，报名按钮消失
    //开始考试  按钮 显示规则：试卷开始时间-试卷结束时间 之间  显示开始考试 ，点击按钮 开始考试
    if([currentDate laterDate:ExEndDate]==currentDate)
    {
        self.mockExamBuyButton.hidden = YES;
    }
    else
    {
        if([self.mockExamBuyButton.currentTitle isEqualToString:@"开始考试"] && [currentDate earlierDate:ExBegDate]==currentDate)
        {
            self.mockExamBuyButton.hidden = YES;
        }
    }
    if([self.mockModel.IsGet isEqualToString:@"是"]){
        [self.reportButton setTitle:@"报名成功" forState:UIControlStateNormal];
    }
    
    NSString *html = [NSString stringWithFormat:@"<html> \n"
                      "<head> \n"
                      "<style type=\"text/css\"> \n"
                      "body {font-size:15px;}\n"
                      "</style> \n"
                      "</head> \n"
                      "<body>"
                      "<script type='text/javascript'>"
                      "window.onload = function(){\n"
                      "var $img = document.getElementsByTagName('img');\n"
                      "for(var p in  $img){\n"
                      " $img[p].style.width = '100%%';\n"
                      "$img[p].style.height ='auto'\n"
                      "}\n"
                      "}"
                      "</script>%@"
                      "</body>"
                      "</html>",self.mockModel.AllScreen];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)examReportSuccess
{
    //查看模考报告起作用时间为考试结束后的第二天开始，之后一直能看
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *isBOOl = [defaults objectForKey:[NSString stringWithFormat:@"mockExam_%@", self.mockModel.ExaminID]];
    if(isBOOl)
    {
        NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString* ExEndDateString = [self.mockModel.ExEndDate stringByAppendingString:@" 23:59"];
        NSDate *ExEndDate = [dateFmt dateFromString:ExEndDateString];
        NSDate *currentDate = [NSDate date];
        if([currentDate laterDate:ExEndDate] == currentDate)
        {
            self.reportButton.hidden = YES;
        }
    }
}

- (void)reportButtonAction
{
    MockReportViewController *vc = [[MockReportViewController alloc] init];
    vc.mockModel = self.mockModel;
    [self.navigationController pushViewController:vc animated:YES];
    return;
}

- (IBAction)buyExam:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"开始考试"])
    {
        if([[DataBaseManager sharedManager] getExamOperationListByEID:self.mockModel.ExaminID isFromIntelligent:@"否"])
        {
            NSArray *examList = [[DataBaseManager sharedManager] getExamDetailListByEID:self.mockModel.ExaminID isFromIntelligent:@"否"];
            if(examList.count > 0)
            {
                DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.title = self.mockModel.Name;
                vc.isSaveUserOperation = YES;
                vc.isMockExamType = @"模考试卷";
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self NetworkGetExamTitlesByEID:self.mockModel.ExaminID ExamTitle:self.mockModel.Name];
            }
        }
        else
        {
            [self NetworkGetExamTitlesByEID:self.mockModel.ExaminID ExamTitle:self.mockModel.Name];
        }
        
    }
    else
    {
        [self getModelDetailByType:@"关联试卷" LindID:self.mockModel.ExaminID];
    }
}


- (void)signMock:(UIButton *)sender
{
    if([self.reportButton.titleLabel.text isEqualToString:@"开始考试"])
    {
        if([[DataBaseManager sharedManager] getExamOperationListByEID:self.mockModel.ExaminID isFromIntelligent:@"否"])
        {
            NSArray *examList = [[DataBaseManager sharedManager] getExamDetailListByEID:self.mockModel.ExaminID isFromIntelligent:@"否"];
            if(examList.count > 0)
            {
                DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.title = self.mockModel.Name;
                vc.isSaveUserOperation = YES;
                vc.isMockExamType = @"模考试卷";
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self NetworkGetExamTitlesByEID:self.mockModel.ExaminID ExamTitle:self.mockModel.Name];
            }
        }
        else
        {
            [self NetworkGetExamTitlesByEID:self.mockModel.ExaminID ExamTitle:self.mockModel.Name];
        }
    }
    else
    {
        [self NetworkSignMockExam];
    }
}

#pragma -mark Network
- (void)NetworkGetAllMockList
{
    [LLRequestClass requestdoGetAllMockBySuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                for(NSDictionary *dict in contentArray)
                {
                    MockModel *model = [MockModel model];
                    [model setDataWithDic:dict];
                    if([model.ID isEqualToString:self.mockModelID])
                    {
                        self.mockModel = [MockModel model];
                        [self.mockModel setDataWithDic:dict];
                        
                        [self refreshViewByData];
                        [self examReportSuccess];
                        return;
                    }
                }
                
                return;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)NetworkSignMockExam
{
    //dict[@"MockID"], dict[@"Province"], dict[@"City"], dict[@"Bank"], dict[@"subBank"], dict[@"job"]
    NSDictionary *dict = @{@"MockID":self.mockModel.ID, @"Province":@"", @"City":@"", @"Bank":@"", @"subBank":@"", @"job":@""};
    [LLRequestClass requestdoPutMockSignByDict:dict Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.reportButton setTitle:@"报名成功" forState:UIControlStateNormal];
                [self.reportButton setBackgroundColor:kColorBarGrayBackground];
                [self.reportButton setTitleColor:UIColorFromHex(0xF0765B) forState:UIControlStateNormal];
                self.reportButton.userInteractionEnabled = NO;
                NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有%@人报名", self.mockModel.iCount]];
                 [titleAttributeString addAttribute:NSForegroundColorAttributeName value:KColorBlueText range:NSMakeRange(2, [self.mockModel.iCount length])];
                 self.signNumLabel.attributedText = titleAttributeString;
                return;
            }
        }
        
        ZB_Toast(@"报名失败");
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        ZB_Toast(@"报名失败");
    }];
}

/**
 根据试卷ID获取试题的标题列表
 
 @param EID 试卷ID
 */
- (void)NetworkGetExamTitlesByEID:(NSString *)EID ExamTitle:(NSString *)title
{
    [SVProgressHUD showWithStatus:@"正在准备试题" maskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestGetExamTitleByEID:EID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSMutableArray *titleList = [NSMutableArray arrayWithCapacity:9];
                for(NSDictionary *dict in contentArray)
                {
                    ExaminationTitleModel *model = [ExaminationTitleModel model];
                    [model setDataWithDic:dict];
                    [titleList addObject:model];
                }
                
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:9];
                for(ExaminationTitleModel *model in titleList)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:model.ID forKey:@"ID"];
                    [list addObject:dict];
                }
                [self NetworkGetExamDetailListByTitleList:[NSArray arrayWithArray:list] ExamTitle:title];
                return;
            }
        }
        [SVProgressHUD dismiss];
        ZB_Toast(@"没有找到试卷");
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
}

/**
 根据试题ID获取试题列表
 
 @param titleList 试题标题ID
 */
- (void)NetworkGetExamDetailListByTitleList:(NSArray *)titleList ExamTitle:(NSString *)title
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
                DailyPracticeViewController *vc = [[DailyPracticeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.practiceList = [NSMutableArray arrayWithArray:examList];
                vc.title = title;
                vc.isSaveUserOperation = YES;
                vc.isMockExamType = @"模考试卷";
                [self.navigationController pushViewController:vc animated:YES];
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
        NSLog(@"%@", error);
    }];
}

- (void)getModelDetailByType:(NSString *)type LindID:(NSString *)linkId
{
    [LLRequestClass requestdoGetAdvDetailBytitle:type path:linkId Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                if([type isEqualToString:@"关联课程"])
                {
                    LiveModel *model = [LiveModel model];
                    [model setDataWithDic:contentDict];
                    CourseDetailViewController *vc = [[CourseDetailViewController alloc] init];
                    vc.liveModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if([type isEqualToString:@"关联试卷"])
                {
                    ExaminationPaperModel *model = [ExaminationPaperModel model];
                    [model setDataWithDic:contentDict];
                    model.TypeInfo = @"模考试卷";
                    ExamDetailViewController *vc = [[ExamDetailViewController alloc] init];
                    vc.title = self.title;
                    vc.paperModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if ([type isEqualToString:@"关联视频"])
                {
//                    VideoCatalogModel *model = [VideoCatalogModel model];
//                    [model setDataWithDic:contentDict];
//                    [[LdGlobalObj sharedInstanse] payActionByType:@"视频" payID:model.cID];
//                    [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
//                        [self NetworkGetAllMockList];
//                    };
                    
//                    
//                    BuyVideoViewController *vc = [[BuyVideoViewController alloc] init];
//                    vc.videoCatalogModel =  model;
//                    [self.navigationController pushViewController:vc animated:YES];
                }
      }
            else
            {
                ZB_Toast(@"查看失败");
            }
        }
        else
        {
            ZB_Toast(@"查看失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        ZB_Toast(@"查看失败");
    }];
}

@end
