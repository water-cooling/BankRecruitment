//
//  DBYChatInputView.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/13.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYChatInputView.h"

#import "DBYBaseUIMacro.h"


#define DBYChatInputViewPlaceholder @"输入聊天内容"

@interface DBYChatInputView () <UITextViewDelegate>
@property(nonatomic,weak)UITextView*textView;

@property(nonatomic,weak)UILabel* placeholderLabel;
@property(nonatomic,weak)UIButton* sendButton;
@property(nonatomic,weak)UIButton* cancelButton;
@end
@implementation DBYChatInputView
-(instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UITextView*textView = [[UITextView alloc]init];
        textView.keyboardType = UIKeyboardTypeDefault;
        textView.returnKeyType = UIReturnKeySend;
        textView.font = [UIFont systemFontOfSize:13];
        textView.scrollEnabled = NO;
        textView.textColor = DBYColorFromRGBA(74, 74, 74, 1);
        
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 4;
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = DBYColorFromRGBA(213, 215, 223, 1).CGColor;
        
        textView.delegate = self;
        self.textView = textView;
        [self addSubview:textView];
        
        
        UILabel*placeholderLabel = [[UILabel alloc]init];
        self.placeholderLabel = placeholderLabel;
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.text = DBYChatInputViewPlaceholder;
        self.placeholderLabel.backgroundColor =[UIColor clearColor];
        placeholderLabel.textColor = DBYColorFromRGBA(155, 155, 155, 1);
        placeholderLabel.font = [UIFont systemFontOfSize:13];
        [textView addSubview:placeholderLabel];
        
        UIButton*sendButton = [[UIButton alloc]init];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [sendButton setBackgroundImage:[DBYUIUtils createImageWithColor:DBYColorFromRGBA(0, 162, 255, 1)] forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[DBYUIUtils createImageWithColor:DBYColorFromRGBA(204, 206, 213, 1)] forState:UIControlStateDisabled];
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.cornerRadius = 4;
        self.sendButton = sendButton;
        sendButton.enabled = NO;
        [self addSubview:sendButton];
        [sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton*cancelButton = [[UIButton alloc]init];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:DBYColorFromRGBA(74, 74, 74, 1) forState:UIControlStateNormal];
        cancelButton.layer.masksToBounds = YES;
        cancelButton.layer.cornerRadius = 4;
        cancelButton.layer.borderWidth = 1;
        cancelButton.layer.borderColor = DBYColorFromRGBA(213, 215, 223, 1).CGColor;
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
         [cancelButton setBackgroundImage:[DBYUIUtils createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.cancelButton = cancelButton;
        [self addSubview:cancelButton];
        
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat textViewX = 10;
    CGFloat textViewY = 10;
    CGFloat textViewW = self.frame.size.width - textViewX*2;
    CGFloat textViewH = 60;
    
    self.textView.frame = CGRectMake(textViewX, textViewY, textViewW, textViewH);
    
    self.placeholderLabel.frame = CGRectMake(5, 5, textViewW - 5*2, 18);
    
    CGFloat buttonW = 68;
    CGFloat buttonH = 30;
    
    CGFloat marginX = 10;
    CGFloat marginY = 6;
    
    CGFloat sendButtonX = self.frame.size.width - buttonW - marginX;
    CGFloat sendButtonY = CGRectGetMaxY(self.textView.frame) + marginY;
    
    self.sendButton.frame = CGRectMake(sendButtonX, sendButtonY, buttonW, buttonH);
    
    CGFloat cancelButtonX = self.sendButton.frame.origin.x - 6 - buttonW;
    CGFloat cancelButtonY = sendButtonY;
    
    self.cancelButton.frame = CGRectMake(cancelButtonX, cancelButtonY, buttonW, buttonH);
    
}
#pragma mark - private
-(void)sendMessage
{
    NSString*message = self.textView.text;
    if (message.length == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(chatInputView:didClickSendWithMessage:)]) {
        [self.delegate chatInputView:self didClickSendWithMessage:message];
    }
}
#pragma mark - pubic
-(void)beginEdit
{
    [self.textView becomeFirstResponder];
}
-(void)endEdit
{
    [self.textView endEditing:YES];
}
-(void)clearMsg
{
    self.textView.text = @"";
    self.placeholderLabel.text = DBYChatInputViewPlaceholder;
    self.sendButton.enabled = NO;
}
#pragma mark - action methods
-(void)clickCancelButton:(UIButton*)button
{
    [self.textView endEditing:YES];
}
- (void)clickSendButton:(UIButton*)button
{
    [self sendMessage];
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView*)textView
{
    
    if([textView.text length] == 0){
        
        self.placeholderLabel.text = DBYChatInputViewPlaceholder;
        
        self.sendButton.enabled = NO;
        
    }else{
        
        self.placeholderLabel.text = @"";//这里给空
        self.sendButton.enabled = YES;
    }
    
    //计算剩余字数   不需要的也可不写
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatInputViewDidBeginEdit:)]) {
        [self.delegate chatInputViewDidBeginEdit:self];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger maxLineNum = 2;
    NSString *textString = @"Text";
    CGSize fontSize = [textString sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    
    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    CGSize tallerSize = CGSizeMake(textView.frame.size.width-15,textView.frame.size.height*2);
    
    CGSize newSize = [newText boundingRectWithSize:tallerSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: textView.font}
                                           context:nil].size;
    NSInteger newLineNum = newSize.height / fontSize.height;
    if ([text isEqualToString:@"\n"]) {
        newLineNum += 1;
        [self sendMessage];
        if (newLineNum >= maxLineNum) {
            return NO;
        }
    }
    
    if ((range.length < 140)
        && newSize.width < textView.frame.size.width-15)
    {
        return YES;
    }else{
        return NO;
    }
}
@end
