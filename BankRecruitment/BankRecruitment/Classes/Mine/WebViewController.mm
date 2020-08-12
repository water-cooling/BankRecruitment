//
//  WebViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIProgressView* progressView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self drawViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!strIsNullOrEmpty(self.urlString))
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0]];
    }
    else if(!strIsNullOrEmpty(self.htmlString))
    {
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    }
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _progressView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, Screen_Width, 5);
    if (!IS_IOS7)
    {
        _progressView.transform = CGAffineTransformMakeScale(1.f, 2.5f);
        
    }
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = [UIColor colorWithHex:@"#34cdff"];
    _progressView.width = Screen_Width;
    _progressView.progress = 0.f;
    [self.view addSubview:_progressView];
}

- (void)drawViews
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progressView setProgress:.9f animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressView setProgress:1.0f animated:YES];
    [self performSelector:@selector(cb_clearProgress) withObject:nil afterDelay:0.8f];//延迟进度条的销毁
    
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"window.alert=null;"];
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)cb_clearProgress
{
    [_progressView removeFromSuperview];
}

@end
