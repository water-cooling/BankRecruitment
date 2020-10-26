//
//  QATableViewCell.m
//  Recruitment
//
//  Created by yltx on 2020/10/12.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QATableViewCell.h"

@implementation QATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userSignLab.layer.cornerRadius = 12.5;
    self.userSignLab.layer.masksToBounds = YES;
    // Initialization code
}
-(void)setModel:(QuestionListModel *)model{
    _model = model;
    self.userNameLab.text = model.userNickName;
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.userAvatar] placeholderImage:[UIImage imageNamed:@"head"]];
    self.userSignLab.text = model.questionCatCodeName;
    self.questionContentLab.text = model.title;
    self.followNumLab.text = [NSString stringWithFormat:@"%ld",model.viewNum];
    self.contactNumLab.text = [NSString stringWithFormat:@"%ld",model.answerNum];
    self.questionTimeLab.text = model.addTime;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
