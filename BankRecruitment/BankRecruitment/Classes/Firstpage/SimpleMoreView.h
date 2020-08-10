//
//  SimpleMoreView.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/11.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisMoreView.h"

@interface SimpleMoreView : UIView
@property (nonatomic, strong) IBOutlet UISegmentedControl *moreSegmentCtl;
@property (nonatomic, copy) MoreSegmentCtlChangeBlock moreSegmentCtlChangeBlock;
@end
