//
//  SimpleMoreView.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/11.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "SimpleMoreView.h"

@implementation SimpleMoreView

- (IBAction)moreSegmentCtlAction:(id)sender
{
    if(self.moreSegmentCtlChangeBlock)
    {
        self.moreSegmentCtlChangeBlock((self.moreSegmentCtl.selectedSegmentIndex == 0) ? YES : NO);
    }
}

@end
