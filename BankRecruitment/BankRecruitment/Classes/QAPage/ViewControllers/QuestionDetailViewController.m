//
//  QuestionDetailViewController.m
//  Recruitment
//
//  Created by humengfan on 2020/10/17.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "QAContactTableViewCell.h"
#import "DKSKeyboardView.h"
@interface QuestionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DKSKeyboardDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *questionContentLab;
@property (nonatomic, strong) UILabel *contactNumLab;
@property (nonatomic, strong) UILabel *followNumLab;
@property (nonatomic, strong) UILabel *questionTimeLab;
@property (nonatomic, strong) UILabel *questionDetailContentLab;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, strong) DKSKeyboardView *keyView;
@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    [self drawViews];
    [self initTopHeadView];
   
}
- (void)drawViews{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
-(void)initTopHeadView{
    UIView * headView = [UIView new];
    headView.frame = CGRectMake(0, 0, Screen_Width, 0);
    self.headImg = [UIImageView new];
    [headView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(15);
        make.top.equalTo(headView).offset(17);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    self.userNameLab= [[UILabel alloc] init];
    self.userNameLab.font = [UIFont systemFontOfSize:12];
    self.userNameLab.textAlignment = NSTextAlignmentLeft;
    self.userNameLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.userNameLab.text = @"暂无数据";
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.mas_right).offset(5);
        make.centerY.equalTo(self.headImg);
    }];
    self.questionContentLab= [[UILabel alloc] init];
    self.questionContentLab.numberOfLines = 0;
    self.questionContentLab.preferredMaxLayoutWidth = Screen_Width-24;
    self.questionContentLab.font = [UIFont systemFontOfSize:15];
    self.questionContentLab.textAlignment = NSTextAlignmentLeft;
    self.questionContentLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.questionContentLab.text = @"四级没有考过，可以报考分行县级的五大行吗？";
    [self.questionContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(headView).offset(12);
           make.bottom.equalTo(self.headImg.mas_bottom).offset(24);
            make.right.equalTo(headView).offset(-12);
    }];
    UIImageView *contactImg = [UIImageView new];
    [headView addSubview:contactImg];
    [contactImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(13);
        make.top.equalTo(self.questionContentLab).offset(19);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    self.contactNumLab= [[UILabel alloc] init];
    self.contactNumLab.font = [UIFont systemFontOfSize:13];
    self.contactNumLab.textAlignment = NSTextAlignmentLeft;
    self.contactNumLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.contactNumLab.text = @"23";
    [headView addSubview:self.contactNumLab];
    [self.contactNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactImg.mas_right).offset(5);
        make.centerY.equalTo(contactImg);
    }];
    UIImageView *followImg = [UIImageView new];
    [headView addSubview:followImg];
    [followImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contactNumLab.mas_right).offset(23);
        make.centerY.equalTo(contactImg);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    self.followNumLab= [[UILabel alloc] init];
    self.followNumLab.font = [UIFont systemFontOfSize:13];
    self.followNumLab.textAlignment = NSTextAlignmentLeft;
    self.followNumLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.followNumLab.text = @"23";
    [headView addSubview:self.followNumLab];
    [self.followNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followImg.mas_right).offset(5);
        make.centerY.equalTo(contactImg);
    }];
    self.questionTimeLab= [[UILabel alloc] init];
    self.questionTimeLab.font = [UIFont systemFontOfSize:12];
    self.questionTimeLab.textAlignment = NSTextAlignmentRight;
    self.questionTimeLab.textColor = [UIColor colorWithHex:@"#999999"];
    self.questionTimeLab.text = @"23";
    [headView addSubview:self.questionTimeLab];
    [self.questionTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-10);
        make.centerY.equalTo(contactImg);
    }];
    UIView * speatorView = [UIView new];
    speatorView.backgroundColor = [UIColor colorWithHex:@"#F3F3F3"];
    [headView addSubview:speatorView];
    [speatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(contactImg.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    self.questionDetailContentLab= [[UILabel alloc] init];
    self.questionDetailContentLab.font = [UIFont systemFontOfSize:13];
    self.questionDetailContentLab.textAlignment = NSTextAlignmentCenter;
    self.questionDetailContentLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.questionDetailContentLab.text = @"23";
    [headView addSubview:self.questionDetailContentLab];
    [self.questionDetailContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(-54);
        make.left.equalTo(headView).offset(54);
        make.top.equalTo(speatorView.mas_bottom).offset(16);
        make.height.mas_equalTo(50);
    }];
    
   self.keyView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, Screen_Height -  StatusBarAndNavigationBarHeight - 50-TabbarSafeBottomMargin, Screen_Width, 50)];
   //设置代理方法
   self.keyView.delegate = self;
   [self.view addSubview:_keyView];
   [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(headView.mas_bottom).offset(10);
        make.bottom.equalTo(self.view).offset(-50-TabbarSafeBottomMargin);
    }];
}


#pragma mark ====== DKSKeyboardDelegate ======
//发送的文案
- (void)textViewContentText:(NSString *)textStr {
   
}

//keyboard的frame改变
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY {
   
   
}
#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
    //    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QAContactTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QAContactTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 10)];
  view.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
    
  UILabel *label = [[UILabel alloc] init];
  label.font = [UIFont systemFontOfSize:12];
  label.textAlignment = NSTextAlignmentRight;
  label.textColor = [UIColor colorWithHex:@"#999999"];
  label.text = @"23";
  NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评论专区（%d）",30]];
 [titleAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    label.attributedText = titleAttributeString;
  [view addSubview:label];
  [label mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(view).offset(13);
      make.centerY.equalTo(view);
  }];
    return view;
}
#pragma mark ====== 点击UITableView ======
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //收回键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    //若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerNib:[UINib nibWithNibName:@"QAContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"QAContactTableViewCell"];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = kColorBarGrayBackground;
        [self.view addSubview:_tableview];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        tapGesture.delegate = self;
        [_tableview addGestureRecognizer:tapGesture];
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _tableview;
}
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
