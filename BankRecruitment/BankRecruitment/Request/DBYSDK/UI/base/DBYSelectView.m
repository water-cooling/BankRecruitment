//
//  DBYSelectView.m
//  DBYSDKFullFuncDemo
//
//  Created by Michael on 17/4/7.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "DBYSelectView.h"

#import "DBYBaseUIMacro.h"


#define DBYSELECTVIEWTITLESVIEWX 10 //titlesView X
#define DBYSELECTVIEWTITLESVIEWY 6 //titlesView Y
#define DBYSELECTVIEWTITLESVIEWW (self.frame.size.width - DBYSELECTVIEWTITLESVIEWX*2) //titlesView W
#define DBYSELECTVIEWTITLESVIEWH (self.frame.size.height - DBYSELECTVIEWTITLESVIEWY*2) //titlesView H

#define DBYSELECTVIEWTITLESVIEWBORDERCOLOR DBYColorFromRGBA(213, 215, 223, 1)//边框颜色

#define DBYSELECTVIEWTITLESVIEWBUTTONTITLECOLOR DBYColorFromRGBA(87,90,96,1)  //按钮标题颜色

#define DBYSELECTVIEWTITLESVIEWBUTTONSELECTEDCOLOR DBYColorFromRGBA(238,238,242,1)//按钮选中后背景颜色
#define DBYSELECTVIEWTITLESVIEWBACKGROUNDCOLOR [UIColor whiteColor] //背景颜色
@interface DBYSelectView ()
//标题数组
@property(nonatomic,strong)NSArray*titles;
//保存按钮数组
@property(nonatomic,strong)NSMutableArray* buttonsArray;

@property(nonatomic,strong)UIView* titlesView;
@end
@implementation DBYSelectView

-(instancetype)initWithTitles:(NSArray *)titles
{
    if (!titles.count) {
        return nil;
    }
    if (self = [super init]) {
        
        self.titles = titles;
        
        self.backgroundColor = DBYSELECTVIEWTITLESVIEWBACKGROUNDCOLOR;
        
        [self addSubViews];
        
    }
    return self;
}
//添加子View
-(void)addSubViews
{
    //所有标题的父view
    UIView*titlesView = [[UIView alloc]init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.layer.cornerRadius = 4;
    titlesView.layer.masksToBounds = YES;
    titlesView.layer.borderColor = DBYSELECTVIEWTITLESVIEWBORDERCOLOR.CGColor;
    titlesView.layer.borderWidth = 1;
    
    
    [self addSubview:titlesView];
    self.titlesView = titlesView;
    //所有选择按钮
    for (int i = 0; i<self.titles.count; i++) {
        
        NSString*title = [self.titles objectAtIndex:i];
        
        UIButton*button = [[UIButton alloc]init];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:DBYSELECTVIEWTITLESVIEWBUTTONTITLECOLOR forState:UIControlStateNormal];
        
        //边框
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = DBYSELECTVIEWTITLESVIEWBORDERCOLOR.CGColor;
        
        //背景色
        [button setBackgroundImage:[DBYUIUtils createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[DBYUIUtils createImageWithColor:DBYSELECTVIEWTITLESVIEWBUTTONSELECTEDCOLOR] forState:UIControlStateSelected];
        [button setBackgroundImage:[DBYUIUtils createImageWithColor:DBYSELECTVIEWTITLESVIEWBUTTONSELECTEDCOLOR] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.selected = YES;
        }
        
        [self.buttonsArray addObject:button];
        [titlesView addSubview:button];
        
    }
}
//设置子控件frame
-(void)setupSubviewsFrame
{
    CGFloat titlesViewX = DBYSELECTVIEWTITLESVIEWX;
    CGFloat titlesViewY = DBYSELECTVIEWTITLESVIEWY;
    CGFloat titlesViewW = DBYSELECTVIEWTITLESVIEWW;
    CGFloat titlesViewH = DBYSELECTVIEWTITLESVIEWH;
    
    
    
    
    self.titlesView.frame = CGRectMake(titlesViewX, titlesViewY, titlesViewW, titlesViewH);
    
    if (self.mode == DBYSelectViewShowModeFull) {
        titlesViewW = self.frame.size.width;
        titlesViewH = self.frame.size.height;
        self.titlesView.frame = self.bounds;
    }
    
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = titlesViewW / self.titles.count;
    CGFloat buttonH = titlesViewH;
    
    for (int i = 0; i<self.buttonsArray.count; i++) {
        buttonX = i*buttonW;
        
        UIButton*button = [self.buttonsArray objectAtIndex:i];
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupSubviewsFrame];
    
}
-(void)setButtonTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index < 0 || index >= self.buttonsArray.count) {
        return;
    }
    UIButton*button = [self.buttonsArray objectAtIndex:index];
    
    [button setTitle:title forState:UIControlStateNormal];
}
-(void)setButtonColorWith:(UIColor *)color withState:(UIControlState)state
{
    for (UIButton*btn in self.buttonsArray) {
        [btn setBackgroundImage:[DBYUIUtils createImageWithColor:color] forState:state];
    }
}
-(void)setButtonTitleColorWith:(UIColor *)color withState:(UIControlState)state
{
    for (UIButton*btn in self.buttonsArray) {
        [btn setTitleColor:color forState:state];
    }
}
#pragma mark - action methods
-(void)clickButton:(UIButton*)button
{
    if (![self.buttonsArray containsObject:button]) {
        return;
    }
    for (UIButton*button in self.buttonsArray) {
        button.selected = NO;
    }
    
    button.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(selectView:didClickButtonAtIndex:)]) {
        [self.delegate selectView:self didClickButtonAtIndex:button.tag];
    }
    
    
}
#pragma mark - setter
-(void)setMode:(DBYSelectViewShowMode)mode
{
    _mode = mode;
    [self setupSubviewsFrame];
    
    for (UIButton*btn in self.buttonsArray) {
        if (mode == DBYSelectViewShowModeFull) {
            btn.layer.borderWidth = 0;
        } else {
            btn.layer.borderWidth = 1;
        }
    }
}
-(void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    self.titlesView.layer.borderColor = borderColor.CGColor;
}
#pragma mark - 懒加载
-(NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}
@end
