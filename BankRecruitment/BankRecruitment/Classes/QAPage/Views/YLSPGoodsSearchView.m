//
//  TitleSearchView.m
//  moocios
//
//  Created by 张超 on 16/6/2.
//  Copyright © 2016年 南京医中下天科技有限公司. All rights reserved.
//

#import "YLSPGoodsSearchView.h"

@interface YLSPGoodsSearchView ()
@end

@implementation YLSPGoodsSearchView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.Style = SearchBarStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        UIView * LeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 20)];
        imageView.contentMode = UIViewContentModeRight;
        imageView.image = [UIImage imageNamed:@"搜索"];
        [LeftView addSubview:imageView];

        self.SeachBar = [[UITextField alloc] init];
        self.SeachBar.returnKeyType =  UIReturnKeySearch;
        [self addSubview:self.SeachBar];
        self.SeachBar.leftView = LeftView;
        self.SeachBar.backgroundColor = [UIColor colorWithHex:@"#F6F6F6"];
        self.SeachBar.leftViewMode = UITextFieldViewModeAlways;
        self.SeachBar.borderStyle = UITextBorderStyleNone;
        self.SeachBar.placeholder = @"搜索题目";
        self.SeachBar.textColor = [UIColor colorWithHex:@"#3B393A"];
        [self.SeachBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.top.equalTo(self).offset(StatusBarHeight+10);
            make.height.mas_equalTo(30);
            make.right.equalTo(self).offset(-52);
        }];
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor colorWithHex:@"#6C6D72"] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(44);
            make.centerY.equalTo(self.SeachBar);
            make.height.mas_equalTo(14);
        }];
        [self addSubview:self.QABtn];
        [self.QABtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self.SeachBar);
        }];
        [self layoutIfNeeded];//这句代码很重要，不能忘了
        self.SeachBar.layer.cornerRadius = self.SeachBar.height/2;
        self.SeachBar.layer.masksToBounds = YES;
    }
    return self;
}

- (void)showCanncelAnimation {
    if (self.Style == SearchBarStyleCannel) {
        return;
    }
    [UIView animateWithDuration:0.25f animations:^{
        [self.QABtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(self.QABtn.width);
        }];
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            
        }];
        
        [self setNeedsLayout];
    
    } completion:^(BOOL finished) {
        
        self.Style = SearchBarStyleCannel;
    }];
}
- (void)showSearchViewAnimation {
    if (self.Style == SearchBarStyleNone) {
        return;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.QABtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
        }];
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(44);
        }];
        [self setNeedsLayout];
    } completion:^(BOOL finished) {
        self.Style = SearchBarStyleNone;

    }];
}
- (UIButton *)QABtn {
    if (!_QABtn) {
        _QABtn = [[UIButton alloc] init];
        [_QABtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _QABtn.titleLabel.font = [UIFont systemFontOfSize:9];
        _QABtn.titleLabel.numberOfLines = 0;
        [_QABtn setBackgroundImage:[UIImage imageNamed:@"椭圆蓝"] forState:0];
        [_QABtn setTitle:@"我的\n问题" forState:UIControlStateNormal];
    }
    return _QABtn;
}
@end
