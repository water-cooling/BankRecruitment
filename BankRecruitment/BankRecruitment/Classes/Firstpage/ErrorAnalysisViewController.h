//
//  ErrorAnalysisViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorAnalysisViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *practiceList;
@property (nonatomic, copy) NSString *DailyPracticeTitle;
@property (nonatomic, assign) BOOL isFromFirstPageSearch;
@end
