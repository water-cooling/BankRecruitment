//
//  DBYSelectView.h
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/7.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DBYSelectViewDelegate ;

typedef enum : NSUInteger {
    DBYSelectViewShowModeFill,//按钮不填满view
    DBYSelectViewShowModeFull, //按钮填满view
} DBYSelectViewShowMode;
@interface DBYSelectView : UIView

@property(nonatomic,weak)id<DBYSelectViewDelegate>delegate;
/**
 初始化

 @param titles 选项标题数组
 */
-(instancetype)initWithTitles:(NSArray*)titles;


/**
 设置按钮标题

 @param title 标题
 @param index 按钮序号
 */
-(void)setButtonTitle:(NSString*)title atIndex:(NSInteger)index;

-(void)setButtonColorWith:(UIColor*)color withState:(UIControlState)state;

-(void)setButtonTitleColorWith:(UIColor*)color withState:(UIControlState)state;
@property(nonatomic,assign)DBYSelectViewShowMode mode;
@property(nonatomic,strong)UIColor* borderColor;
@end
@protocol DBYSelectViewDelegate <NSObject>
@optional

/**
 点击按钮回调
 
 @param index 点击按钮序号
 */
-(void)selectView:(DBYSelectView*)selectView didClickButtonAtIndex:(NSInteger)index;
@end
