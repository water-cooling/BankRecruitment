//
//  AnswerSheetViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/31.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerSheetViewController : UIViewController
@property (nonatomic, strong) NSMutableDictionary *userResultDict;
@property (nonatomic, strong) NSMutableArray *practiceList;
@property (nonatomic, copy) NSString *DailyPracticeTitle;
@property (nonatomic, copy) NSString *OID;
@property (nonatomic, copy) NSString *isMockExamType;

- (IBAction)submitAction:(id)sender fromPractice:(BOOL)fromPractice;
@end
