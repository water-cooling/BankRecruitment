//
//  QAContactTableViewCell.m
//  Recruitment
//
//  Created by humengfan on 2020/10/18.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QAContactTableViewCell.h"

@implementation QAContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(AnswerListModel *)model{
    _model = model;
    self.answerNameLab.text = model.answerUserNickName;
    [self.answerImg sd_setImageWithURL:[NSURL URLWithString:model.answerUserAvatar] placeholderImage:[UIImage imageNamed:@"head"]];
    self.deleteBtn.hidden = !model.isCanDel;
    self.answerContentLab.text = model.answerContent;
    self.praiseBtn.selected = model.isPraised;
    self.praiseNumLab.text = [NSString stringWithFormat:@"%ld",(long)model.praiseNum];
    self.creatTimeLab.text = model.addTime;
}
- (IBAction)answerClick:(UIButton *)sender {
        if ([sender isEqual:self.deleteBtn]) {
            if (self.deleteBlock) {
                self.deleteBlock();
            }
        }else{
            if (self.praiseBlock) {
                self.praiseBlock(sender.selected);
            }
        }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
