//
//  SPPageMenu.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26. https://github.com/SPStore/SPPageMenu
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "SPPageMenu.h"

#define tagBaseValue 100
#define scrollViewContentOffset @"contentOffset"

#define maxTextScale 0.3

@interface SPPageMenuLine : UIImageView
@property (nonatomic, copy) void(^hideBlock)();

@end

@implementation SPPageMenuLine

// 当外界设置隐藏和alpha值时，让pageMenu重新布局
- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (self.hideBlock) {
        self.hideBlock();
    }
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    if (self.hideBlock) {
        self.hideBlock();
    }
}

@end

@interface SPItem : UIButton
@property (nonatomic, assign) CGFloat imageRatio;
@end

@implementation SPItem

- (void)setHighlighted:(BOOL)highlighted {}

@end

@interface SPPageMenu()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIImageView *tracker;
@property (nonatomic, assign) CGFloat trackerHeight;
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *dividingLine;
@property (nonatomic, weak) UIScrollView *itemScrollView;
@property (nonatomic, weak) SPItem *functionButton;
@property (nonatomic, weak) CALayer *shadowLine;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) SPItem *selectedButton;
@property (nonatomic, strong) NSMutableDictionary *setupWidths;
@property (nonatomic, assign) BOOL insert;
// 起始偏移量,为了判断滑动方向
@property (nonatomic, assign) CGFloat beginOffsetX;


@end

@implementation SPPageMenu


#pragma mark - public

+ (instancetype)pageMenuWithFrame:(CGRect)frame {
    SPPageMenu *pageMenu = [[SPPageMenu alloc] initWithFrame:frame];
    return pageMenu;
}

- (void)setItems:(NSArray *)items selectedItemIndex:(NSUInteger)selectedItemIndex {
    _items = items.copy;
    _selectedItemIndex = selectedItemIndex;
    self.insert = NO;
    for (int i = 0; i < items.count; i++) {
        id object = items[i];
        NSAssert([object isKindOfClass:[NSString class]] || [object isKindOfClass:[UIImage class]], @"items中的元素只能是NSString或UIImage类型");
        [self addButton:i object:object animated:NO];
    }

    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    if (self.buttons.count) {
        // 默认选中selectedItemIndex对应的按钮
        SPItem *selectedButton = [self.buttons objectAtIndex:selectedItemIndex];
        [self buttonInPageMenuClicked:selectedButton];
        [self.itemScrollView insertSubview:self.tracker atIndex:0];
    }
}

- (void)insertItemWithTitle:(NSString *)title atIndex:(NSUInteger)itemIndex animated:(BOOL)animated {
    self.insert = YES;
    if (itemIndex > self.items.count) {return;}
    NSMutableArray *titleArr = self.items.mutableCopy;
    [titleArr insertObject:title atIndex:itemIndex];
    self.items = titleArr;
    [self addButton:itemIndex object:title animated:animated];
    if (itemIndex <= self.selectedItemIndex) {
        _selectedItemIndex += 1;
    }
}

- (void)insertItemWithImage:(UIImage *)image atIndex:(NSUInteger)itemIndex animated:(BOOL)animated {
    self.insert = YES;
    if (itemIndex > self.items.count) {return;}
    NSMutableArray *objects = self.items.mutableCopy;
    [objects insertObject:image atIndex:itemIndex];
    self.items = objects;
    [self addButton:itemIndex object:image animated:animated];
    if (itemIndex <= self.selectedItemIndex) {
        _selectedItemIndex += 1;
    }
}

- (void)removeItemAtIndex:(NSUInteger)itemIndex animated:(BOOL)animated {
    if (itemIndex > self.items.count) {return;}
    // 被删除的按钮之后的按钮需要修改tag值
    for (SPItem *button in self.buttons) {
        if (button.tag-tagBaseValue > itemIndex) {
            button.tag = button.tag - 1;
        }
    }
    if (self.items.count) {
        NSMutableArray *objects = self.items.mutableCopy;
        id object = [objects objectAtIndex:itemIndex];
        [objects removeObject:object];
        self.items = objects;
    }
    if (itemIndex < self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:itemIndex];
        if (button == self.selectedButton) { // 如果删除的正是选中的item，删除之后，选中的按钮切换为上一个item
            self.selectedItemIndex = itemIndex > 0 ? itemIndex-1 : itemIndex;
        }
        [self.buttons removeObject:button];
        [button removeFromSuperview];
    }
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    } else {
        [self setNeedsLayout];
    }
    
}

- (void)removeAllItems {
    NSMutableArray *objects = self.items.mutableCopy;
    [objects removeAllObjects];
    self.items = objects;
    self.items = nil;
    
    for (int i = 0; i < self.buttons.count; i++) {
        SPItem *button = self.buttons[i];
        [button removeFromSuperview];
    }
    
    [self.buttons removeAllObjects];
    
    self.selectedButton = nil;
    self.selectedItemIndex = 0;
    
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forItemAtIndex:(NSUInteger)itemIndex {
    if (itemIndex < self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:itemIndex];
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (NSString *)titleForItemAtIndex:(NSUInteger)itemIndex {
    if (itemIndex < self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:itemIndex];
        return button.currentTitle;
    }
    return nil;
}

- (void)setImage:(UIImage *)image forItemAtIndex:(NSUInteger)itemIndex {
    if (itemIndex < self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:itemIndex];
        [button setTitle:nil forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateNormal];
    }
}

- (UIImage *)imageForItemAtIndex:(NSUInteger)itemIndex {
    if (itemIndex < self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:itemIndex];
        return button.currentImage;
    }
    return nil;
}

- (void)setTitle:(NSString *)title forItemIndex:(NSUInteger)itemIndex {
    if (itemIndex < self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:itemIndex];
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setFunctionButtonTitle:(NSString *)title  forState:(UIControlState)state {
    [self.functionButton setTitle:title forState:state];
}


- (void)setEnabled:(BOOL)enaled forItemAtIndex:(NSUInteger)itemIndex {
    if (itemIndex < self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:itemIndex];
        [button setEnabled:enaled];
    }
}

- (BOOL)enabledForItemAtIndex:(NSUInteger)itemIndex {
    if (self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:itemIndex];
        return button.enabled;
    }
    return YES;
}

- (void)setWidth:(CGFloat)width forItemAtIndex:(NSUInteger)itemIndex {
    [self.setupWidths setObject:@(width) forKey:[NSString stringWithFormat:@"%zd",itemIndex]];
}

- (CGFloat)widthForItemAtIndex:(NSUInteger)itemIndex {
    CGFloat setupWidth = [[self.setupWidths objectForKey:[NSString stringWithFormat:@"%zd",itemIndex]] floatValue];
    if (setupWidth) {
        return setupWidth;
    } else {
        if (itemIndex < self.buttons.count) {
            SPItem *button = [self.buttons objectAtIndex:itemIndex];
            return button.bounds.size.width;
        }
    }
    return 0;
}

- (void)moveTrackerFollowScrollView:(UIScrollView *)scrollView {
    
    // 说明外界传进来了一个scrollView,如果外界传进来了，pageMenu会观察该scrollView的contentOffset自动处理跟踪器的跟踪
    if (self.bridgeScrollView == scrollView) { return; }
    
    [self beginMoveTrackerFollowScrollView:scrollView];
}
 

#pragma amrk - private

- (void)addButton:(NSInteger)index object:(id)object animated:(BOOL)animated {
    // 如果是插入，需要改变已有button的tag值
    for (SPItem *button in self.buttons) {
        if (button.tag-tagBaseValue >= index) {
            button.tag = button.tag + 1;
        }
    }
    SPItem *button = [SPItem buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:_unSelectedItemTitleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.cornerRadius = 12.5;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [button addTarget:self action:@selector(buttonInPageMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tagBaseValue + index;
    if ([object isKindOfClass:[NSString class]]) {
        [button setTitle:object forState:UIControlStateNormal];
    } else {
        [button setImage:object forState:UIControlStateNormal];
    }
    if (self.insert) {
        [self.itemScrollView insertSubview:button atIndex:index+1];
        if (!self.buttons.count) {
            [self buttonInPageMenuClicked:button];
        }
    } else {
        [self.itemScrollView insertSubview:button atIndex:index];
    }
    [self.buttons insertObject:button atIndex:index];
    
    // setNeedsLayout会标记为需要刷新,layoutIfNeeded只有在有标记的情况下才会立即调用layoutSubViews,当然标记为刷新并非只有调用setNeedsLayout,如frame改变，addSubView等都会标记为刷新
    
    if (self.insert && animated) { // 是插入的新按钮,且需要动画
        // 取出上一个按钮
        SPItem *lastButton;
        if (index > 0) {
            lastButton = self.buttons[index-1];
        }
        // 先给给初始的origin，按钮将会从这个origin开始动画
        button.frame = CGRectMake(CGRectGetMaxX(lastButton.frame)+_itemPadding*0.5, 0, 0, 0);
        [UIView animateWithDuration:0.5 animations:^{
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self initialize];
        self.backgroundColor = [UIColor whiteColor];
       
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    _itemPadding = 15.5;
    _itemTitleFont = [UIFont systemFontOfSize:14];
    _selectedItemTitleColor = [UIColor colorWithHex:@"#FFFFFF"];
    _unSelectedItemTitleColor = [UIColor blackColor];
    _trackerHeight = 3;
    _contentInset = UIEdgeInsetsZero;
    _selectedItemIndex = 0;
    _showFuntionButton = NO;
    _needTextColorGradients = NO;
    
    // 必须先添加分割线，再添加backgroundView;假如先添加backgroundView,那也就意味着backgroundView是SPPageMenu的第一个子控件,而scrollView又是backgroundView的第一个子控件,当外界在由导航控制器管理的控制器中将SPPageMenu添加为第一个子控件时，控制器会不断的往下遍历第一个子控件的第一个子控件，直到找到为scrollView为止,一旦发现某子控件的第一个子控件为scrollView,会将scrollView的内容往下偏移64;这时控制器中必须设置self.automaticallyAdjustsScrollViewInsets = NO;为了避免这样做，这里将分割线作为第一个子控件
    
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.layer.masksToBounds = YES;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;

    UIScrollView *itemScrollView = [[UIScrollView alloc] init];
    itemScrollView.showsVerticalScrollIndicator = NO;
    itemScrollView.showsHorizontalScrollIndicator = NO;
    [backgroundView addSubview:itemScrollView];
    _itemScrollView = itemScrollView;
    
    SPItem *functionButton = [SPItem buttonWithType:UIButtonTypeCustom];
    functionButton.backgroundColor = [UIColor whiteColor];
    [functionButton setTitle:@"＋" forState:UIControlStateNormal];
    [functionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    functionButton.hidden = !_showFuntionButton;
    [backgroundView addSubview:functionButton];
    _functionButton = functionButton;
    
    // 这个layer的作用是为functionButton制造阴影效果,如果直接在functionButton上加阴影，无论怎么设置，至少都会2条边有阴影，这里要实现只要一条边(左边)有阴影,故在backgroundView上加一个layer，这样其余边可以通过backgroundView.layer.masksToBounds剪切掉
    CALayer *shadowLine = [CALayer layer];
    shadowLine.backgroundColor = [UIColor whiteColor].CGColor;
    shadowLine.shadowColor = [UIColor blackColor].CGColor;
    shadowLine.shadowOffset = CGSizeMake(0, 0);
    shadowLine.shadowRadius = 2;
    shadowLine.shadowOpacity = 0.5; // 默认是0,为0的话不会显示阴影
    [backgroundView.layer insertSublayer:shadowLine below:functionButton.layer];
    shadowLine.hidden = !_showFuntionButton;
    _shadowLine = shadowLine;
    
    [self layoutIfNeeded];
}

// 按钮点击方法
- (void)buttonInPageMenuClicked:(SPItem *)sender {
    [self.selectedButton setTitleColor:_unSelectedItemTitleColor forState:UIControlStateNormal];
    self.selectedButton.backgroundColor = [UIColor whiteColor];
    _selectedItemTitleColor = [UIColor whiteColor];
    sender.backgroundColor = KColorBlueText;
    [sender setTitleColor:_selectedItemTitleColor forState:UIControlStateNormal];
    CGFloat fromIndex = self.selectedButton ? self.selectedButton.tag-tagBaseValue : sender.tag - tagBaseValue;
    CGFloat toIndex = sender.tag - tagBaseValue;
    // 更新下item对应的下标,必须在代理之前，否则外界在代理方法中拿到的不是最新的,必须用下划线，用self.会造成死循环
    _selectedItemIndex = toIndex;
    [self delegatePerformMethodWithFromIndex:fromIndex toIndex:toIndex];

    [self moveItemScrollViewWithSelectedButton:sender];
        if (fromIndex != toIndex) { // 如果相等，说明是第一次进来，或者2次点了同一个，此时不需要动画
            [self moveTrackerWithSelectedButton:sender];
        }
    
    self.selectedButton = sender;
}

// 点击button让itemScrollView发生偏移
- (void)moveItemScrollViewWithSelectedButton:(SPItem *)selectedButton {
    if (CGRectEqualToRect(self.backgroundView.frame, CGRectZero)) {
        return;
    }
    // 转换点的坐标位置
    CGPoint centerInPageMenu = [self.backgroundView convertPoint:selectedButton.center toView:self];
    // CGRectGetMidX(self.backgroundView.frame)指的是屏幕水平中心位置，它的值是固定不变的
    CGFloat offSetX = centerInPageMenu.x - CGRectGetMidX(self.backgroundView.frame);
    
    // itemScrollView的容量宽与自身宽之差(难点)
    CGFloat maxOffsetX = self.itemScrollView.contentSize.width - self.itemScrollView.frame.size.width;
    // 如果选中的button中心x值小于或者等于itemScrollView的中心x值，或者itemScrollView的容量宽度小于itemScrollView本身，此时点击button时不发生任何偏移，置offSetX为0
    if (offSetX <= 0 || maxOffsetX <= 0) {
        offSetX = 0;
    }
    // 如果offSetX大于maxOffsetX,说明itemScrollView已经滑到尽头，此时button也发生任何偏移了
    else if (offSetX > maxOffsetX){
        offSetX = maxOffsetX;
    }

    [self.itemScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    
}

// 移动跟踪器
- (void)moveTrackerWithSelectedButton:(UIButton *)selectedButton {
    
    [UIView animateWithDuration:0.25 animations:^{
        [self resetSetupTrackerFrameWithSelectedButton:selectedButton];
    }];
}

// 执行代理方法
- (void)delegatePerformMethodWithFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageMenu:itemSelectedFromIndex:toIndex:)]) {
        [self.delegate pageMenu:self itemSelectedFromIndex:fromIndex toIndex:toIndex];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(pageMenu:itemSelectedAtIndex:)]) {
        [self.delegate pageMenu:self itemSelectedAtIndex:toIndex];
    }
}

// 功能按钮的点击方法
- (void)functionButtonClicked:(SPItem *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageMenu:functionButtonClicked:)]) {
        [self.delegate pageMenu:self functionButtonClicked:sender];
    }
}

- (void)beginMoveTrackerFollowScrollView:(UIScrollView *)scrollView {

    // 这个if条件的意思就是没有滑动的意思
    if (!scrollView.dragging && !scrollView.decelerating) {return;}

    // 当滑到边界时，继续通过scrollView的bouces效果滑动时，直接return
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width-scrollView.bounds.size.width) {
        return;
    }
    
    static int i = 0;
    if (i == 0) {
         // 记录起始偏移量，注意千万不能每次都记录，只需要第一次纪录即可。
        // 初始值不能等于scrollView.contentOffset.x,因为第一次进入此方法时，scrollView.contentOffset.x已经有偏移并非刚开始的偏移
        _beginOffsetX = scrollView.bounds.size.width * self.selectedItemIndex;
        i = 1;
    }
    // 当前偏移量
    CGFloat currentOffSetX = scrollView.contentOffset.x;
    // 偏移进度
    CGFloat offsetProgress = currentOffSetX / scrollView.bounds.size.width;
    CGFloat progress = offsetProgress - floor(offsetProgress);

    NSInteger fromIndex;
    NSInteger toIndex;
    
    // 以下注释的“拖拽”一词很准确，不可说成滑动，例如:当手指向右拖拽，还未拖到一半时就松开手，接下来scrollView则会往回滑动，这个往回，就是向左滑动，这也是_beginOffsetX不可时刻纪录的原因，如果时刻纪录，那么往回(向左)滑动时会被视为“向左拖拽”,然而，这个往回却是由“向右拖拽”而导致的
    if (currentOffSetX - _beginOffsetX > 0) { // 向左拖拽了
        // 求商,获取上一个item的下标
        fromIndex = currentOffSetX / scrollView.bounds.size.width;
        // 当前item的下标等于上一个item的下标加1
        toIndex = fromIndex + 1;
        if (toIndex >= self.buttons.count) {
            toIndex = fromIndex;
        }
    } else if (currentOffSetX - _beginOffsetX < 0) {  // 向右拖拽了
        toIndex = currentOffSetX / scrollView.bounds.size.width;
        fromIndex = toIndex + 1;
        progress = 1.0 - progress;

    } else {
        progress = 1.0;
        fromIndex = self.selectedItemIndex;
        toIndex = fromIndex;
    }

    if (currentOffSetX == scrollView.bounds.size.width * fromIndex) {// 滚动停止了
        progress = 1.0;
        toIndex = fromIndex;
    }

    // 如果滚动停止，直接通过点击按钮选中toIndex对应的item
    if (currentOffSetX == scrollView.bounds.size.width*toIndex) { // 这里toIndex==fromIndex
        i = 0;
        // 这一次赋值起到2个作用，一是点击toIndex对应的按钮，走一遍代理方法,二是弥补跟踪器的结束跟踪，因为本方法是在scrollViewDidScroll中调用，可能离滚动结束还有一丁点的距离，本方法就不调了,最终导致外界还要在scrollView滚动结束的方法里self.selectedItemIndex进行赋值,直接在这里赋值可以让外界不用做此操作
        self.selectedItemIndex = toIndex;
        // 要return，点击了按钮，跟踪器自然会跟着被点击的按钮走
        return;
    }
    // 没有关闭跟踪模式
    if (!self.closeTrackerFollowingMode) {
        [self moveTrackerWithProgress:progress fromIndex:fromIndex toIndex:toIndex currentOffsetX:currentOffSetX beginOffsetX:_beginOffsetX];
    }
}

- (void)moveTrackerWithProgress:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex currentOffsetX:(CGFloat)currentOffsetX beginOffsetX:(CGFloat)beginOffsetX {
    // 下面才开始真正滑动跟踪器，上面都是做铺垫
    UIButton *fromButton = self.buttons[fromIndex];
    UIButton *toButton = self.buttons[toIndex];
    
    // 2个按钮之间的距离
    CGFloat xDistance = toButton.center.x - fromButton.center.x;
    // 2个按钮宽度的差值
    CGFloat wDistance = toButton.frame.size.width - fromButton.frame.size.width;
    
    CGRect newFrame = self.tracker.frame;
    CGPoint newCenter = self.tracker.center;
        // 这种样式的计算比较复杂,有个很关键的技巧，就是参考progress分别为0、0.5、1时的临界值
        // 原先的x值
        CGFloat originX = fromButton.frame.origin.x+(fromButton.frame.size.width-fromButton.titleLabel.font.pointSize)*0.5;
        // 原先的宽度
        CGFloat originW = fromButton.titleLabel.font.pointSize;
        if (currentOffsetX - _beginOffsetX >= 0) { // 向左拖拽了
            if (progress < 0.5) {
                newFrame.origin.x = originX; // x值保持不变
                newFrame.size.width = originW + xDistance * progress * 2;
            } else {
                newFrame.origin.x = originX + xDistance * (progress-0.5) * 2;
                newFrame.size.width = originW + xDistance - xDistance * (progress-0.5) * 2;
            }
        } else { // 向右拖拽了
            // 此时xDistance为负
            if (progress < 0.5) {
                newFrame.origin.x = originX + xDistance * progress * 2;
                newFrame.size.width = originW - xDistance * progress * 2;
            } else {
                newFrame.origin.x = originX + xDistance;
                newFrame.size.width = originW - xDistance + xDistance * (progress-0.5) * 2;
            }
        }
        
        self.tracker.frame = newFrame;
 
}


// 获取颜色的RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (void)zoomForTitleWithProgress:(CGFloat)progress fromButton:(UIButton *)fromButton toButton:(UIButton *)toButton {
    fromButton.transform = CGAffineTransformMakeScale((1 - progress) * maxTextScale + 1, (1 - progress) * maxTextScale + 1);
    toButton.transform = CGAffineTransformMakeScale(progress * maxTextScale + 1, progress * maxTextScale + 1);

}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.bridgeScrollView) {
        if ([keyPath isEqualToString:scrollViewContentOffset]) {
            // 当scrolllView滚动时,让跟踪器跟随scrollView滑动
            [self beginMoveTrackerFollowScrollView:self.bridgeScrollView];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - setter

- (void)setBridgeScrollView:(UIScrollView *)bridgeScrollView {
    _bridgeScrollView = bridgeScrollView;
    if (bridgeScrollView) {
        
        [bridgeScrollView addObserver:self forKeyPath:scrollViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
    } else {
        NSLog(@"你传了一个空的scrollView");
    }
}


- (void)setShowFuntionButton:(BOOL)showFuntionButton {
    _showFuntionButton = showFuntionButton;
    self.functionButton.hidden = !showFuntionButton;
    self.shadowLine.hidden = !showFuntionButton;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 修正scrollView偏移
    [self moveItemScrollViewWithSelectedButton:self.selectedButton];
}

- (void)setItemPadding:(CGFloat)itemPadding {
    _itemPadding = itemPadding;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 修正scrollView偏移
    [self moveItemScrollViewWithSelectedButton:self.selectedButton];
}
- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex {
    _selectedItemIndex = selectedItemIndex;
    if (self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:selectedItemIndex];
        [self buttonInPageMenuClicked:button];
    }
}

- (void)setDelegate:(id<SPPageMenuDelegate>)delegate {
    if (delegate == _delegate) {return;}
    _delegate = delegate;
    if (self.buttons.count) {
        SPItem *button = [self.buttons objectAtIndex:_selectedItemIndex];
        [self delegatePerformMethodWithFromIndex:button.tag-tagBaseValue toIndex:button.tag-tagBaseValue];
        [self moveItemScrollViewWithSelectedButton:button];
        //[self buttonInPageMenuClicked:button];
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 修正scrollView偏移
    [self moveItemScrollViewWithSelectedButton:self.selectedButton];
}



#pragma mark - getter

- (NSArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray *)buttons {
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
        
    }
    return _buttons;
}

- (NSMutableDictionary *)setupWidths {
    
    if (!_setupWidths) {
        _setupWidths = [NSMutableDictionary dictionary];
    }
    return _setupWidths;
}

- (UIImageView *)tracker {
    
    if (!_tracker) {
        _tracker = [[UIImageView alloc] init];
        _tracker.layer.cornerRadius = _trackerHeight * 0.5;
        _tracker.layer.masksToBounds = YES;
    }
    return _tracker;
}


#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat backgroundViewX = self.bounds.origin.x+_contentInset.left;
    CGFloat backgroundViewY = self.bounds.origin.y+_contentInset.top;
    CGFloat backgroundViewW = self.bounds.size.width-(_contentInset.left+_contentInset.right);
    CGFloat backgroundViewH = self.bounds.size.height-(_contentInset.top+_contentInset.bottom);
    self.backgroundView.frame = CGRectMake(backgroundViewX, backgroundViewY, backgroundViewW, backgroundViewH);
    
    CGFloat dividingLineW = self.bounds.size.width;
    CGFloat dividingLineH = 0;
    CGFloat dividingLineX = 0;
    CGFloat dividingLineY = self.bounds.size.height-dividingLineH;
    self.dividingLine.frame = CGRectMake(dividingLineX, dividingLineY, dividingLineW, dividingLineH);

    CGFloat functionButtonH = backgroundViewH-dividingLineH;
    CGFloat functionButtonW = functionButtonH;
    CGFloat functionButtonX = backgroundViewW-functionButtonW;
    CGFloat functionButtonY = 0;
    self.functionButton.frame = CGRectMake(functionButtonX, functionButtonY, functionButtonW, functionButtonH);
    self.shadowLine.frame = CGRectMake(functionButtonX, functionButtonY+functionButtonH/5, functionButtonW, functionButtonH-functionButtonH/5*2);
    
    CGFloat itemScrollViewX = 0;
    CGFloat itemScrollViewY = 0;
    CGFloat itemScrollViewW = self.showFuntionButton ? backgroundViewW-functionButtonW : backgroundViewW;
    CGFloat itemScrollViewH = backgroundViewH-dividingLineH;
    self.itemScrollView.frame = CGRectMake(itemScrollViewX, itemScrollViewY, itemScrollViewW, itemScrollViewH);
    
    __block CGFloat buttonW = 0.0;
    __block CGFloat lastButtonMaxX = 12.0;
    
    CGFloat contentW = 0.0; // 文字宽
    CGFloat contentW_sum = 0.0; // 所有文字宽度之和
    NSMutableArray *buttonWidths = [NSMutableArray array];
    // 提前计算每个按钮的宽度，目的是为了计算间距
    for (int i= 0 ; i < self.buttons.count; i++) {
        SPItem *button = self.buttons[i];
        
        CGFloat setupButtonW = [[self.setupWidths objectForKey:[NSString stringWithFormat:@"%zd",i]] floatValue];
        CGFloat textW = 65;
        CGFloat imageW = button.currentImage.size.width;
        if (button.currentTitle && !button.currentImage) {
            contentW = textW;
        }
        if (setupButtonW) {
            contentW_sum += setupButtonW;
            [buttonWidths addObject:@(setupButtonW)];
        } else {
            contentW_sum += contentW;
            [buttonWidths addObject:@(contentW)];
        }
    }
    CGFloat diff = itemScrollViewW - contentW_sum;
    
    [self.buttons enumerateObjectsUsingBlock:^(SPItem *button, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat setupButtonW = [[self.setupWidths objectForKey:[NSString stringWithFormat:@"%zd",idx]] floatValue];
            buttonW = [buttonWidths[idx] floatValue];
            if (idx == 0) {
                button.frame = CGRectMake(_itemPadding*0.5+lastButtonMaxX, 8, buttonW, 30);
            } else {
                button.frame = CGRectMake(_itemPadding+lastButtonMaxX, 8, buttonW, 30);

            }
        lastButtonMaxX = CGRectGetMaxX(button.frame);
    }];
    
    [self resetSetupTrackerFrameWithSelectedButton:self.selectedButton];
    self.itemScrollView.contentSize = CGSizeMake(lastButtonMaxX+_itemPadding*0.5, 0);
    if (self.translatesAutoresizingMaskIntoConstraints == NO) {
        [self moveItemScrollViewWithSelectedButton:self.selectedButton];
    }
}

- (void)resetSetupTrackerFrameWithSelectedButton:(UIButton *)selectedButton {
    
    CGFloat trackerX;
    CGFloat trackerY;
    CGFloat trackerW;
    CGFloat trackerH;
    
    CGFloat selectedButtonWidth = selectedButton.frame.size.width;
    
    trackerW = selectedButtonWidth;
    trackerH = _trackerHeight;
    trackerX = selectedButton.frame.origin.x;
    trackerY = self.itemScrollView.bounds.size.height - trackerH;
    self.tracker.frame = CGRectMake(trackerX, trackerY, trackerW, trackerH);
    CGPoint trackerCenter = self.tracker.center;
    trackerCenter.x = selectedButton.center.x;
    self.tracker.center = trackerCenter;
}

- (void)dealloc {
    [self.bridgeScrollView removeObserver:self forKeyPath:scrollViewContentOffset];
}

@end





