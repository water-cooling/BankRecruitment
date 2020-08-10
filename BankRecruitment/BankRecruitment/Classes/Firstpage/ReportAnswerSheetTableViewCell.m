//
//  ReportAnswerSheetTableViewCell.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/6.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ReportAnswerSheetTableViewCell.h"
#import "ExaminationTitleModel.h"

@implementation ReportAnswerSheetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSheet
{
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        self.answerTitleLabel.textColor = UIColorFromHex(0x666666);
        self.answerSheetScrollView.backgroundColor = UIColorFromHex(0x2b3f5d);
    }
    else
    {
        self.answerTitleLabel.textColor = UIColorFromHex(0x444444);
        self.answerSheetScrollView.backgroundColor = [UIColor whiteColor];
    }
    
    UIButton *lastButton = nil;
    for(int index=0; index<[self.answerList count]; index++)
    {
        //创建一个视图
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        ExaminationTitleModel *model = self.answerList[index];
        [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if([model.isOK isEqualToString:@"是"])
        {
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_right"] forState:UIControlStateNormal];
        }
        else if([model.isOK isEqualToString:@"否"])
        {
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_wrong-1"] forState:UIControlStateNormal];
        }
        else
        {
            [functionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [functionBtn setBackgroundImage:[UIImage imageNamed:@"datika_circle_none"] forState:UIControlStateNormal];
        }
        functionBtn.tag = index;
        
        functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [functionBtn setTitle:[NSString stringWithFormat:@"%d", index+1] forState:UIControlStateNormal];
        
        int hang = index/4;
        int lie = index%4;
        int firstkongxi = 30;
        int kongxi = (Screen_Width - 160 - firstkongxi*2)/3;
        
        functionBtn.frame = CGRectMake(firstkongxi+kongxi*(lie)+40*lie, 15*(hang+1)+50*hang, 40, 40);
        
        //把视图添加到当前的滚动视图中
        [self.answerSheetScrollView addSubview:functionBtn];
        lastButton = functionBtn;
    }
    [self.answerSheetScrollView setContentSize:CGSizeMake(100, lastButton.bottom+20)];
    self.answerSheetScrollView.height = lastButton.bottom+20;
//    self.answerTitleLabel.text = [NSString stringWithFormat:@"共答对%d道题", YESNumber];
    
    for(UIView *subview in self.subviews)
    {
        if(subview.tag == 999)
        {
            [subview removeFromSuperview];
        }
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34+lastButton.bottom+20, Screen_Width, 0.5)];
    lineView.backgroundColor = kColorLineSepBackground;
    lineView.tag = 999;
    [self addSubview:lineView];
}

- (CGFloat)getHeightReportSheetCell
{
    UIButton *lastButton = nil;
    for(int index=0; index<[self.answerList count]; index++)
    {
        //创建一个视图
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        int hang = index/4;
        int lie = index%4;
        int iconWidth = 40;
        int firstkongxi = 30;
        int kongxi = (Screen_Width - iconWidth*5 - firstkongxi*2)/4;
        
        functionBtn.frame = CGRectMake(firstkongxi+kongxi*(lie)+iconWidth*lie, 15*(hang+1)+50*hang, iconWidth, iconWidth);
        
        lastButton = functionBtn;
    }
    
    return lastButton.bottom+20+34;
}

- (void)functionBtnAction:(UIButton *)button
{
    
}

@end
