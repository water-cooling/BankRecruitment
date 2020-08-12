//
//  DBY1VNPlaybackViewController.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/13.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBY1VNPlaybackViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import "DBYUIUtils.h"

#import <WebKit/WebKit.h>

@interface DBY1VNPlaybackViewController () <WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView*webview;
@end

@implementation DBY1VNPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    [configuration.userContentController addScriptMessageHandler:self name:@"dbyUIStatusForNative"];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    WKWebView*webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    
    
    
//    webView.navigationDelegate = self;
//    webView.UIDelegate = self;
    [self.view addSubview:webView];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:26/255.0 green:25/255.0 blue:31/255.0 alpha:1]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    self.navigationController.navigationBar.backIndicatorImage = [DBYUIUtils bundleImageWithImageName:@"Back Arrow"];
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [DBYUIUtils bundleImageWithImageName:@"Back Arrow"];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.title = @"回放";
    
    self.webview = webView;
    
    
    NSString*timeStamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
    //拼进教室链接
    NSString*enterRoomUrlStr = @"https://api.duobeiyun.com/api/v3/room/enter";
    NSString*sign = [self md5HexDigestWithString:[NSString stringWithFormat:@"nickname=%@&partner=%@&roomId=%@&timestamp=%@&uid=%@&userRole=%@%@",self.nickName,self.partnerID,self.roomID,timeStamp,self.uid,@"2",self.appkey]];
    NSString*url = [NSString stringWithFormat:@"%@?nickname=%@&partner=%@&roomId=%@&timestamp=%@&uid=%@&userRole=%@&sign=%@",enterRoomUrlStr,[self.nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.partnerID,self.roomID,timeStamp,self.uid,@"2",sign];
    
    
    if (self.enterURL) {
        url = self.enterURL;
    }
    
    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.webview removeFromSuperview];
    self.webview = nil;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webview.frame = self.view.bounds;
    
//    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    CGRect frame = self.view.frame;
    if (frame.size.height > frame.size.width) {
        [self rotateToPortrait];
    } else {
        [self rotateToLandScape];
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
    {
        //
        [self rotateToLandScape];
    }
    if (orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
        self.navigationController.navigationBarHidden = YES;
    {
        //
        [self rotateToLandScape];
        
    }
    if (orientation == UIInterfaceOrientationPortrait)
    {
        //
        
        
        [self rotateToPortrait];
        
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        
    {
        
        //
        
    }
    
}
//竖屏
-(void)rotateToPortrait
{
    self.navigationController.navigationBarHidden = NO;
    
    self.webview.frame = self.view.bounds;
}
//横屏
-(void)rotateToLandScape
{
    self.navigationController.navigationBarHidden = YES;
    self.webview.frame = self.view.bounds;
}

//md5
-(NSString *) md5HexDigestWithString:(NSString*)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
@end
