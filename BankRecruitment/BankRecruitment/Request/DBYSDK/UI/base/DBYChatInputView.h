//
//  DBYChatInputView.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/13.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DBYChatInputViewDelegate ;
@interface DBYChatInputView : UIView
@property(nonatomic,weak)id<DBYChatInputViewDelegate> delegate;


-(void)beginEdit;
-(void)endEdit;
-(void)clearMsg;
@end
@protocol DBYChatInputViewDelegate <NSObject>
@optional
-(void)chatInputViewDidBeginEdit:(DBYChatInputView*)inputView;
//点击发送按钮调用
-(void)chatInputView:(DBYChatInputView*)chatInputView didClickSendWithMessage:(NSString*)msg;

@end
