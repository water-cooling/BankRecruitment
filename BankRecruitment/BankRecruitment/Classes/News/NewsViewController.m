//
//  NewsViewController.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/27.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIProgressView* progressView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *backView;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName :[UIColor whiteColor] ,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    self.navigationController.navigationBar.barTintColor = kColorNavigationBar;
//    self.title = @"最新招聘";
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [self.backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    UIButton *backWebViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backWebViewButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backWebViewButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backWebViewButton addTarget:self action:@selector(backWebButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backWebViewButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(40.0f, 0.0f, 25.0f, 25.0f);
    [closeButton setImage:[UIImage imageNamed:@"caogao_icon_cancle"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    [self.backView addSubview:backWebViewButton];
    [self.backView addSubview:closeButton];
    
    
    
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
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
    
    
    if([self.webView canGoBack])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backView];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)cb_clearProgress
{
    [_progressView removeFromSuperview];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backWebButtonPressed
{
    [self.webView goBack];
}

- (void)closeButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
