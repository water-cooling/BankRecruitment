//
//  SubmitQuestionViewController.m
//  Recruitment
//
//  Created by humengfan on 2020/10/12.
//  Copyright © 2020 LongLian. All rights reserved.
//

#define MAX_LIMIT_TITLE_NUMS 20
#define MAX_LIMIT_NUMS 90

#import "SubmitQuestionViewController.h"
#import "SPPageMenu.h"
#import "UITextView+FGPlaceholder.h"
@interface SubmitQuestionViewController ()<SPPageMenuDelegate,UITextViewDelegate>
@property (nonatomic, strong)  SPPageMenu*pageMenu;
@property (nonatomic, strong)  UITextView*textView;
@property (nonatomic, strong)  UITextView*headlineTextView;
@property (nonatomic, strong) UIButton *submitBtn;


@end

@implementation SubmitQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我要提问";
    [self drawViews];
    [self initUI];
    // Do any additional setup after loading the view.
}
- (void)drawViews{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI{
    UILabel * titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
           [self.view addSubview:titleLabel];
           [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(self.view).offset(13);
               make.top.mas_equalTo(self.view).offset(14);
           }];
    [self.view addSubview:self.pageMenu];
    UIView * speatorView = [UIView new];
    speatorView.backgroundColor = [UIColor colorWithHex:@"#F3F3F3"];
    [self.view addSubview:speatorView];
    [speatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(89);
        make.height.mas_equalTo(1);
    }];
    UILabel * textViewTitleLabel = [UILabel new];
    textViewTitleLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
    textViewTitleLabel.textAlignment = NSTextAlignmentCenter;
    textViewTitleLabel.textColor = [UIColor blackColor];
       [self.view addSubview:textViewTitleLabel];
    [textViewTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.view).offset(13);
        make.top.mas_equalTo(speatorView.mas_bottom).offset(17);
       }];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.textView];
    
    [self.headlineTextView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view).offset(13);
         make.right.equalTo(self.view).offset(-13);
         make.top.equalTo(textViewTitleLabel.mas_bottom).offset(17);
        make.height.mas_equalTo(100);
     }];
    
    UIView * titleSpeatorView = [UIView new];
    titleSpeatorView.backgroundColor = [UIColor colorWithHex:@"#F3F3F3"];
       [self.view addSubview:titleSpeatorView];
       [titleSpeatorView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.equalTo(self.view);
           make.top.equalTo(self.headlineTextView.mas_bottom).offset(2);
           make.height.mas_equalTo(1);
       }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(13);
        make.right.equalTo(self.view).offset(-13);
        make.top.equalTo(titleSpeatorView.mas_bottom).offset(10);
        make.bottom.equalTo(self.submitBtn.mas_top).offset(-10);
    }];
}

-(void)submitClick{
    
}


#pragma mark textviewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if ([self.textView isEqual:self.textView]) {
            if (offsetRange.location < MAX_LIMIT_NUMS) {
                       return YES;
                   }
                   else
                   {
                       return NO;
                   }
        }else{
        if (offsetRange.location < MAX_LIMIT_TITLE_NUMS) {
                       return YES;
            }else{
                       return NO;
            }
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen;
    if ([self.textView isEqual:self.textView]) {
        caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    }else{
        caninputlen = MAX_LIMIT_TITLE_NUMS - comcatstr.length;

    }
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
        }
        return NO;
    }
    
}
- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if ([self.textView isEqual:self.textView]) {
        if (existTextNum > MAX_LIMIT_NUMS){
            //截取到最大位置的字符
            NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
            [textView setText:s];
        }
    }else{
       if (existTextNum > MAX_LIMIT_TITLE_NUMS){
            //截取到最大位置的字符
            NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_TITLE_NUMS];
            [textView setText:s];
        }
    }
}

#pragma mark --getting

- (SPPageMenu *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+30, Screen_Width, 60)];
        [_pageMenu setItems:@[@"全部",@"待支付",@"已支付",@"已取消"] selectedItemIndex:0];
        _pageMenu.delegate = self;
    }
    return _pageMenu;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = UIColorFromRGB(0x8a8a8a);
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.placeholder = @"请描述你的问题，描述越详细 教师回答越具体的哦！";
        _textView.zw_placeHolderColor = UIColorFromRGB(0x8a8a8a);
        _textView.delegate = self;
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.textContainerInset = UIEdgeInsetsZero;
    }
    return _textView;
}

-(UITextView *)headlineTextView{
    if (!_headlineTextView) {
        _headlineTextView = [[UITextView alloc]init];
        _headlineTextView.textColor = UIColorFromRGB(0x333333);
        _headlineTextView.font = [UIFont systemFontOfSize:13];
        _headlineTextView.placeholder = @"请输入标题";
        _headlineTextView.zw_placeHolderColor = UIColorFromRGB(0x8a8a8a);
        _headlineTextView.delegate = self;
        _headlineTextView.textContainer.lineFragmentPadding = 0;
        _headlineTextView.textContainerInset = UIEdgeInsetsZero;
    }
    return _headlineTextView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"提交" forState:0];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _submitBtn.backgroundColor = KColorBlueText;
        [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
@end
