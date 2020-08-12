//
//  InformationDetailViewController.m
//  Recruitment
//
//  Created by 夏建清 on 2018/6/9.
//  Copyright © 2018年 LongLian. All rights reserved.
//

#import "InformationDetailViewController.h"

@interface InformationDetailViewController ()
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [shareButton setImage:[UIImage imageNamed:@"shiti_icon_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    self.title = self.model.Name;
    
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
                      "</html>",self.model.Info];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction:(id)sender
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareToPlatformType:platformType];
    }];
}

- (void)shareToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.Name descr:@"考银行就用银行易考！" thumImage:[UIImage imageNamed:@"shareIcon.png"]];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://yk.yinhangzhaopin.com/bshWeb/zixun/zixunDetail.jsp?ID=%@", self.model.ID];
//    shareObject.webpageUrl = @"http://yk.yinhangzhaopin.com/bshApp/download/index.jsp";
    
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

@end
