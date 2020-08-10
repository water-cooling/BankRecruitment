//
//  ExaminationPaperViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ExaminationPaperType) {
    ExaminationPaperDailyPracticeType = 0,  //每日一练
    ExaminationPaperOldExamType,            //历年真题
    ExaminationPaperExclusivePaperType      //独家密卷
};

@interface ExaminationPaperViewController : UIViewController
@property (nonatomic, assign) ExaminationPaperType examinationPaperType;
@end
