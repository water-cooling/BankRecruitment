//
//  ExerciseReportViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/5.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseReportViewController : UIViewController
@property (nonatomic, strong) NSMutableDictionary *userResultDict;
@property (nonatomic, strong) NSMutableArray *practiceList;
@property (nonatomic, copy) NSString *DailyPracticeTitle;
@property (nonatomic, copy) NSString *isMockExamType;
@end
