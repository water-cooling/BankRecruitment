//
//  QAContactTableViewCell.h
//  Recruitment
//
//  Created by humengfan on 2020/10/18.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerListModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^AnswerPraiseBlock)(BOOL isPraise);

@interface QAContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *answerImg;
@property (weak, nonatomic) IBOutlet UILabel *answerNameLab;
@property (weak, nonatomic) IBOutlet UILabel *answerContentLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLab;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLab;
@property (copy, nonatomic) AnswerPraiseBlock praiseBlock;
@property (copy, nonatomic) dispatch_block_t deleteBlock;
@property (nonatomic,strong)AnswerListModel * model;
@end

NS_ASSUME_NONNULL_END
