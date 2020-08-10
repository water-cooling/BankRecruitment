//
//  DBYChatTableViewCell.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/10.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYBaseChatTableViewCell.h"
#import "DBYChatInfo.h"
#import "DBYBaseUIMacro.h"

NSString* const kDBYBaseChatTableViewCellReuseID = @"kDBYBaseChatTableViewCellReuseID";
CGFloat const kDBYBaseChatTableViewCellHeight = 58;


#define DBYBASECHATTABLEVIEWCELLLABELHEIGHT 18 //label高度
@interface DBYBaseChatTableViewCell ()

//聊天主体显示View
@property(nonatomic,strong)UIView*mainView;

@property(nonatomic,strong)UILabel* timeLabel;

@property(nonatomic,strong)UILabel*nameLabel;

@property(nonatomic,strong)UILabel* messageLabel;
@end
@implementation DBYBaseChatTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = DBYColorFromRGBA(238, 238, 242, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *mainView = [[UIView alloc]init];
        mainView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:mainView];
        mainView.layer.cornerRadius = 4;
        self.mainView = mainView;
        
        UILabel*timeLabel = [[UILabel alloc]init];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = DBYColorFromRGBA(181, 181, 181, 1);
        self.timeLabel = timeLabel;
        [mainView addSubview:timeLabel];
        
        UILabel*nameLabel = [[UILabel alloc]init];
        nameLabel.font = timeLabel.font;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = DBYColorFromRGBA(155, 155, 155, 1);
        self.nameLabel = nameLabel;
        [mainView addSubview:nameLabel];
        
        UILabel* messageLabel = [[UILabel alloc]init];
        messageLabel.font = timeLabel.font;
        messageLabel.textColor = DBYColorFromRGBA(74, 74, 74, 1);
        messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel = messageLabel;
        [mainView addSubview:messageLabel];
        
        
        
        timeLabel.text = @"18:22:22";
        nameLabel.text = @"【学员】是的是的";
        messageLabel.text = @"哈哈哈";
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainViewX = 10;
    CGFloat mainViewY = 2;
    CGFloat mainViewW = self.frame.size.width - mainViewX*2;
    CGFloat mainViewH = self.frame.size.height - mainViewY*2;
    self.mainView.frame = CGRectMake(mainViewX, mainViewY, mainViewW,mainViewH);
    
    
    CGFloat marginX = 12;
    CGFloat marginY = 6;
    
    CGFloat timeLabelY = marginY;
    CGFloat timeLabelH = DBYBASECHATTABLEVIEWCELLLABELHEIGHT;
    CGFloat timeLabelW = 55;
    CGFloat timeLabelX = self.mainView.frame.size.width - marginX - timeLabelW;
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    CGFloat nameLabelX = marginX - 6;
    CGFloat nameLabelY = marginY;
    CGFloat nameLabelH = DBYBASECHATTABLEVIEWCELLLABELHEIGHT;
    CGFloat nameLabelW = CGRectGetMaxX(self.timeLabel.frame) - nameLabelX - timeLabelW  - marginX;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    CGFloat messageLabelX = marginX;
    CGFloat messageLabelY = CGRectGetMaxY(self.nameLabel.frame) + marginY;
    CGFloat messageLabelW = self.mainView.frame.size.width - marginX*2;
    CGFloat messageLabelH = DBYBASECHATTABLEVIEWCELLLABELHEIGHT;
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelW, messageLabelH);
    
}

-(void)setChatInfo:(DBYChatInfo *)chatInfo
{
    _chatInfo = chatInfo;
    
    self.timeLabel.text = chatInfo.timeStr;
    
    self.messageLabel.text = chatInfo.message;
    
    NSString*roleStr = @"";
    UIColor *labelColor = DBYColorFromRGBA(155, 155, 155, 1);
    switch (chatInfo.role) {
        case 1:
            roleStr = @"老师";
            labelColor = [UIColor redColor];
            break;
        case 2:
            roleStr = @"学生";
            labelColor = DBYColorFromRGBA(155, 155, 155, 1);
            break;
        case 4:
            roleStr = @"助教";
            labelColor = DBYColorFromRGBA(0, 162, 255, 1);
            break;
        default:
            break;
    }
    
    self.nameLabel.textColor = labelColor;
    self.nameLabel.text = [NSString stringWithFormat:@"【%@】%@",roleStr,chatInfo.userName];

}
@end
