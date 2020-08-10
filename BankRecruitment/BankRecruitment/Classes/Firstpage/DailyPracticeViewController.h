//
//  DailyPracticeViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/31.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyPracticeViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *practiceList;
@property (nonatomic, copy) NSString *OID;
@property (nonatomic, assign) BOOL isSaveUserOperation;
@property (nonatomic, copy) NSString *isMockExamType;

@end
