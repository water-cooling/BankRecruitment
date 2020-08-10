//
//  ExamDetailViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/13.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExamDetailViewController.h"
#import "ExamDetailModel.h"
#import "ExaminationTitleModel.h"
#import "DailyPracticeViewController.h"
#import "BBAlertView.h"

@interface ExamDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) IBOutlet UILabel *examTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *examTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *examPriceLabel;
@property (nonatomic, strong) IBOutlet UIView *examBuyBackView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end

@implementation ExamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.webView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.webView.scalesPageToFit = YES;
    
    self.examTitleLabel.text = self.paperModel.Name;
    NSDateFormatter* dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    NSDate *BegDate = [dateFmt dateFromString:self.paperModel.BegDate];
    NSDate *EndDate = [dateFmt dateFromString:self.paperModel.EndDate];
    NSDateFormatter* dateFmt1 = [[NSDateFormatter alloc] init];
    dateFmt1.dateFormat = @"yyyy.MM.dd";
    self.examTimeLabel.text = [NSString stringWithFormat:@"课程安排：%@-%@",[dateFmt1 stringFromDate:BegDate], [dateFmt1 stringFromDate:EndDate]];
    self.examPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.paperModel.Price.floatValue];
    
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
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
                            "</html>",self.paperModel.AllScreen];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyAction:(id)sender
{
    if(self.paperModel.Price.floatValue == 0)
    {
        [self NetworkSendZeroPaySuccessByLinkID:self.paperModel.ID Abstract:self.paperModel.Name];
    }
    else
    {
        if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
        {
            NSString *PType = @"试卷";
            if([self.paperModel.TypeInfo isEqualToString:@"模考试卷"])
            {
                PType = @"模考试卷";
            }
            [[LdGlobalObj sharedInstanse] payActionByType:PType payID:self.paperModel.ID];
            [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
                [self paySuccessAction];
            };
        }
        else
        {
            BBAlertView *alertView = [[BBAlertView alloc] initWithTitle:@"提示" message:@"直接购买，会为当前设备购买试卷；您可以去我的页面先注册再购买" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"游客身份购买"];
            LL_WEAK_OBJC(self);
            [alertView setConfirmBlock:^{
                NSString *PType = @"试卷";
                if([self.paperModel.TypeInfo isEqualToString:@"模考试卷"])
                {
                    PType = @"模考试卷";
                }
                [[LdGlobalObj sharedInstanse] payActionByType:PType payID:weakself.paperModel.ID];
                [LdGlobalObj sharedInstanse].buyObjectSuccessBlock = ^(){
                    [weakself paySuccessAction];
                };
            }];
            [alertView show];
        }
        
//        BuyExaminationPaperViewController *vc = [[BuyExaminationPaperViewController alloc] init];
//        vc.paperModel = self.paperModel;
//        vc.buyExaminationPaperSuccessBlock = ^(){
//            [self paySuccessAction];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)paySuccessAction
{
    if([LdGlobalObj sharedInstanse].user_id.floatValue > 0)
    {
        ZB_Toast(@"购买成功");
    }
    else
    {
        ZB_Toast(@"购买成功，请到我的页面登录或注册，迁移权益");
    }
    
    self.examBuyBackView.hidden = YES;
    [self performSelector:@selector(getExamDetail) withObject:nil afterDelay:1];
}

- (void)getExamDetail
{
    [self NetworkGetExamTitlesByEID:self.paperModel.ID ExamTitle:self.title];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    2、都有效果
//    NSString *js=@"var script = document.createElement('script');"
//    "script.type = 'text/javascript';"
//    "script.text = \"function ResizeImages() { "
//    "var myimg,oldwidth;"
//    "var maxwidth = %f;"
//    "for(i=0;i <document.images.length;i++){"
//    "myimg = document.images[i];"
//    "if(myimg.width > maxwidth){"
//    "oldwidth = myimg.width;"
//    "myimg.width = %f;"
//    "}"
//    "}"
//    "}\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
//    [webView stringByEvaluatingJavaScriptFromString:js];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
}

#pragma -mark Network
/**
 提交支付信息  价格为零时，添加到已购买的数据库
 */
- (void)NetworkSendZeroPaySuccessByLinkID:(NSString *)LinkID Abstract:(NSString *)Abstract
{
    NSString *PType = @"试卷";
    if([self.paperModel.TypeInfo isEqualToString:@"模考试卷"])
    {
        PType = @"模考试卷";
    }
    [LLRequestClass requestSendZeroPaySuccessByLinkID:LinkID PType:PType Abstract:Abstract Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self paySuccessAction];
                return;
            }
        }
        
        ZB_Toast(@"购买失败");
    } failure:^(NSError *error) {
        ZB_Toast(@"失败");
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
        //ZB_Toast(@"失败");
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
                if([self.paperModel.TypeInfo isEqualToString:@"模考试卷"])
                {
                    vc.isMockExamType = @"模考试卷";
                }
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
        //ZB_Toast(@"失败");
    }];
}

@end
