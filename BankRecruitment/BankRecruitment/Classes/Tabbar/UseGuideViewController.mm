//
//  UseGuideViewController.m
//  Ganggangda
//
//  Created by xiajianqing on 15/8/17.
//  Copyright (c) 2015年 Longlian. All rights reserved.
//
#import "UseGuideViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"

@implementation UseGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isLogined = NO;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LaunchImage"];
    [self.view addSubview:backImageView];
    
    [self requestAllAdv];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginDict = [defaults objectForKey:@"userLoginDict"];
    if(loginDict)
    {
        [self loginActionByName:loginDict[@"userLoginname"] password:loginDict[@"userPassword"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  scrollView
 */
-(void)initWithGuideView
{
    self.guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    
    self.guideScrollView.showsHorizontalScrollIndicator = NO;
    self.guideScrollView.showsVerticalScrollIndicator = NO;
    self.guideScrollView.backgroundColor=[UIColor clearColor];
    self.guideScrollView.delegate=self;
    self.guideScrollView.pagingEnabled = YES;
    self.guideScrollView.scrollEnabled = YES;
    self.guideScrollView.directionalLockEnabled = YES;
    
    for(int i=0;i<[self.listArray count];i++)
    {
        self.guideView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i,0, self.view.frame.size.width, self.view.frame.size.height)];
        self.guideView.contentMode = UIViewContentModeScaleToFill;
        self.guideView.tag = i+1;
        
        NSDictionary *imgDict = [self.listArray objectAtIndex:i];
        NSString *pic_url = [NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp,[imgDict objectForKey:@"pic_url"]];
        [self.guideView sd_setImageWithURL:[NSURL URLWithString:pic_url] placeholderImage:kDefaultSquareImage completed:nil];
        self.guideView.userInteractionEnabled=YES;
        [self.guideScrollView addSubview:self.guideView];
        self.guideScrollView.contentSize = CGSizeMake(self.view.frame.size.width*(i+1), Screen_Height);
        if (self.guideView.tag == [self.listArray count])
        {
            UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDown)];
            [self.guideView addGestureRecognizer:tapGR];
        }
        
        UIButton *skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 100, 30, 80, 80)];
        [skipBtn setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
        [skipBtn addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchUpInside];
        [self.guideView addSubview:skipBtn];
    }
    
    [self.view addSubview:self.guideScrollView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(scrollTimerAction) userInfo:nil repeats:YES];
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.5];
}

- (void)scrollTimerAction
{
    if(self.guideScrollView.contentOffset.x<Screen_Width*(self.listArray.count-1))
    {
        CGRect rect = CGRectMake(self.guideScrollView.contentOffset.x+Screen_Width, 0, Screen_Width, Screen_Height);
        //scrollView可视区域
        [self.guideScrollView scrollRectToVisible:rect animated:YES];
    }
    else if(self.guideScrollView.contentOffset.x == Screen_Width*(self.listArray.count-1))
    {
        [self touchDown];
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 *  pageControl
 *
 *  @param scrollView scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.guideScrollView.contentOffset.x>(Screen_Width*(self.listArray.count-1) + 60))
    {
        [self touchDown];
    }
}

/**
 *  手势方法
 */
-(void)touchDown
{
    [self.timer invalidate];
    self.timer = nil;
    
    if(self.isLogined)
    {
        TabbarViewController *homePageVC = [[TabbarViewController alloc] init];
        [LdGlobalObj sharedInstanse].homePageVC = homePageVC;
        appDelegate.window.rootViewController = homePageVC;
        [appDelegate.window makeKeyAndVisible];
        
        [self NetworkPutMsgToken];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(removeGuideView)])
        {
            [self.delegate removeGuideView];
        }
    }
}

#pragma mark netword
//查询所有的广告
- (void)requestAllAdv
{
    [LLRequestClass requestBootScrollPicsBysuccess:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSDictionary *contentDict = contentArray.firstObject;
                NSString *result = [contentDict objectForKey:@"result"];
                if([result isEqualToString:@"success"])
                {
                    self.listArray = [NSMutableArray arrayWithCapacity:9];
                    for(NSDictionary *tmpDict in contentArray)
                    {
                        if(!strIsNullOrEmpty(tmpDict[@"pic_url"]))
                        {
                            [self.listArray addObject:tmpDict];
                        }
                    }
                    [self initWithGuideView];
                    return;
                }
            }
        }
        
        [self touchDown];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
//        ZB_Toast(@"网络不通畅，请您检查您的手机网络连接");
        [self touchDown];
    }];
}

- (IBAction)loginActionByName:(NSString *)name password:(NSString *)password
{
    if(strIsNullOrEmpty(name) || strIsNullOrEmpty(password))
    {
        return;
    }
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:name forKey:@"mobile"];
     [dict setValue:password forKey:@"password"];
    
    [LLRequestClass requestLoginByPhone:name Password:password success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [LdGlobalObj sharedInstanse].user_id = contentDict[@"uid"];
                [LdGlobalObj sharedInstanse].user_mobile = contentDict[@"mobile"];
                [LdGlobalObj sharedInstanse].user_name = contentDict[@"pet"];
                [LdGlobalObj sharedInstanse].tech_id = contentDict[@"tech"];
                [LdGlobalObj sharedInstanse].islive = [contentDict[@"islive"] isEqualToString:@"是"] ? YES : NO ;
                [LdGlobalObj sharedInstanse].istecher = [contentDict[@"istecher"] isEqualToString:@"是"] ? YES : NO ;
                [LdGlobalObj sharedInstanse].user_acc = contentDict[@"acc"];
                [LdGlobalObj sharedInstanse].user_LastSign = contentDict[@"LastSign"];
                [LdGlobalObj sharedInstanse].user_SignDays = contentDict[@"SignDays"];
                self.isLogined = YES;
                [self synchronizeLoginName:name password:password];
                return ;
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)synchronizeLoginName:(NSString *)name password:(NSString *)password{
    NSString * sign = [[NSString stringWithFormat:@"__ACBadf%@",name] stringByAppendingString:password];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:name forKey:@"mobile"];
     [dict setValue:password forKey:@"password"];
    [dict setValue:[sign smallMD5] forKey:@"clientSign"];
    [NewRequestClass requestLogin:dict success:^(id jsonData) {
        [LdGlobalObj sharedInstanse].sessionKey = jsonData[@"data"][@"response"][@"sessionKey"];
    } failure:^(NSError *error) {
        
    }];
}
- (void)NetworkPutMsgToken
{
    [LLRequestClass requestdoPutMsgTokenBytoken:[LdGlobalObj sharedInstanse].deviceToken Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                NSLog(@"deviceToken Update success");
            }
        }
    } failure:^(NSError *error) {
        ZB_Toast(@"注册Token失败");
    }];
}

@end
