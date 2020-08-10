//
//  NoteViewController.h
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamDetailModel.h"
#import "NoteModel.h"

@interface NoteViewController : UIViewController

@property (nonatomic, strong) ExamDetailModel *examModel;
@property (nonatomic, strong) NoteModel *NoteModel;

@end
