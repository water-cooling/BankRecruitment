//
//  WrongQuestionsPracticeViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/1.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchedModel.h"

@interface WrongQuestionsSheetViewController : UIViewController
@property (nonatomic, strong) PurchedModel *purchedModel;
@property (nonatomic, strong) NSMutableArray *practiceList;
@end
