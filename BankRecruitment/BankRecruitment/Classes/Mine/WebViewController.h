//
//  WebViewController.h
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *htmlString;
@end
