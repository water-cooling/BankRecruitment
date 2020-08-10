//
//  ReportErrorViewController.h
//  BankRecruitment
//
//  Created by 夏建清 on 2017/6/23.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamDetailModel.h"

@interface ReportErrorViewController : UIViewController
@property (nonatomic, strong) ExamDetailModel *examModel;
@property (nonatomic, assign) BOOL isFromIntelligent;
@end
