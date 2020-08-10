//
//  AnalysisMoreView.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MoreSegmentCtlChangeBlock)(BOOL isNight);
typedef void (^MoreFontBtnBlock)(int fontSize);
typedef void (^MoreShareBtnBlock)();
typedef void (^MoreReportErrorBtnBlock)();

@interface AnalysisMoreView : UIView

@property (nonatomic, strong) IBOutlet UISegmentedControl *moreSegmentCtl;
@property (nonatomic, copy) MoreSegmentCtlChangeBlock moreSegmentCtlChangeBlock;
@property (nonatomic, copy) MoreFontBtnBlock moreFontBtnBlock;
@property (nonatomic, copy) MoreShareBtnBlock moreShareBtnBlock;
@property (nonatomic, copy) MoreReportErrorBtnBlock moreReportErrorBtnBlock;

@end
