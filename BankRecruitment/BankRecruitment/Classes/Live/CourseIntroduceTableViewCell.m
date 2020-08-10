//
//  CourseIntroduceTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "CourseIntroduceTableViewCell.h"

@implementation CourseIntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    NSLog(@"height_str=%@",height_str);
    
    if((self.courseIntroduceWebViewHeightRefreshBlock)&&(height_str.floatValue>50))
    {
        self.courseIntroduceWebViewHeightRefreshBlock(height_str.floatValue + 40);
    }
}

@end
