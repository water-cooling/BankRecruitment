//
//  TeacherIntroduceTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/29.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "TeacherIntroduceTableViewCell.h"

@implementation TeacherIntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headerImageView.layer.cornerRadius = 4;
    self.headerImageView.layer.masksToBounds = YES;
    
    self.teacherDetailWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.teacherDetailWebView.scrollView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    NSLog(@"height_str=%@",height_str);
    
    if((self.teacherIntroduceWebViewHeightRefreshBlock)&&(height_str.floatValue>50))
    {
        self.teacherIntroduceWebViewHeightRefreshBlock(height_str.floatValue + 10, self.index);
    }
}

@end
