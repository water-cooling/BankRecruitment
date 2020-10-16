//
//  TitleSearchView.h
//  moocios
//
//  Created by 张超 on 16/6/2.
//  Copyright © 2016年 南京医中下天科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SearchBarStyle) {
    SearchBarStyleNone,
    SearchBarStyleCannel,
    SearchBarStyleBack,
};
@interface YLSPGoodsSearchView : UIView
@property (nonatomic, strong) UIButton *QABtn;
@property (nonatomic, strong) UITextField *SeachBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) SearchBarStyle Style;

- (void)showCanncelAnimation;

-(void)showSearchViewAnimation;

@end
