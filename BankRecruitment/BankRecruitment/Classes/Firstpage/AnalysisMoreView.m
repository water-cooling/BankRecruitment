//
//  AnalysisMoreView.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "AnalysisMoreView.h"

@implementation AnalysisMoreView

- (IBAction)moreSegmentCtlAction:(id)sender
{
    if(self.moreSegmentCtlChangeBlock)
    {
        self.moreSegmentCtlChangeBlock((self.moreSegmentCtl.selectedSegmentIndex == 0) ? YES : NO);
    }
}

- (IBAction)fontBtn:(UIButton *)btn
{
    if(self.moreFontBtnBlock)
    {
        self.moreFontBtnBlock(btn.tag);
    }
}

- (IBAction)shareBtn:(UIButton *)btn
{
    if(self.moreShareBtnBlock)
    {
        self.moreShareBtnBlock();
    }
}

- (IBAction)reportErrorBtn:(UIButton *)btn
{
    if(self.moreReportErrorBtnBlock)
    {
        self.moreReportErrorBtnBlock();
    }
}

@end
