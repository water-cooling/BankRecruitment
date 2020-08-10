//
//  BBAlertView.m
//  BlueBoxDemo
//
//  Created by 刘坤 on 12-6-21.
//  Copyright (c) 2012年 Suning. All rights reserved.
//

#import "BBAlertView.h"
#import "SNGraphics.h"
#import "UIView+SNFoundation.h"
#import "UIColor+SNFoundation.h"
#import <QuartzCore/QuartzCore.h>
//#import "AppConstant.h"
#define leftBtnImage        [UIImage streImageNamed:@"button_white_normal.png"]
#define rightBtnImage       [UIImage streImageNamed:@"button_orange_normal.png"]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#ifndef kScreenHeight
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#endif

#ifndef kScreenWidth
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#endif

#ifndef GetHeight
#define GetHeight(h)  (h) * kScreenWidth / 320
#endif

#ifndef GetWidth
#define GetWidth(w)   (w) * kScreenWidth / 320
#endif

#ifndef Get375Height
#define Get375Height(h)  (h) * kScreenWidth / 375
#endif

#ifndef Get375Width
#define Get375Width(w)   (w) * kScreenWidth / 375
#endif


#define kContentLabelWidth      260.0f

static CGFloat kTransitionDuration = 0.3f;
static NSMutableArray *gAlertViewStack = nil;
static UIWindow *gPreviouseKeyWindow = nil;
static UIWindow *gMaskWindow = nil;

@implementation NSObject (BBAlert)

- (void)alertCustomDlg:(NSString *)message
{
    BBAlertView *alert = [[BBAlertView alloc] initWithTitle:L(@"system-info")
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:L(@"Ok")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)dismissAllCustomAlerts
{
    for (BBAlertView *alert in gAlertViewStack)
    {
        if ([alert delegate] == self && alert.visible) {
            [alert setDelegate:nil];
            [alert dismiss];
        }
    }
}

@end

/*********************************************************************/

@interface BBAlertView()
{
    NSInteger clickedButtonIndex;
}
@property (nonatomic, strong) TTTAttributedLabel *bodyAttributeTextLabel;

//orientation
- (void)registerObservers;
- (void)removeObservers;
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;
- (void)sizeToFitOrientation:(BOOL)transform;
- (CGAffineTransform)transformForOrientation;

+ (BBAlertView *)getStackTopAlertView;
+ (void)pushAlertViewInStack:(BBAlertView *)alertView;
+ (void)popAlertViewFromStack;

+ (void)presentMaskWindow;
+ (void)dismissMaskWindow;

+ (void)addAlertViewOnMaskWindow:(BBAlertView *)alertView;
+ (void)removeAlertViewFormMaskWindow:(BBAlertView *)alertView;

- (void)bounce0Animation;
- (void)bounce1AnimationDidStop;
- (void)bounce2AnimationDidStop;
- (void)bounceDidStop;

- (void)dismissAlertView;


//tools
+ (CGFloat)heightOfString:(NSString *)message;
@end

/*********************************************************************/

@implementation BBAlertView

@synthesize delegate = _delegate;
@synthesize visible = _visible;
@synthesize dimBackground = _dimBackground;
@synthesize style = _style;

@synthesize titleLabel = _titleLabel;
@synthesize bodyTextLabel = _bodyTextLabel;
@synthesize bodyTextView = _bodyTextView;
@synthesize customView = _customView;
@synthesize backgroundView = _backgroundView;
@synthesize contentView = _contentView;
@synthesize cancelButton = _cancelButton;
@synthesize otherButton = _otherButton;
@synthesize shouldDismissAfterConfirm = _shouldDismissAfterConfirm;
@synthesize contentAlignment = _contentAlignment;


- (void)dealloc {
    _delegate = nil;
    
    TT_RELEASE_SAFELY(_titleLabel);
    TT_RELEASE_SAFELY(_bodyTextLabel);
    TT_RELEASE_SAFELY(_bodyTextView);
    TT_RELEASE_SAFELY(_customView);
    TT_RELEASE_SAFELY(_backgroundView);
    TT_RELEASE_SAFELY(_contentView);
    TT_RELEASE_SAFELY(_cancelButton);
    TT_RELEASE_SAFELY(_otherButton);
    _cancelBlock = nil;
    _confirmBlock = nil;
    [self removeObserver:self forKeyPath:@"dimBackground"];
    [self removeObserver:self forKeyPath:@"contentAlignment"];
}


- (void)initData
{
    _shouldDismissAfterConfirm = YES;
    _dimBackground = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentAlignment = NSTextAlignmentCenter;
    
    [self addObserver:self
           forKeyPath:@"dimBackground"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [self addObserver:self
           forKeyPath:@"contentAlignment"
              options:NSKeyValueObservingOptionNew
              context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"dimBackground"]) {
        [self setNeedsDisplay];
    }else if ([keyPath isEqualToString:@"contentAlignment"]){
        self.bodyTextLabel.textAlignment = self.contentAlignment;
        self.bodyTextView.textAlignment = self.contentAlignment;
    }
}
-(id)initWithTitle:(NSString *)title
           message:(NSString *)message
             image:(UIImage *)image
          delegate:(id <BBAlertViewDelegate>)delegate
       cancelImage:(UIImage *)cancelImage
 otherButtonTitles:(NSString *)otherButtonTitle{
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self) {
        [self initData];
        _delegate = delegate;
        _style = BBAlertViewStyleDefault;
        
        //content view
//        CGFloat centerY = self.bounds.size.height;
        CGFloat boxWidth = 280;   //弹出框宽度
        CGFloat contentWidth = 220;
        //                CGRect titleBgFrame = CGRectMake(0, 0, boxWidth, 0);
        CGRect titleFrame = CGRectZero;
        

        
        //X按钮 取消
        
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.cancelButton setImage:cancelImage forState:UIControlStateNormal];
        [self.cancelButton setFrame:CGRectMake(280-44, 0, 44, 44)];
        [self.cancelButton setTag:0];
        
        [self.contentView addSubview:self.cancelButton];
        
        
        if (IsStrEmpty(title)) {
            //图片 没有title
            self.imageViewIcon.image = image;
            self.imageViewIcon.frame = CGRectMake((280-211)/2.0, 40, 211, 69);
            
            titleFrame = CGRectMake((280-211)/2.0, 40, 211, 69);
            
            [self.contentView addSubview:self.imageViewIcon];
        }
        else{
            
            titleFrame = CGRectMake((boxWidth-contentWidth)/2, 25, contentWidth, 15);
            self.titleLabel.text = title;
            self.titleLabel.frame = titleFrame;
            [self.contentView addSubview:self.titleLabel];
        }

        

        contentWidth = 260;
        UIFont *contentFont =[UIFont systemFontOfSize:14];
//        CGSize messageSize = [message sizeWithFont:contentFont
//                                 constrainedToSize:CGSizeMake(contentWidth, 1000)
//                                     lineBreakMode:UILineBreakModeCharacterWrap];
        CGRect messageRect = [message boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)//限制最大的宽度和高度
                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                        attributes:@{NSFontAttributeName: contentFont}//传入的字体字典
                                           context:nil];
        
        //push 特别
        CGFloat contentHeight = messageRect.size.height;// > 36 ? messageSize.height : 36;
        BOOL isNeedUseTextView = NO;
        if (contentHeight > 300)  //content最高240,12行
        {
            isNeedUseTextView = YES;
            contentHeight = 300;
        }
        
        CGRect contentFrame = CGRectMake((boxWidth-contentWidth)/2, CGRectGetMaxY(titleFrame) + 15, contentWidth, contentHeight);

        //message
        if (isNeedUseTextView) {
            self.bodyTextView.text = message;
            self.bodyTextView.frame = contentFrame;
            self.bodyTextView.font = contentFont;
            self.bodyTextView.textColor = [UIColor colorWithRGBHex:0x353d44];
            [self.contentView addSubview:self.bodyTextView];
        }else{
            self.bodyTextLabel.text = message;
            self.bodyTextLabel.frame = contentFrame;
            self.bodyTextLabel.font = contentFont;
            self.bodyTextLabel.textColor = [UIColor colorWithRGBHex:0x353d44];
            [self.contentView addSubview:self.bodyTextLabel];
        }
        
        
        CGFloat btnWidth = boxWidth;
        CGFloat btnTop = contentFrame.size.height + contentFrame.origin.y+35;
        CGFloat btnHeight = 44;

        self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                               forState:UIControlStateNormal];
        [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        [self.otherButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
        [self.otherButton setTag:1];
        
        //分割线
        self.seplineH.frame = CGRectMake(0, btnTop, self.width, 0.5);
        [self.contentView addSubview:self.seplineH];
        [self.contentView addSubview:self.otherButton];
        
    }

    
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 8.0f;
    self.contentView.backgroundColor = [UIColor whiteColor];
    CGFloat boxHeight = self.otherButton.bottom;
    CGRect boxFrame = CGRectMake((self.width-280)/2,
                                 (self.bounds.size.height-boxHeight)/2,
                                 280,
                                 boxHeight);
    self.contentView.frame = boxFrame;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    return self;

}
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<BBAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitle
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initData];
        _delegate = delegate;
        _style = BBAlertViewStyleDefault;
        
        //默认为系统提示
        if (![title length]) {
            //title = L(@"system-error");
        }
        
        //content view
        CGFloat centerY = self.bounds.size.height ;
        CGFloat boxWidth = 280;   //弹出框宽度
        CGFloat contentWidth = 220;
        CGRect titleBgFrame = CGRectMake(0, 0, boxWidth, 0);
        //        CGRect titleFrame = CGRectMake((boxWidth-contentWidth)/2, 0, contentWidth, 40);
        
        //计算content
        //        UIFont *titleFont = [UIFont systemFontOfSize:20.0f];
        UIFont *contentFont = [UIFont systemFontOfSize:14];
//        CGSize messageSize = [message sizeWithFont:contentFont
//                                 constrainedToSize:CGSizeMake(contentWidth, 1000)
//                                     lineBreakMode:UILineBreakModeCharacterWrap];
        CGRect messageRect = [message boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)//限制最大的宽度和高度
                                                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                                attributes:@{NSFontAttributeName: contentFont}//传入的字体字典
                                                   context:nil];
        CGFloat contentHeight = messageRect.size.height > 36 ? messageRect.size.height : 36;
        BOOL isNeedUseTextView = NO;
        if (contentHeight > 300)  //content最高240,12行
        {
            isNeedUseTextView = YES;
            contentHeight = 300;
        }
        
        CGRect contentFrame = CGRectMake((boxWidth-contentWidth)/2, 25, contentWidth, contentHeight);
        
        //button 1
        CGFloat btnTop = contentFrame.size.height + 50;
        CGFloat btnHeight = 44;
        if (cancelButtonTitle && otherButtonTitle) {
            CGFloat btnWidth = boxWidth / 2;
            
            [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0x333333]
                                    forState:UIControlStateNormal];
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [self.cancelButton setFrame:CGRectMake(0, btnTop, btnWidth, btnHeight)];
            [self.cancelButton setTag:0];
            
            
            [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                                   forState:UIControlStateNormal];
            self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            [self.otherButton setFrame:CGRectMake(self.cancelButton.right, btnTop, btnWidth, btnHeight)];
            [self.otherButton setTag:1];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.cancelButton.top, self.width, 0.5);
            self.seplineV.frame = CGRectMake(self.cancelButton.right, self.cancelButton.top, 0.5, btnHeight);
            
            
            [self.contentView addSubview:self.cancelButton];
            [self.contentView addSubview:self.seplineH];
            [self.contentView addSubview:self.seplineV];
            [self.contentView addSubview:self.otherButton];
        }else if (cancelButtonTitle){
            CGFloat btnWidth = boxWidth;
            [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0xffaa00]
                                    forState:UIControlStateNormal];
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [self.cancelButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
            [self.cancelButton setTag:0];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.cancelButton.top, self.width, 0.5);
            
            [self.contentView addSubview:self.cancelButton];
            [self.contentView addSubview:self.seplineH];
        }else if (otherButtonTitle){
            CGFloat btnWidth = boxWidth;

            self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                                   forState:UIControlStateNormal];
            [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            [self.otherButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
            [self.otherButton setTag:0];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.otherButton.top, self.width, 0.5);
            
            [self.contentView addSubview:self.seplineH];
            [self.contentView addSubview:self.otherButton];
        }
        
        CGFloat boxHeight = titleBgFrame.size.height + 25 + contentHeight + 25 + btnHeight;
        CGRect boxFrame = CGRectMake((self.width-boxWidth)/2, (centerY-boxHeight)/2, boxWidth, boxHeight);
        self.contentView.frame = boxFrame;
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.cornerRadius = 8.0f;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //titleBg imageView
        //        UIImageView *titleBg = [[UIImageView alloc] init];
        //        titleBg.layer.shadowColor = [UIColor grayColor].CGColor;
        //        titleBg.layer.shadowOffset = CGSizeMake(0.7, 0.7);
        //        titleBg.layer.shadowOpacity = 0.8;
        //        titleBg.clipsToBounds = NO;
        //        titleBg.frame = titleBgFrame;
        //        titleBg.image = [UIImage imageNamed:@"system_nav_bg.png"];
        //        [self.contentView addSubview:titleBg];
        //        TT_RELEASE_SAFELY(titleBg);
        
        //titleLabel
        //        self.titleLabel.text = title;
        //        self.titleLabel.frame = titleFrame;
        //        self.titleLabel.textColor = [UIColor darkTextColor];
        //        self.titleLabel.shadowOffset = CGSizeMake(1, 1);
        //        self.titleLabel.shadowColor = [UIColor navTintColor];
        //        self.titleLabel.font = titleFont;
        //        [self.contentView addSubview:self.titleLabel];
        
        //message
        if (isNeedUseTextView) {
            self.bodyTextView.text = message;
            self.bodyTextView.frame = contentFrame;
            self.bodyTextView.font = contentFont;
            self.bodyTextView.textColor = [UIColor colorWithRGBHex:0x333333];
            [self.contentView addSubview:self.bodyTextView];
        }else{
            self.bodyTextLabel.text = message;
            self.bodyTextLabel.frame = contentFrame;
            self.bodyTextLabel.font = contentFont;
            self.bodyTextLabel.textColor = [UIColor colorWithRGBHex:0x333333];
            //            self.bodyTextLabel.shadowOffset = CGSizeMake(1, 1);
            //            self.bodyTextLabel.shadowColor = [UIColor navTintColor];
            [self.contentView addSubview:self.bodyTextLabel];
        }
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
    }
    return self;
}


- (id)initWithTitle:(NSString *)title
   atrributeMessage:(NSAttributedString *)atrributeMessage
           delegate:(id <BBAlertViewDelegate>)delegate
  atrributeDelegate:(id<TTTAttributedLabelDelegate>)atrributeDelegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitle
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initData];
        _delegate = delegate;
        _style = BBAlertViewStyleDefault;
    
        //content view
        CGFloat centerY = self.bounds.size.height ;
        CGFloat boxWidth = 280;   //弹出框宽度
        CGFloat contentWidth = 220;
        


        UIFont *contentFont = [UIFont systemFontOfSize:14];
        
        self.bodyAttributeTextLabel.font = contentFont;
        self.bodyAttributeTextLabel.text = atrributeMessage;
        self.bodyAttributeTextLabel.delegate = atrributeDelegate;
        [self.contentView addSubview:self.bodyAttributeTextLabel];
        
        //高度计算
        __block  CGFloat  contentHeight = 0;
        __block  CGFloat  remainSpace = 0;
      
        [atrributeMessage enumerateAttributesInRange:NSMakeRange(0, atrributeMessage.length) options:NSStringDrawingUsesLineFragmentOrigin usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            NSAttributedString * attStr = [atrributeMessage attributedSubstringFromRange:range];
            UIFont * font = [attrs valueForKey:NSFontAttributeName];
            NSURL * url = [attrs valueForKey:NSLinkAttributeName];
            if ([url isKindOfClass:[NSString class]]) {
                url = [NSURL URLWithString:url];
            }
            if (url) {
                [self.bodyAttributeTextLabel addLinkToURL:url withRange:range];
            }
            
            if (!font) {
                font = contentFont;
                NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
                [muDic setValue:contentFont forKey:NSFontAttributeName];
                NSMutableAttributedString * muSubAttStr = [[ NSMutableAttributedString alloc ]initWithString:attStr.string attributes:muDic];
                CGFloat subHeight = [muSubAttStr boundingRectWithSize:CGSizeMake(contentWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
                contentHeight += subHeight;
            }else{
                CGFloat subHeight = [attStr boundingRectWithSize:CGSizeMake(contentWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
                contentHeight += subHeight;
            }
            
            if (IOS8_OR_LATER) {
                remainSpace += font.lineHeight;//每个都会有两边的
            }else{
                remainSpace = 0;
            }
        }];
        contentHeight -= remainSpace;
        contentHeight = MAX(36, contentHeight);
        //高度计算
        
        CGFloat topGap = 10;
        CGFloat bottomGap = 10;
        CGRect contentFrame = CGRectMake((boxWidth-contentWidth)/2, topGap, contentWidth, contentHeight);
        
        self.bodyAttributeTextLabel.frame = contentFrame;
        
        //button 1
        CGFloat btnTop =  topGap + contentFrame.size.height + bottomGap;
        CGFloat btnHeight = 44;
        if (cancelButtonTitle && otherButtonTitle) {
            CGFloat btnWidth = boxWidth / 2;
            
            [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0x333333]
                                    forState:UIControlStateNormal];
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [self.cancelButton setFrame:CGRectMake(0, btnTop, btnWidth, btnHeight)];
            [self.cancelButton setTag:0];
            
            
            [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                                   forState:UIControlStateNormal];
            self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            [self.otherButton setFrame:CGRectMake(self.cancelButton.right + 0.5, btnTop, btnWidth, btnHeight)];
            [self.otherButton setTag:1];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.cancelButton.top, self.width, 0.5);
            self.seplineV.frame = CGRectMake(self.cancelButton.right, self.cancelButton.top, 0.5, btnHeight);
            
            
            [self.contentView addSubview:self.cancelButton];
            [self.contentView addSubview:self.seplineH];
            [self.contentView addSubview:self.seplineV];
            [self.contentView addSubview:self.otherButton];
        }else if (cancelButtonTitle){
            CGFloat btnWidth = boxWidth;
            [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0xffaa00]
                                    forState:UIControlStateNormal];
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [self.cancelButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
            [self.cancelButton setTag:0];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.cancelButton.top, self.width, 0.5);
            [self.contentView addSubview:self.cancelButton];
            [self.contentView addSubview:self.seplineH];
        }else if (otherButtonTitle){
            CGFloat btnWidth = boxWidth;
            
            self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                                   forState:UIControlStateNormal];
            [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            [self.otherButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
            [self.otherButton setTag:0];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.otherButton.top, self.width, 0.5);
            [self.contentView addSubview:self.seplineH];
            [self.contentView addSubview:self.otherButton];
        }
        
        CGFloat boxHeight = topGap + contentHeight + bottomGap + btnHeight;
        CGRect boxFrame = CGRectMake((self.width-boxWidth)/2, (centerY-boxHeight)/2, boxWidth, boxHeight);
        self.contentView.frame = boxFrame;
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.cornerRadius = 8.0f;
        self.contentView.backgroundColor = [UIColor whiteColor];

 
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
    }
    return self;
}

/*  Deprecated 废弃
 - (id)initWithTitle:(NSString *)title
 message:(NSString *)message
 delegate:(id<BBAlertViewDelegate>)delegate
 cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitles:(NSString *)otherButtonTitle
 {
 self = [super initWithFrame:[UIScreen mainScreen].bounds];
 if (self) {
 [self initData];
 _delegate = delegate;
 _style = BBAlertViewStyleDefault;
 
 //content view
 CGFloat titleHeight = 0.0f;
 CGFloat bodyHeight = 20.0f;
 if (title) {
 titleHeight = 30.0f;
 }
 if (message) {
 bodyHeight = [BBAlertView heightOfString:message];
 }
 
 BOOL isNeedUserTextView = bodyHeight > 170;
 bodyHeight = isNeedUserTextView?170:bodyHeight;
 
 CGFloat finalHeight = titleHeight+bodyHeight+70;
 
 CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height-20;
 self.contentView.frame = CGRectMake(20, (screenHeight-finalHeight)/2.0, 280, finalHeight);
 self.contentView.backgroundColor = RGBACOLOR(255, 255, 255, 0.6);
 //self.contentView.alpha = 0.8;
 self.contentView.layer.cornerRadius = 6.0;
 
 //background image view
 UIImageView *bgImView = [[UIImageView alloc] init];
 bgImView.frame = CGRectMake(5, 5, 270, finalHeight-10);
 bgImView.image = [UIImage imageNamed:@"alert_message_bg.png"];
 [self.contentView addSubview:bgImView];
 TT_RELEASE_SAFELY(bgImView);
 
 //titleLabel
 if (title) {
 self.titleLabel.text = title;
 self.titleLabel.frame = CGRectMake(5, 15, 270, 30);
 self.titleLabel.textColor = RGBCOLOR(53, 79, 138);
 self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
 [self.contentView addSubview:self.titleLabel];
 }
 
 //bodytext label
 CGFloat posY = title?45:15;
 if (isNeedUserTextView) {
 self.bodyTextView.text = message;
 self.bodyTextView.frame = CGRectMake(15, posY, kContentLabelWidth, bodyHeight);
 self.bodyTextView.font = [UIFont systemFontOfSize:16.0f];
 [self.contentView addSubview:self.bodyTextView];
 }else{
 self.bodyTextLabel.text = message;
 self.bodyTextLabel.frame = CGRectMake(15, posY, kContentLabelWidth, bodyHeight);
 self.bodyTextLabel.font = [UIFont systemFontOfSize:16.0f];
 [self.contentView addSubview:self.bodyTextLabel];
 }
 
 //button 1
 CGFloat btnTop = posY+bodyHeight+5;
 if (cancelButtonTitle && otherButtonTitle) {
 UIImage *image2 = [UIImage imageNamed:@"light_blue_button.png"];
 [self.cancelButton setBackgroundImage:image2 forState:UIControlStateNormal];
 [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
 [self.cancelButton setFrame:CGRectMake(15, btnTop, 120, 35)];
 [self.cancelButton setTag:0];
 
 [self.otherButton setBackgroundImage:image2 forState:UIControlStateNormal];
 [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
 [self.otherButton setFrame:CGRectMake(self.cancelButton.right+10, btnTop, 120, 35)];
 [self.otherButton setTag:1];
 
 [self.contentView addSubview:self.cancelButton];
 [self.contentView addSubview:self.otherButton];
 }else if (cancelButtonTitle){
 UIImage *image2 = [UIImage imageNamed:@"submit_blue_button.png"];
 [self.cancelButton setBackgroundImage:image2 forState:UIControlStateNormal];
 [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
 [self.cancelButton setFrame:CGRectMake(30, btnTop, 220, 35)];
 [self.cancelButton setTag:0];
 [self.contentView addSubview:self.cancelButton];
 }else if (otherButtonTitle){
 UIImage *image2 = [UIImage imageNamed:@"submit_blue_button.png"];
 [self.otherButton setBackgroundImage:image2 forState:UIControlStateNormal];
 [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
 [self.otherButton setFrame:CGRectMake(30, btnTop, 220, 35)];
 [self.otherButton setTag:0];
 [self.contentView addSubview:self.otherButton];
 }
 }
 return self;
 
 }
 */

- (id)initWithContentView:(UIView *)contentView
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initData];
        
        self.contentView = contentView;
        self.contentView.center = self.center;
        [self addSubview:self.contentView];
        _style = BBAlertViewStyleCustomView;
        
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
    }
    return self;
}

- (id)initWithStyle:(BBAlertViewStyle)style
              Title:(NSString *)title
            message:(NSString *)message
         customView:(UIView *)customView
           delegate:(id<BBAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitle
{
    _style = style;
    switch (style) {
        case BBAlertViewStyleDefault:
        {
            return [self initWithTitle:title
                               message:message
                              delegate:delegate
                     cancelButtonTitle:cancelButtonTitle
                     otherButtonTitles:otherButtonTitle];
            break;
        
        }
        case BBAlertViewStyle1:
        {
//            self = [super initWithFrame:[UIScreen mainScreen].bounds];
//            if (self) {
//                [self initData];
//                
//                _delegate = delegate;
//                
//                //content view
//                CGFloat titleHeight = 42.0f;
//                CGFloat bodyHeight = [BBAlertView heightOfString:message]+20;
//                CGFloat customViewHeight = 0.0f;
//                if (customView) {
//                    self.customView = customView;
//                    customViewHeight = customView.height;
//                }
//                CGFloat buttonPartHeight = 50.0f;
//                
//                
//                BOOL isNeedUserTextView = bodyHeight > 170;
//                bodyHeight = isNeedUserTextView?170:bodyHeight;
//                
//                CGFloat finalHeight = titleHeight+bodyHeight+customViewHeight+buttonPartHeight+10;
//                
//                self.contentView.backgroundColor = RGBACOLOR(255, 255, 255, 0.5);
//                self.contentView.layer.cornerRadius = 6.0;
//                CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height-20;
//                self.contentView.frame = CGRectMake((ApplicationScreenWidth-280)/2, (screenHeight-finalHeight)/2.0, 280, finalHeight);
//                
//                UIView *alertMainView = [[UIView alloc] init];
//                alertMainView.frame = CGRectMake(5, 5, 270, finalHeight-10);
//                alertMainView.backgroundColor = RGBCOLOR(231, 236, 239);
//                alertMainView.layer.cornerRadius = 4.0;
//                [self.contentView addSubview:alertMainView];
//                
//                
//                //titleBackgroundImage
//                UIImageView *titleBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, titleHeight)];
//                UIImage *image1 = [UIImage imageNamed:@"alert_title_bg.png"];
//                UIImage *streImage1 = [image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:0];
//                titleBgImageView.image = streImage1;
//                [alertMainView addSubview:titleBgImageView];
//                TT_RELEASE_SAFELY(titleBgImageView);
//                
//                //titleLabel
//                UIImageView *titleTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_title_tip.png"]];
//                UIFont *titleFont = [UIFont boldSystemFontOfSize:20.0f];
//                CGSize titleSize = [title sizeWithFont:titleFont];
//                CGFloat titleWidth = titleSize.width<240?titleSize.width:240;
//                self.titleLabel.text = title;
//                self.titleLabel.font = titleFont;
//                self.titleLabel.textColor = [UIColor whiteColor];
//                self.titleLabel.adjustsFontSizeToFitWidth = YES;
//                CGFloat orgionX = 5+(240-titleWidth)/2+20;
//                self.titleLabel.frame = CGRectMake(orgionX, 0, titleWidth, titleHeight);
//                titleTipImageView.frame = CGRectMake(self.titleLabel.left-22, 11, 20, 20);
//                [alertMainView addSubview:titleTipImageView];
//                [alertMainView addSubview:self.titleLabel];
//                TT_RELEASE_SAFELY(titleTipImageView);
//                
//                //bodyLabel
//                if (isNeedUserTextView) {
//                    self.bodyTextView.text = message;
//                    self.bodyTextView.frame = CGRectMake(5, titleHeight, kContentLabelWidth, bodyHeight);
//                    self.bodyTextView.font = [UIFont systemFontOfSize:16.0f];
//                    [alertMainView addSubview:self.bodyTextView];
//                }else{
//                    self.bodyTextLabel.text = message;
//                    self.bodyTextLabel.frame = CGRectMake(5, titleHeight, kContentLabelWidth, bodyHeight);
//                    self.bodyTextLabel.font = [UIFont systemFontOfSize:16.0f];
//                    [alertMainView addSubview:self.bodyTextLabel];
//                }
//                
//                //sepLine
//                UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleHeight+bodyHeight, 270, 1)];
//                UIImage *image2 = [UIImage imageNamed:@"concave_line.png"];
//                UIImage *streImage2 = [image2 stretchableImageWithLeftCapWidth:image2.size.width/2 topCapHeight:0];
//                sepLine.image = streImage2;
//                [alertMainView addSubview:sepLine];
//                TT_RELEASE_SAFELY(sepLine);
//                
//                //custom view
//                if (customView) {
//                    customView.frame = CGRectMake(0, titleHeight+bodyHeight+5, customView.width, customView.height);
//                    [alertMainView addSubview:customView];
//                }
//                
//                //buttons
//                if (cancelButtonTitle && otherButtonTitle) {
//                    CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
//                    UIImage *image3 = leftBtnImage;
//                    UIImage *image4 = rightBtnImage;
//                    UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
//                    UIImage *streImage4 = [image4 stretchableImageWithLeftCapWidth:image4.size.width/2 topCapHeight:0];
//                    [self.cancelButton setBackgroundImage:streImage4 forState:UIControlStateNormal];
//                    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
//                    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [self.cancelButton setFrame:CGRectMake(30, buttonTopPosition, 80, 33)];
//                    [self.cancelButton setTag:0];
//                    
//                    [self.otherButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
//                    [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
//                    [self.otherButton setFrame:CGRectMake(self.cancelButton.right+50, buttonTopPosition, 80, 33)];
//                    [self.otherButton setTag:1];
//                    [alertMainView addSubview:self.cancelButton];
//                    [alertMainView addSubview:self.otherButton];
//                }else if (cancelButtonTitle){
//                    CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
//                    UIImage *image3 = rightBtnImage;
//                    UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
//                    [self.cancelButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
//                    [self.cancelButton setTitle:cancelButtonTitle?cancelButtonTitle:otherButtonTitle forState:UIControlStateNormal];
//                    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [self.cancelButton setFrame:CGRectMake(30, buttonTopPosition, 210, 33)];
//                    [self.cancelButton setTag:0];
//                    [alertMainView addSubview:self.cancelButton];
//                }else if (otherButtonTitle){
//                    CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
//                    UIImage *image3 = rightBtnImage;
//                    UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
//                    [self.otherButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
//                    [self.otherButton setTitle:cancelButtonTitle?cancelButtonTitle:otherButtonTitle forState:UIControlStateNormal];
//                    [self.otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [self.otherButton setFrame:CGRectMake(30, buttonTopPosition, 210, 33)];
//                    [self.otherButton setTag:0];
//                    [alertMainView addSubview:self.otherButton];
//                }
//            }
//            return self;
            break;
        
        }
        case BBAlertViewStyleCustomView:
        {
            BBAlertView *al = [self initWithTitle:title
                                          message:message
                                         delegate:delegate
                                cancelButtonTitle:cancelButtonTitle
                                otherButtonTitles:otherButtonTitle];
            al.customView = customView;
            [al.contentView addSubview:customView];
            al.bodyTextView.hidden  = al.bodyTextLabel.hidden = al.titleLabel.hidden = YES;
            al.customView.frame = CGRectMake(0, 0, al.contentView.width, al.customView.height);
            al.cancelButton.top = al.otherButton.top = customView.height + 25;
            
            al.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, MAX(al.otherButton.bottom, al.cancelButton.bottom) );
            al.customView.frame = CGRectMake(0, 0, al.contentView.width, al.customView.height);
            al.seplineH.frame = CGRectMake(0, al.contentView.height - 44.5, al.contentView.width, 0.5);
            if (cancelButtonTitle && otherButtonTitle)
                al.seplineV.frame = CGRectMake(al.cancelButton.right, al.cancelButton.top, 0.5, 44);
            else
                al.seplineV.hidden = YES;
            
            CGRect boxFrame = CGRectMake((al.width-al.contentView.width)/2, (al.height-al.contentView.height)/2, al.contentView.width, al.contentView.height);
            al.contentView.frame = boxFrame;
            
            return al;
            break;
        
        }
        case BBAlertViewStyleMessageFilter:
        {
//            self = [super initWithFrame:[UIScreen mainScreen].bounds];
//            if (self) {
//                [self initData];
//                
//                _delegate = delegate;
//                
//                //content view
//                CGFloat titleHeight = 0.0f;
//                
//                if (title)
//                {
//                    titleHeight = 42.0f;
//                }
//                
//                CGFloat bodyHeight = 0.0f;
//                
//                if (message)
//                {
//                    bodyHeight = [BBAlertView heightOfString:message]+20;
//                }
//                
//                CGFloat customViewHeight = 0.0f;
//                if (customView) {
//                    self.customView = customView;
//                    customViewHeight = customView.height;
//                }
//                CGFloat buttonPartHeight = 50.0f;
//                
//                
//                BOOL isNeedUserTextView = bodyHeight > 170;
//                bodyHeight = isNeedUserTextView?170:bodyHeight;
//                
//                CGFloat finalHeight = titleHeight+bodyHeight+customViewHeight+buttonPartHeight;
//                
//                self.contentView.backgroundColor = RGBACOLOR(255, 255, 255, 0.5);
//                //self.contentView.layer.cornerRadius = 6.0;
//                CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height-20;
//                self.contentView.frame = CGRectMake((ApplicationScreenWidth-280)/2, (screenHeight-finalHeight)/2.0, 280, finalHeight);
//                
//                UIView *alertMainView = [[UIView alloc] init];
//                alertMainView.frame = CGRectMake(0, 0, 280, finalHeight);
//                alertMainView.backgroundColor = [UIColor whiteColor];
//                //alertMainView.layer.cornerRadius = 4.0;
//                [self.contentView addSubview:alertMainView];
//                
//                
//                //titleBackgroundImage
//                UIImageView *titleBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, titleHeight)];
//                UIImage *image1 = [UIImage imageNamed:@"alert_title_bg.png"];
//                UIImage *streImage1 = [image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:0];
//                titleBgImageView.image = streImage1;
//                [alertMainView addSubview:titleBgImageView];
//                TT_RELEASE_SAFELY(titleBgImageView);
//                
//                //titleLabel
//                /*UIImageView *titleTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_title_tip.png"]];
//                 UIFont *titleFont = [UIFont boldSystemFontOfSize:20.0f];
//                 CGSize titleSize = [title sizeWithFont:titleFont];
//                 CGFloat titleWidth = titleSize.width<240?titleSize.width:240;
//                 self.titleLabel.text = title;
//                 self.titleLabel.font = titleFont;
//                 self.titleLabel.textColor = [UIColor whiteColor];
//                 self.titleLabel.adjustsFontSizeToFitWidth = YES;
//                 CGFloat orgionX = 5+(240-titleWidth)/2+20;
//                 self.titleLabel.frame = CGRectMake(orgionX, 0, titleWidth, titleHeight);
//                 titleTipImageView.frame = CGRectMake(self.titleLabel.left-22, 11, 20, 20);
//                 [alertMainView addSubview:titleTipImageView];
//                 [alertMainView addSubview:self.titleLabel];
//                 TT_RELEASE_SAFELY(titleTipImageView);
//                 
//                 //bodyLabel
//                 if (isNeedUserTextView) {
//                 self.bodyTextView.text = message;
//                 self.bodyTextView.frame = CGRectMake(5, titleHeight, kContentLabelWidth, bodyHeight);
//                 self.bodyTextView.font = [UIFont systemFontOfSize:16.0f];
//                 [alertMainView addSubview:self.bodyTextView];
//                 }else{
//                 self.bodyTextLabel.text = message;
//                 self.bodyTextLabel.frame = CGRectMake(5, titleHeight, kContentLabelWidth, bodyHeight);
//                 self.bodyTextLabel.font = [UIFont systemFontOfSize:16.0f];
//                 [alertMainView addSubview:self.bodyTextLabel];
//                 }
//                 
//                 //sepLine
//                 UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleHeight+bodyHeight, 270, 1)];
//                 UIImage *image2 = [UIImage imageNamed:@"concave_line.png"];
//                 UIImage *streImage2 = [image2 stretchableImageWithLeftCapWidth:image2.size.width/2 topCapHeight:0];
//                 sepLine.image = streImage2;
//                 [alertMainView addSubview:sepLine];
//                 TT_RELEASE_SAFELY(sepLine);*/
//                
//                //custom view
//                if (customView) {
//                    customView.frame = CGRectMake(0, 0, customView.width, customView.height);
//                    [alertMainView addSubview:customView];
//                }
//                
//                //buttons
//                if (cancelButtonTitle && otherButtonTitle) {
//                    CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
//                    UIImage *image3 = [UIImage streImageNamed:@"MessageFilterConfirmBtn"];
//                    UIImage *image4 = [UIImage streImageNamed:@"MessageFilterCancelBtn"];
//                    UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
//                    UIImage *streImage4 = [image4 stretchableImageWithLeftCapWidth:image4.size.width/2 topCapHeight:0];
//                    [self.cancelButton setBackgroundImage:streImage4 forState:UIControlStateNormal];
//                    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
//                    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [self.cancelButton setFrame:CGRectMake(30, buttonTopPosition, 80, 33)];
//                    [self.cancelButton setTag:0];
//                    
//                    [self.otherButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
//                    [self.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
//                    [self.otherButton setFrame:CGRectMake(self.cancelButton.right+50, buttonTopPosition, 80, 33)];
//                    [self.otherButton setTag:1];
//                    [alertMainView addSubview:self.cancelButton];
//                    [alertMainView addSubview:self.otherButton];
//                }else if (cancelButtonTitle){
//                    CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
//                    UIImage *image3 = rightBtnImage;
//                    UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
//                    [self.cancelButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
//                    [self.cancelButton setTitle:cancelButtonTitle?cancelButtonTitle:otherButtonTitle forState:UIControlStateNormal];
//                    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [self.cancelButton setFrame:CGRectMake(30, buttonTopPosition, 210, 33)];
//                    [self.cancelButton setTag:0];
//                    [alertMainView addSubview:self.cancelButton];
//                }else if (otherButtonTitle){
//                    CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
//                    UIImage *image3 = rightBtnImage;
//                    UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
//                    [self.otherButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
//                    [self.otherButton setTitle:cancelButtonTitle?cancelButtonTitle:otherButtonTitle forState:UIControlStateNormal];
//                    [self.otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [self.otherButton setFrame:CGRectMake(30, buttonTopPosition, 210, 33)];
//                    [self.otherButton setTag:0];
//                    [alertMainView addSubview:self.otherButton];
//                }
//            }
//            return self;
            break;
        
        }
            
        case BBAlertViewStyleLottery:
        {
            
            return [self initWithTitle:title
                               message:message
                              delegate:delegate
                     cancelButtonTitle:cancelButtonTitle
                     otherButtonTitles:otherButtonTitle];
            /*
             self = [super initWithFrame:[UIScreen mainScreen].bounds];
             if (self) {
             [self initData];
             
             _delegate = delegate;
             
             //content view
             CGFloat titleHeight = 42.0f;
             CGFloat bodyHeight = [BBAlertView heightOfString:message]+20;
             CGFloat customViewHeight = 0.0f;
             if (customView) {
             self.customView = customView;
             customViewHeight = customView.height;
             }
             CGFloat buttonPartHeight = 50.0f;
             
             BOOL isNeedUserTextView = bodyHeight > 170;
             bodyHeight = isNeedUserTextView?170:bodyHeight;
             
             CGFloat finalHeight = titleHeight+bodyHeight+customViewHeight+buttonPartHeight+10;
             
             CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height-20;
             self.contentView.frame = CGRectMake(20, (screenHeight-finalHeight)/2.0, 280, finalHeight);
             
             //titleBackgroundImage
             UIImageView *titleBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, finalHeight)];
             UIImage *image1 = [UIImage imageNamed:@"alert_message.png"];
             UIImage *streImage1 = [image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:0];
             titleBgImageView.image = streImage1;
             [self.contentView addSubview:titleBgImageView];
             TT_RELEASE_SAFELY(titleBgImageView);
             
             
             UIFont *titleFont = [UIFont boldSystemFontOfSize:20.0f];
             CGSize titleSize = [title sizeWithFont:titleFont];
             CGFloat titleWidth = titleSize.width<240?titleSize.width:240;
             self.titleLabel.text = title;
             self.titleLabel.font = titleFont;
             self.titleLabel.textColor = [UIColor whiteColor];
             self.titleLabel.adjustsFontSizeToFitWidth = YES;
             CGFloat orgionX = 5+(240-titleWidth)/2+20;
             self.titleLabel.frame = CGRectMake(orgionX, 0, titleWidth, titleHeight);
             [self.contentView addSubview:self.titleLabel];
             
             //bodyLabel
             if (isNeedUserTextView) {
             self.bodyTextView.text = message;
             self.bodyTextView.frame = CGRectMake(10, titleHeight, kContentLabelWidth, bodyHeight);
             self.bodyTextView.font = [UIFont systemFontOfSize:17.0f];
             [self.contentView addSubview:self.bodyTextView];
             }else{
             self.bodyTextLabel.text = message;
             self.bodyTextLabel.frame = CGRectMake(10, titleHeight, kContentLabelWidth, bodyHeight);
             self.bodyTextLabel.font = [UIFont systemFontOfSize:17.0f];
             [self.contentView addSubview:self.bodyTextLabel];
             }
             
             //custom view
             if (customView) {
             customView.frame = CGRectMake(0, titleHeight+bodyHeight+5, customView.width, customView.height);
             [self.contentView addSubview:customView];
             }
             
             //buttons
             if (cancelButtonTitle && otherButtonTitle) {
             CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
             UIImage *image3 = [UIImage imageNamed:@"yellow_button.png"];
             UIImage *image4 = [UIImage imageNamed:@"gay_button.png"];
             UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
             UIImage *streImage4 = [image4 stretchableImageWithLeftCapWidth:image4.size.width/2 topCapHeight:0];
             [self.cancelButton setBackgroundImage:streImage4 forState:UIControlStateNormal];
             [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
             [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [self.cancelButton setFrame:CGRectMake(25, buttonTopPosition, 100, 33)];
             [self.cancelButton setTag:0];
             
             [self.otherButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
             [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
             [self.otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [self.otherButton setFrame:CGRectMake(self.cancelButton.right+30, buttonTopPosition, 100, 33)];
             [self.otherButton setTag:1];
             [self.contentView addSubview:self.cancelButton];
             [self.contentView addSubview:self.otherButton];
             }else if (cancelButtonTitle){
             CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
             UIImage *image3 = [UIImage imageNamed:@"yellow_button.png"];
             UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
             [self.cancelButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
             [self.cancelButton setTitle:cancelButtonTitle?cancelButtonTitle:otherButtonTitle forState:UIControlStateNormal];
             [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [self.cancelButton setFrame:CGRectMake(30, buttonTopPosition, 220, 33)];
             [self.cancelButton setTag:0];
             [self.contentView addSubview:self.cancelButton];
             }else if (otherButtonTitle){
             CGFloat buttonTopPosition = titleHeight+bodyHeight+customViewHeight+10;
             UIImage *image3 = [UIImage imageNamed:@"yellow_button.png"];
             UIImage *streImage3 = [image3 stretchableImageWithLeftCapWidth:image3.size.width/2 topCapHeight:0];
             [self.otherButton setBackgroundImage:streImage3 forState:UIControlStateNormal];
             [self.otherButton setTitle:cancelButtonTitle?cancelButtonTitle:otherButtonTitle forState:UIControlStateNormal];
             [self.otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [self.otherButton setFrame:CGRectMake(30, buttonTopPosition, 220, 33)];
             [self.otherButton setTag:0];
             [self.contentView addSubview:self.otherButton];
             }
             }*/
            return self;
            break;
            
        
        }
            
        case BBAlertViewStyleOrderRedpacket:
        {
            self = [super initWithFrame:[UIScreen mainScreen].bounds];
            if (self) {
                [self initData];
                _delegate = delegate;
                _style = BBAlertViewStyleDefault;
                
                //默认为系统提示
                if (![title length]) {
                    title = L(@"system-error");
                }
                
                //content view
                CGFloat centerY = self.bounds.size.height ;
                CGFloat boxWidth = 280;   //弹出框宽度
                CGFloat contentWidth = 220;
                //                CGRect titleBgFrame = CGRectMake(0, 0, boxWidth, 0);
                CGRect titleFrame = CGRectMake((boxWidth-contentWidth)/2, 25, contentWidth, 15);
                
                //计算content
//                UIFont *titleFont = [UIFont systemFontOfSize:15];
                UIFont *contentFont =[UIFont systemFontOfSize:14];
//                CGSize messageSize = [message sizeWithFont:contentFont
//                                         constrainedToSize:CGSizeMake(contentWidth, 1000)
//                                             lineBreakMode:UILineBreakModeCharacterWrap];
                CGRect messageRect = [message boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)//限制最大的宽度和高度
                                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                                        attributes:@{NSFontAttributeName: contentFont}//传入的字体字典
                                                           context:nil];
                CGFloat contentHeight = messageRect.size.height > 36 ? messageRect.size.height : 36;
                BOOL isNeedUseTextView = NO;
                if (contentHeight > 300)  //content最高240,12行
                {
                    isNeedUseTextView = YES;
                    contentHeight = 300;
                }
                
                CGRect contentFrame = CGRectMake((boxWidth-contentWidth)/2, CGRectGetMaxY(titleFrame) + 25, contentWidth, contentHeight);
                
                //button 1
                CGFloat btnTop = CGRectGetMaxY(contentFrame) + 25;
                CGFloat btnHeight = 44;
                if (cancelButtonTitle && otherButtonTitle) {
                    CGFloat btnWidth = boxWidth / 2;
                    
                    [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0x333333]
                                            forState:UIControlStateNormal];
                    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
                    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
                    [self.cancelButton setFrame:CGRectMake(0, btnTop, btnWidth, btnHeight)];
                    [self.cancelButton setTag:0];
                    
                    
                    [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                                           forState:UIControlStateNormal];
                    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
                    [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
                    [self.otherButton setFrame:CGRectMake(self.cancelButton.right, btnTop, btnWidth, btnHeight)];
                    [self.otherButton setTag:1];
                    
                    //分割线
                    self.seplineH.frame = CGRectMake(0, self.cancelButton.top, self.width, 0.5);
                    self.seplineV.frame = CGRectMake(self.cancelButton.right, self.cancelButton.top, 0.5, btnHeight);
                    
                    
                    [self.contentView addSubview:self.cancelButton];
                    [self.contentView addSubview:self.seplineH];
                    [self.contentView addSubview:self.seplineV];
                    [self.contentView addSubview:self.otherButton];
                    
                }else if (cancelButtonTitle){
                    CGFloat btnWidth = boxWidth;
                    [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
                    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
                    [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0xffaa00]
                                            forState:UIControlStateNormal];
                    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
                    [self.cancelButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
                    [self.cancelButton setTag:0];
                    
                    //分割线
                    self.seplineH.frame = CGRectMake(0, self.cancelButton.top, self.width, 0.5);
                    [self.contentView addSubview:self.cancelButton];
                    [self.contentView addSubview:self.seplineH];
                }else if (otherButtonTitle){
                    CGFloat btnWidth = boxWidth;
                    
                    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
                    [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                                           forState:UIControlStateNormal];
                    [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
                    [self.otherButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
                    [self.otherButton setTag:0];
                    
                    //分割线
                    self.seplineH.frame = CGRectMake(0, self.otherButton.top, self.width, 0.5);
                    [self.contentView addSubview:self.seplineH];
                    [self.contentView addSubview:self.otherButton];
                    
                }
                
                CGFloat boxHeight = 25 + titleFrame.size.height + 25 + contentHeight + 25 + btnHeight;
                CGRect boxFrame = CGRectMake((self.width-boxWidth)/2, (centerY-boxHeight)/2, boxWidth, boxHeight);
                self.contentView.frame = boxFrame;
                self.contentView.clipsToBounds = YES;
                self.contentView.layer.cornerRadius = 8.0f;
                self.contentView.backgroundColor = [UIColor whiteColor];
                
                //titleBg imageView
                //        UIImageView *titleBg = [[UIImageView alloc] init];
                //        titleBg.layer.shadowColor = [UIColor grayColor].CGColor;
                //        titleBg.layer.shadowOffset = CGSizeMake(0.7, 0.7);
                //        titleBg.layer.shadowOpacity = 0.8;
                //        titleBg.clipsToBounds = NO;
                //        titleBg.frame = titleBgFrame;
                //        titleBg.image = [UIImage imageNamed:@"system_nav_bg.png"];
                //        [self.contentView addSubview:titleBg];
                //        TT_RELEASE_SAFELY(titleBg);
                
                //titleLabel
                self.titleLabel.text = title;
                self.titleLabel.frame = titleFrame;
                self.titleLabel.textColor = [UIColor colorWithRGBHex:0x333333];
                self.titleLabel.font = [UIFont systemFontOfSize:15];
                [self.contentView addSubview:self.titleLabel];
                
                //message
                if (isNeedUseTextView) {
                    self.bodyTextView.text = message;
                    self.bodyTextView.frame = contentFrame;
                    self.bodyTextView.font = contentFont;
                    self.bodyTextView.textColor = [UIColor colorWithRGBHex:0x333333];
                    [self.contentView addSubview:self.bodyTextView];
                }else{
                    self.bodyTextLabel.text = message;
                    self.bodyTextLabel.frame = contentFrame;
                    self.bodyTextLabel.font = contentFont;
                    self.bodyTextLabel.textColor = [UIColor colorWithRGBHex:0x333333];
                    [self.contentView addSubview:self.bodyTextLabel];
                }
            
            }
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = 2;
            return self;
            break;
        }
        default:
            break;
    }
    return [super initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithContentY:(NSInteger)contentY
                 Title:(NSString *)title
               message:(NSString *)message
              delegate:(id <BBAlertViewDelegate>)delegate
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitle
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initData];
        _delegate = delegate;
        _style = BBAlertViewStyleDefault;
        //默认为系统提示
        if (![title length]) {
            title = L(@"system-error");
        }
        //content view
        CGFloat centerY = self.bounds.size.height ;
        CGFloat boxWidth = 280;   //弹出框宽度
        CGFloat contentWidth = 220;
        CGRect titleFrame = CGRectMake((boxWidth-contentWidth)/2, 25, contentWidth, 20);
        
        //计算content
        UIFont *contentFont = [UIFont systemFontOfSize:14];
//        CGSize messageSize = [message sizeWithFont:contentFont
//                                 constrainedToSize:CGSizeMake(contentWidth, 1000)
//                                     lineBreakMode:UILineBreakModeCharacterWrap];
        CGRect messageRect = [message boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)//限制最大的宽度和高度
                                                   options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                                attributes:@{NSFontAttributeName: contentFont}//传入的字体字典
                                                   context:nil];
        CGFloat contentHeight = messageRect.size.height > 36 ? messageRect.size.height : 36;
        BOOL isNeedUseTextView = NO;
        if (contentHeight > 300) {
            isNeedUseTextView = YES;
            contentHeight = 300;
        }
        CGRect contentFrame = CGRectMake((boxWidth-contentWidth)/2, CGRectGetMaxY(titleFrame)+25, contentWidth, contentHeight);
        
        //button 1
        CGFloat btnTop = CGRectGetMaxY(contentFrame) + 25;
        CGFloat btnHeight = 44;
        if (cancelButtonTitle && otherButtonTitle) {
            CGFloat btnWidth = boxWidth / 2;
            
            [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0x333333]
                                    forState:UIControlStateNormal];
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [self.cancelButton setFrame:CGRectMake(0, btnTop, btnWidth, btnHeight)];
            [self.cancelButton setTag:0];
            
            
            [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                                   forState:UIControlStateNormal];
            self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            [self.otherButton setFrame:CGRectMake(self.cancelButton.right, btnTop, btnWidth, btnHeight)];
            [self.otherButton setTag:1];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.cancelButton.top, self.width, 0.5);
            self.seplineV.frame = CGRectMake(self.cancelButton.right, self.cancelButton.top, 0.5, btnHeight);
            
            
            [self.contentView addSubview:self.cancelButton];
            [self.contentView addSubview:self.seplineH];
            [self.contentView addSubview:self.seplineV];
            [self.contentView addSubview:self.otherButton];
            
        }else if (cancelButtonTitle){
            CGFloat btnWidth = boxWidth;
            [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0xffaa00]
                                    forState:UIControlStateNormal];
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [self.cancelButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
            [self.cancelButton setTag:0];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.cancelButton.top, self.width, 0.5);
            [self.contentView addSubview:self.cancelButton];
            [self.contentView addSubview:self.seplineH];
        }else if (otherButtonTitle){
            CGFloat btnWidth = boxWidth;
            
            self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.otherButton setTitleColor:[UIColor colorWithRGBHex:0xffffff]
                                   forState:UIControlStateNormal];
            [self.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            [self.otherButton setFrame:CGRectMake((boxWidth - btnWidth) / 2, btnTop, btnWidth, btnHeight)];
            [self.otherButton setTag:0];
            
            //分割线
            self.seplineH.frame = CGRectMake(0, self.otherButton.top, self.width, 0.5);
            [self.contentView addSubview:self.seplineH];
            [self.contentView addSubview:self.otherButton];
            
        }
        
        CGFloat boxHeight = 25 + titleFrame.size.height + 25 + contentHeight + 25 + btnHeight;
        CGRect boxFrame = CGRectMake((self.width-boxWidth)/2, (centerY-boxHeight)/2, boxWidth, boxHeight);
        self.contentView.frame = boxFrame;
        self.contentView.top = self.contentView.top+contentY;
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.cornerRadius = 8.0f;
        self.contentView.backgroundColor = [UIColor whiteColor];
        //titleLabel
        self.titleLabel.text = title;
        self.titleLabel.frame = titleFrame;
        self.titleLabel.textColor = [UIColor colorWithRGBHex:0x33333];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        //message
        if (isNeedUseTextView) {
            self.bodyTextView.text = message;
            self.bodyTextView.frame = contentFrame;
            self.bodyTextView.font = contentFont;
            self.bodyTextView.textColor = [UIColor colorWithRGBHex:0x333333];
            [self.contentView addSubview:self.bodyTextView];
        }else{
            self.bodyTextLabel.text = message;
            self.bodyTextLabel.frame = contentFrame;
            self.bodyTextLabel.font = contentFont;
            self.bodyTextLabel.textColor = [UIColor colorWithRGBHex:0x333333];
            [self.contentView addSubview:self.bodyTextLabel];
        }
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
    }
    return self;
}

- (BOOL)isVisible
{
    return _visible;
}

- (void)drawRect:(CGRect)rect
{
    if (_dimBackground) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 0.0f};
        CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.40f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace);
        
        //Gradient center
        CGPoint gradCenter = self.contentView.center;
        //Gradient radius
        float gradRadius = 320 ;
        //Gradient draw
        CGContextDrawRadialGradient (context, gradient, gradCenter,
                                     0, gradCenter, gradRadius,
                                     kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }
}

#pragma mark -
#pragma mark orientation

- (void)registerObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationDidChange:(NSNotification*)notify
{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([self shouldRotateToOrientation:orientation]) {
        if ([_delegate respondsToSelector:@selector(didRotationToInterfaceOrientation:view:alertView:)]) {
            [_delegate didRotationToInterfaceOrientation:UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) view:_customView alertView:self];
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation
{
    BOOL result = NO;
    if (_orientation != orientation) {
        result = (orientation == UIInterfaceOrientationPortrait ||
                  orientation == UIInterfaceOrientationPortraitUpsideDown ||
                  orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight);
    }
    
    return result;
}

- (void)sizeToFitOrientation:(BOOL)transform
{
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self sizeToFit];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setCenter:CGPointMake(screenSize.width/2, screenSize.height/2)];
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5f);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2.0f);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}


#pragma mark -
#pragma mark view getters

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UILabel *)bodyTextLabel
{
    if (!_bodyTextLabel) {
        _bodyTextLabel = [[UILabel alloc] init];
        _bodyTextLabel.numberOfLines = 0;
        _bodyTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _bodyTextLabel.textAlignment = _contentAlignment;
        _bodyTextLabel.backgroundColor = [UIColor clearColor];
    }
    return _bodyTextLabel;
}

- (TTTAttributedLabel *)bodyAttributeTextLabel
{
    if (!_bodyAttributeTextLabel) {
        _bodyAttributeTextLabel = [[TTTAttributedLabel alloc] init];
        _bodyAttributeTextLabel.numberOfLines = 0;
        _bodyAttributeTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _bodyAttributeTextLabel.textAlignment = _contentAlignment;
        _bodyAttributeTextLabel.textColor = [UIColor colorWithRGBHex:0x353d44];
        _bodyAttributeTextLabel.backgroundColor = [UIColor clearColor];
        _bodyAttributeTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    }
    return _bodyAttributeTextLabel;
}


- (UITextView *)bodyTextView
{
    if (!_bodyTextView) {
        _bodyTextView = [[UITextView alloc] init];
        _bodyTextView.textAlignment = _contentAlignment;
        _bodyTextView.bounces = NO;
        _bodyTextView.backgroundColor = [UIColor clearColor];
        _bodyTextView.editable = NO;
    }
    return _bodyTextView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIButton *)cancelButton{
    
    if (!_cancelButton) {
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:L(@"Ok") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
    
}


- (UIButton *)otherButton{
    
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherButton.backgroundColor = [UIColor colorWithRGBHex:0xff6600];
        [_otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_otherButton setTitle:L(@"Ok") forState:UIControlStateNormal];
        [_otherButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _otherButton;
    
}

- (UIView *)seplineH
{
    if (!_seplineH)
    {
        _seplineH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _seplineH.backgroundColor = [UIColor colorWithRGBHex:0xdcdcdc];
    }
    
    return _seplineH;
}

- (UIView *)seplineV
{
    if (!_seplineV)
    {
        _seplineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 44)];
        _seplineV.backgroundColor = [UIColor colorWithRGBHex:0xdcdcdc];
        _seplineV.hidden = YES;
    }
    
    return _seplineV;
}

-(UIImageView *)imageViewIcon{
    
    if (!_imageViewIcon) {
        
        _imageViewIcon = [[UIImageView alloc] init];
        
    }
    
    return _imageViewIcon;
}

#pragma mark -
#pragma mark block setter

- (void)setCancelBlock:(BBBasicBlock)block
{
    _cancelBlock = [block copy];
}

- (void)setConfirmBlock:(BBBasicBlock)block
{
    _confirmBlock = [block copy];
}

#pragma mark -
#pragma mark button action

- (void)buttonTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    clickedButtonIndex = tag;
    
    if ([_delegate conformsToProtocol:@protocol(BBAlertViewDelegate)]) {
        
        if ([_delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
            
            [_delegate alertView:self willDismissWithButtonIndex:tag];
        }
    }
    
    if (button == self.cancelButton) {
        if (_cancelBlock) {
            _cancelBlock();
        }
        [self dismiss];
    }
    else if (button == self.otherButton)
    {
        if (_confirmBlock) {
            _confirmBlock();
        }
        if (_shouldDismissAfterConfirm) {
            [self dismiss];
        }
    }
    
}

#pragma mark -
#pragma mark lify cycle

- (void)show
{
    if (_visible) {
        return;
    }
    _visible = YES;
    
    [self registerObservers];//添加消息，在设备发生旋转时会有相应的处理
    [self sizeToFitOrientation:NO];
    
    
    //如果栈中没有alertview,就表示maskWindow没有弹出，所以弹出maskWindow
    if (![BBAlertView getStackTopAlertView]) {
        [BBAlertView presentMaskWindow];
    }
    
    //如果有背景图片，添加背景图片
    if (nil != self.backgroundView && ![[gMaskWindow subviews] containsObject:self.backgroundView]) {
        [gMaskWindow addSubview:self.backgroundView];
    }
    //将alertView显示在window上
    [BBAlertView addAlertViewOnMaskWindow:self];
    
    self.alpha = 1.0;
    
    //alertView弹出动画
    [self bounce0Animation];
}

- (void)dismiss
{
    if (!_visible) {
        return;
    }
    _visible = NO;
    
    UIView *__bgView = self->_backgroundView;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissAlertView)];
    self.alpha = 0;
    [UIView commitAnimations];
    
    if (__bgView && [[gMaskWindow subviews] containsObject:__bgView]) {
        [__bgView removeFromSuperview];
    }
}

- (void)dismissAlertView{
    [BBAlertView removeAlertViewFormMaskWindow:self];
    
    // If there are no dialogs visible, dissmiss mask window too.
    if (![BBAlertView getStackTopAlertView]) {
        [BBAlertView dismissMaskWindow];
    }
    
    if (_style != BBAlertViewStyleCustomView) {
        if ([_delegate conformsToProtocol:@protocol(BBAlertViewDelegate)]) {
            if ([_delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
                [_delegate alertView:self didDismissWithButtonIndex:clickedButtonIndex];
            }
        }
    }
    
    [self removeObservers];
}


+ (void)presentMaskWindow{
    
    if (!gMaskWindow) {
        gMaskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        //edited by gjf 修改alertview leavel
        gMaskWindow.windowLevel = UIWindowLevelStatusBar + 300;
        gMaskWindow.backgroundColor = [UIColor clearColor];
        gMaskWindow.hidden = YES;
        
        // FIXME: window at index 0 is not awalys previous key window.
        gPreviouseKeyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [gMaskWindow makeKeyAndVisible];
        
        // Fade in background
        gMaskWindow.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        gMaskWindow.alpha = 1;
        [UIView commitAnimations];
    }
}

+ (void)dismissMaskWindow{
    // make previouse window the key again
    if (gMaskWindow) {
        [gPreviouseKeyWindow makeKeyWindow];
        gPreviouseKeyWindow = nil;
        
        gMaskWindow = nil;
    }
}

+ (BBAlertView *)getStackTopAlertView{
    BBAlertView *topItem = nil;
    if (0 != [gAlertViewStack count]) {
        topItem = [gAlertViewStack lastObject];
    }
    
    return topItem;
}

+ (void)addAlertViewOnMaskWindow:(BBAlertView *)alertView{
    if (!gMaskWindow ||[gMaskWindow.subviews containsObject:alertView]) {
        return;
    }
    
    [gMaskWindow addSubview:alertView];
    alertView.hidden = NO;
    
    BBAlertView *previousAlertView = [BBAlertView getStackTopAlertView];
    if (previousAlertView) {
        previousAlertView.hidden = YES;
    }
    [BBAlertView pushAlertViewInStack:alertView];
}

+ (void)removeAlertViewFormMaskWindow:(BBAlertView *)alertView{
    if (!gMaskWindow || ![gMaskWindow.subviews containsObject:alertView]) {
        return;
    }
    
    [alertView removeFromSuperview];
    alertView.hidden = YES;
    
    [BBAlertView popAlertViewFromStack];
    BBAlertView *previousAlertView = [BBAlertView getStackTopAlertView];
    if (previousAlertView) {
        previousAlertView.hidden = NO;
        [previousAlertView bounce0Animation];
    }
}

+ (void)pushAlertViewInStack:(BBAlertView *)alertView{
    if (!gAlertViewStack) {
        gAlertViewStack = [[NSMutableArray alloc] init];
    }
    [gAlertViewStack addObject:alertView];
}


+ (void)popAlertViewFromStack{
    if (![gAlertViewStack count]) {
        return;
    }
    [gAlertViewStack removeLastObject];
    
    if ([gAlertViewStack count] == 0) {
        gAlertViewStack = nil;
    }
}


#pragma mark -
#pragma mark animation

- (void)bounce0Animation{
    self.contentView.transform = CGAffineTransformScale([self transformForOrientation], 0.001f, 0.001f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationDidStop)];
    self.contentView.transform = CGAffineTransformScale([self transformForOrientation], 1.1f, 1.1f);
    [UIView commitAnimations];
}

- (void)bounce1AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationDidStop)];
    self.contentView.transform = CGAffineTransformScale([self transformForOrientation], 0.9f, 0.9f);
    [UIView commitAnimations];
}
- (void)bounce2AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceDidStop)];
    self.contentView.transform = [self transformForOrientation];
    [UIView commitAnimations];
}

- (void)bounceDidStop{
    
}

#pragma mark -
#pragma mark tools

+ (CGFloat)heightOfString:(NSString *)message
{
    if (message == nil || [message isEqualToString:@""]) {
        return 20.0f;
    }
//    CGSize messageSize = [message sizeWithFont:[UIFont systemFontOfSize:16.0]
//                             constrainedToSize:CGSizeMake(kContentLabelWidth, 1000)
//                                 lineBreakMode:UILineBreakModeCharacterWrap];
    CGRect messageRect = [message boundingRectWithSize:CGSizeMake(kContentLabelWidth, CGFLOAT_MAX)//限制最大的宽度和高度
                                               options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0]}//传入的字体字典
                                               context:nil];
    
    return messageRect.size.height+10.0;
}

@end
